const std = @import("std");
const zwl = @import("zwl");
const vk = @import("vulkan");
const WindowPlatform = @import("../../../main.zig").WindowPlatform;
const Renderer = @import("../../../Renderer.zig");
const Color = @import("../../Color.zig");
const Instance = @import("Instance.zig");
const Device = @import("Device.zig");
const system = std.os.system;
const Allocator = std.mem.Allocator;
pub const log = std.log.scoped(.vulkan);

const Self = @This();

const app_info = vk.ApplicationInfo{
    .p_application_name = "SHOWDOWN",
    .application_version = vk.makeVersion(0, 0, 0),
    .p_engine_name = "SHOWDOWN (Vulkan)",
    .engine_version = vk.makeVersion(0, 0, 0),
    .api_version = vk.API_VERSION_1_0,
};

const instance_extensions = [_][*:0]const u8{
    vk.extension_info.khr_surface.name,
    // TODO: Extend with platform types
};

const device_extensions = [_][*:0]const u8{
    vk.extension_info.khr_swapchain.name,
};

libvulkan: std.DynLib,
instance: Instance,
device: Device,

pub fn init(allocator: *Allocator, window: *WindowPlatform.Window) !Self {
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

    const device = instance.findAndCreateDevice(allocator, .{
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

    log.info("Using device '{}'", .{ device.pdev.name() });

    return Self{
        .libvulkan = libvulkan,
        .instance = instance,
        .device = device,
    };
}

pub fn deinit(self: *Self) void {
    self.device.deinit();
    self.instance.deinit();
    self.libvulkan.close();
    self.* = undefined;
}

pub fn beginFrame(self: *Self) void {
    // stub
}

pub fn endFrame(self: *Self) void {
    // stub
}

pub fn clear(self: *Self, rt: Renderer.RenderTarget, color: Color) void {
    // stub
}

pub fn submitUiPass(self: *Self, render_target: Renderer.RenderTarget, pass: Renderer.UiPass) !void {
    // stub
}

pub fn submitScenePass(self: *Self, render_target: Renderer.RenderTarget, pass: Renderer.ScenePass) !void {
    // stub
}

pub fn submitTransition(self: *Self, render_target: Renderer.RenderTarget, transition: Renderer.Transition) !void {
    // stub
}
