const std = @import("std");
const zwl = @import("zwl");
const vk = @import("vulkan");
const WindowPlatform = @import("../../../main.zig").WindowPlatform;
const Renderer = @import("../../../Renderer.zig");
const Color = @import("../../Color.zig");
const Resources = @import("Resources.zig");

const Instance = @import("Instance.zig");
const Device = @import("Device.zig");
const Swapchain = @import("Swapchain.zig");

const PostProcessPipeline = @import("PostProcessPipeline.zig");

const asManyPtr = @import("util.zig").asManyPtr;
const Allocator = std.mem.Allocator;

pub const log = std.log.scoped(.vulkan);

const Self = @This();
const frame_overlap = 2;
const frame_timeout = 1 * std.time.ns_per_s;

pub const Configuration = struct {
    multisampling: ?u8 = null,
};

const app_info = vk.ApplicationInfo{
    .p_application_name = "SHOWDOWN",
    .application_version = vk.makeVersion(0, 0, 0),
    .p_engine_name = "SHOWDOWN (Vulkan)",
    .engine_version = vk.makeVersion(0, 0, 0),
    .api_version = vk.API_VERSION_1_0,
};

const instance_extensions = [_][*:0]const u8{
    vk.extension_info.khr_surface.name,
    vk.extension_info.khr_xlib_surface.name,
    // TODO: Extend with platform types
};

const device_extensions = [_][*:0]const u8{
    vk.extension_info.khr_swapchain.name,
};

allocator: *Allocator,
libvulkan: std.DynLib,
instance: Instance,
device: Device,
surface: vk.SurfaceKHR,
swapchain: Swapchain,
frame_nr: usize,
frames: [frame_overlap]Frame,
post_process_pipeline: PostProcessPipeline,

pub fn init(allocator: *Allocator, window: *WindowPlatform.Window, configuration: Configuration) !Self {
    log.info("Initializing Vulkan rendering backend", .{});
    // TODO: Don't hardcode this, make it work on other platforms as well
    var libvulkan = std.DynLib.openZ("/usr/lib/libvulkan.so.1") catch |err| {
        log.crit("Failed to open Vulkan shared library", .{});
        return err;
    };
    errdefer libvulkan.close();

    const loader = libvulkan.lookup(vk.PfnGetInstanceProcAddr, "vkGetInstanceProcAddr") orelse {
        log.crit("Failed to find vkGetInstanceProcAddr in libvulkan", .{});
        return error.SymbolNotFound;
    };

    var instance = try Instance.init(allocator, loader, &instance_extensions, app_info);
    errdefer instance.deinit();

    const surface = try instance.createSurface(window);
    errdefer instance.vki.destroySurfaceKHR(instance.handle, surface, null);

    var device = instance.findAndCreateDevice(allocator, .{
        .surface = surface,
        .required_extensions = &device_extensions,
    }) catch |err| switch (err) {
        error.NoSuitableDevice => {
            log.crit("Failed to find a suitable GPU", .{});
            return err;
        },
        else => return err,
    };
    errdefer device.deinit();

    log.info("Using device '{}'", .{device.pdev.name()});

    const window_dim = window.getSize();
    const qfi = device.uniqueQueueFamilies();
    var swapchain = try Swapchain.init(&instance, &device, allocator, .{
        .surface = surface,
        .vsync = false,
        .desired_extent = .{ .width = window_dim[0], .height = window_dim[1] },
        .swap_image_usage = .{ .color_attachment_bit = true },
        .queue_family_indices = qfi.asConstSlice(),
    });
    errdefer swapchain.deinit(&device);

    log.info("Created swapchain with surface format {}", .{ @tagName(swapchain.surface_format.format) });

    var frames: [frame_overlap]Frame = undefined;
    var n_successfully_created: usize = 0;
    errdefer for (frames[0 .. n_successfully_created]) |*frame| frame.deinit(&device);
    for (frames) |*frame, i| {
        frame.* = try Frame.init(&device);
        n_successfully_created = i;
    }

    var self = Self{
        .allocator = allocator,
        .libvulkan = libvulkan,
        .instance = instance,
        .device = device,
        .surface = surface,
        .swapchain = swapchain,
        .frame_nr = 0,
        .frames = frames,
        .post_process_pipeline = undefined,
    };

    try PostProcessPipeline.init(&self);
    errdefer PostProcessPipeline.deinit(&self);

    return self;
}

