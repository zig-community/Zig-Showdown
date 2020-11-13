const std = @import("std");
const builtin = @import("builtin");
const vk = @import("vulkan");
const Platform = @import("platform.zig").Platform;

extern fn vkGetInstanceProcAddr(vk.Instance, [*:0]const u8) (?fn () callconv(.C) void);

pub const Engine = struct {
    instance: *vk.Instance = undefined,

    pub fn init() !Engine {
        const CreateInstanceDispatch = struct {
            vkCreateInstance: vk.PfnCreateInstance,
            usingnamespace vk.BaseWrapper(@This());
        };
        const create_instance_dispatch = try CreateInstanceDispatch.load(vkGetInstanceProcAddr);

        const app_info = vk.ApplicationInfo{
            .p_application_name = "SHOWDOWN",
            .application_version = vk.makeVersion(0, 0, 0),
            .p_engine_name = "SHOWDOWN",
            .engine_version = vk.makeVersion(0, 0, 0),
            .api_version = vk.API_VERSION_1_2,
        };

        const instance_extensions = blk: {
            if (builtin.mode == .Debug) {
                break :blk [_][*:0]const u8{ "VK_KHR_surface", Platform.vulkan_surface_extension, "VK_EXT_debug_utils" };
            } else {
                break :blk [_][*:0]const u8{ "VK_KHR_surface", Platform.vulkan_surface_extension };
            }
        };

        const instance = try create_instance_dispatch.createInstance(.{
            .flags = .{},
            .p_application_info = &app_info,
            .enabled_layer_count = 0,
            .pp_enabled_layer_names = undefined,
            .enabled_extension_count = instance_extensions.len,
            .pp_enabled_extension_names = &instance_extensions,
        }, null);

        return Engine{};
    }
    pub fn deinit(self: *Engine) void {}
};
