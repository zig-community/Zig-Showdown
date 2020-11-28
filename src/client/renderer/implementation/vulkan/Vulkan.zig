const std = @import("std");
const zwl = @import("zwl");
const vk = @import("vulkan");
const WindowPlatform = @import("../../../main.zig").WindowPlatform;
const Renderer = @import("../../../Renderer.zig");
const Color = @import("../../Color.zig");
const Instance = @import("Instance.zig");
const system = std.os.system;
const Allocator = std.mem.Allocator;

const Self = @This();

const app_info = vk.ApplicationInfo{
    .p_application_name = "SHOWDOWN",
    .application_version = vk.makeVersion(0, 0, 0),
    .p_engine_name = "SHOWDOWN (Vulkan)",
    .engine_version = vk.makeVersion(0, 0, 0),
    .api_version = vk.API_VERSION_1_0,
};

const instance_extensions = [_][*:0]const u8{
    "VK_KHR_surface",
    // TODO: Extend with platform types
};

libvulkan: *c_void,
instance: Instance,

pub fn init(allocator: *Allocator, window: *WindowPlatform.Window) !Self {
    // TODO: Don't hardcode this, make it work on other platforms as well
    const libvulkan = system.dlopen("/usr/lib/libvulkan.so.1", system.RTLD_LAZY) orelse {
        return error.LibvulkanNotFound;
    };
    errdefer _ = system.dlclose(libvulkan);

    // dlsym (and other dl-functions) secretly take shadow parameter - return address on stack
    // https://gcc.gnu.org/bugzilla/show_bug.cgi?id=66826
    const loader = @call(.{ .modifier = .never_tail }, system.dlsym, .{ libvulkan, "vkGetInstanceProcAddr" }) orelse return error.VkGetInstanceProcAddrNotFound;

    return Self{
        .libvulkan = libvulkan,
        .instance = try Instance.init(
            @ptrCast(vk.PfnGetInstanceProcAddr, loader),
            &instance_extensions,
            app_info,
        ),
    };
}

pub fn deinit(self: *Self) void {
    self.instance.deinit();
    _ = system.dlclose(self.libvulkan);
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