pub fn deinit(self: *Self) void {
    log.debug("Rendered {} frames", .{ self.frame_nr });

    self.waitForAllFrames() catch |err| switch (err) {
        error.Timeout => log.warn("Recieved timeout during deinitialization, was endFrame called?", .{}),
        else => {
            // These errors are unrecoverable anyway
            log.crit("Received critical error '{}' during deinitialization", .{ @errorName(err) });
            return;
        }
    };

    PostProcessPipeline.deinit(self);

    for (self.frames) |*frame| frame.deinit(&self.device);
    self.swapchain.deinit(&self.device);
    self.instance.vki.destroySurfaceKHR(self.instance.handle, self.surface, null);
    self.device.deinit();
    self.instance.deinit();
    self.libvulkan.close();
    self.* = undefined;
}

pub fn beginFrame(self: *Self) !void {
    const frame = &self.frames[self.frame_nr % frame_overlap];
    try frame.wait(&self.device);

    const present_state = self.swapchain.acquireNextImage(&self.device, frame.image_acquired) catch |err| switch (err) {
        error.OutOfDateKHR => return error.OutOfDateKHR, // TODO: Catch and reinitialize swapchain
        else => |other| return other,
    };

    // TODO: Recreate swapchain if suboptimal
    if (present_state == .suboptimal) {
        log.alert("Swapchain suboptimal or out of date\n", .{});
    }
}

pub fn endFrame(self: *Self) !void {
    const frame = &self.frames[self.frame_nr % frame_overlap];

    const submit_info = vk.SubmitInfo{
        .wait_semaphore_count = 1,
        .p_wait_semaphores = asManyPtr(&frame.image_acquired),
        .p_wait_dst_stage_mask = &[_]vk.PipelineStageFlags{ .{.bottom_of_pipe_bit = true} },
        .command_buffer_count = 0,
        .p_command_buffers = undefined,
        .signal_semaphore_count = 1,
        .p_signal_semaphores = asManyPtr(&frame.render_finished),
    };

    try self.device.vkd.queueSubmit(self.device.graphics_queue.handle, 1, asManyPtr(&submit_info), frame.frame_fence);
    try self.swapchain.present(&self.device, &[_]vk.Semaphore{ frame.render_finished });

    self.frame_nr += 1;
}

pub fn clear(self: *Self, rt: Renderer.RenderTarget, color: Color) void {
    // stub
    log.debug("clear", .{});
}

pub fn submitUiPass(self: *Self, render_target: Renderer.RenderTarget, pass: Renderer.UiPass) !void {
    // stub
    log.debug("ui pass", .{});
}

pub fn submitScenePass(self: *Self, render_target: Renderer.RenderTarget, pass: Renderer.ScenePass) !void {
    // stub
    log.debug("scene pass", .{});
}

pub fn submitTransition(self: *Self, render_target: Renderer.RenderTarget, transition: Renderer.Transition) !void {
    // stub
    log.debug("transition pass", .{});
}

pub const Texture = void;

pub fn createTexture(self: *Self, texture: *Resources.Texture) !Texture {
    return {};
}

pub fn destroyTexture(self: *Self, texture: *Texture) void {}

pub const Model = void;

pub fn createModel(self: *Self, model: *Resources.Model) Texture {
    return {};
}

pub fn destroyModel(self: *Self, model: *Model) void {}

fn waitForAllFrames(self: *Self) !void {
    for (self.frames) |frame| try frame.wait(&self.device);
}

const Frame = struct {
    image_acquired: vk.Semaphore,
    render_finished: vk.Semaphore,
    frame_fence: vk.Fence,

    fn init(device: *const Device) !Frame {
        const image_acquired = try device.vkd.createSemaphore(device.handle, .{.flags = .{}}, null);
        errdefer device.vkd.destroySemaphore(device.handle, image_acquired, null);

        const render_finished = try device.vkd.createSemaphore(device.handle, .{.flags = .{}}, null);
        errdefer device.vkd.destroySemaphore(device.handle, render_finished, null);

        const frame_fence = try device.vkd.createFence(device.handle, .{.flags = .{.signaled_bit = true}}, null);
        errdefer device.vkd.destroyFence(device.handle, frame_fence, null);

        return Frame{
            .image_acquired = image_acquired,
            .render_finished = render_finished,
            .frame_fence = frame_fence,
        };
    }

    fn deinit(self: *Frame, device: *const Device) void {
        device.vkd.destroyFence(device.handle, self.frame_fence, null);
        device.vkd.destroySemaphore(device.handle, self.render_finished, null);
        device.vkd.destroySemaphore(device.handle, self.image_acquired, null);
        self.* = undefined;
    }

    fn wait(self: Frame, device: *const Device) !void {
        const fence = asManyPtr(&self.frame_fence);
        const result = try device.vkd.waitForFences(device.handle, 1, fence, vk.TRUE, frame_timeout);
        if (result == .timeout) {
            return error.Timeout;
        }

        try device.vkd.resetFences(device.handle, 1, fence);
    }
};
