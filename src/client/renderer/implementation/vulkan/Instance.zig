const std = @import("std");
const vk = @import("vulkan");

const Self = @This();

vki: InstanceDispatch,
handle: vk.Instance,

const BaseDispatch = struct {
    vkCreateInstance: vk.PfnCreateInstance,

    usingnamespace vk.BaseWrapper(@This());
};

const InstanceDispatch = struct {
    vkDestroyInstance: vk.PfnDestroyInstance,

    usingnamespace vk.InstanceWrapper(@This());
};

pub fn init(
    loader: vk.PfnGetInstanceProcAddr,
    inst_exts: []const [*:0]const u8,
    app_info: vk.ApplicationInfo
) !Self {
    const vkb = try BaseDispatch.load(loader);

    const handle = try vkb.createInstance(.{
        .flags = .{},
        .p_application_info = &app_info,
        .enabled_layer_count = 0,
        .pp_enabled_layer_names = undefined,
        .enabled_extension_count = @intCast(u32, inst_exts.len),
        .pp_enabled_extension_names = inst_exts.ptr,
    }, null);

    return Self{
        // Instance is leaked if the following fails.
        .vki = try InstanceDispatch.load(handle, loader),
        .handle = handle,
    };
}

pub fn deinit(self: *Self) void {
    self.vki.destroyInstance(self.handle, null);
    self.* = undefined;
}
