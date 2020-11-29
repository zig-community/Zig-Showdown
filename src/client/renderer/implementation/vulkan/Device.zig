const std = @import("std");
const vk = @import("vulkan");
const Instance = @import("Instance.zig");
const Allocator = std.mem.Allocator;

const Self = @This();

vkd: DeviceDispatch,
handle: vk.Device,

pdev: PhysicalDevice,
graphics_queue: Queue,
compute_queue: Queue,
present_queue: Queue,

pub const Queue = struct {
    handle: vk.Queue,
    family: u32,
    index: u32,

    pub fn init(vkd: DeviceDispatch, dev: vk.Device, family: u32, index: u32) Queue {
        return .{
            .handle = vkd.getDeviceQueue(dev, family, index),
            .family = family,
            .index = index,
        };
    }
};

/// This structure represents a physical device (GPU) on the host system, along with its
/// (memory) properties.
pub const PhysicalDevice = struct {
    handle: vk.PhysicalDevice,
    props: vk.PhysicalDeviceProperties,
    mem_props: vk.PhysicalDeviceMemoryProperties,

    pub fn init(instance: Instance, handle: vk.PhysicalDevice) PhysicalDevice {
        return PhysicalDevice{
            .handle = handle,
            .props = instance.vki.getPhysicalDeviceProperties(handle),
            .mem_props = instance.vki.getPhysicalDeviceMemoryProperties(handle),
        };
    }

    /// Return the name of the device, as reported by Vulkan.
    pub fn name(self: PhysicalDevice) []const u8 {
        // device_name is guaranteed to be zero-terminated
        const len = std.mem.indexOfScalar(u8, &self.props.device_name, 0).?;
        return self.props.device_name[0 .. len];
    }

    /// Query whether this physical device is likely to support the given `surface` at all.
    pub fn supportsSurface(self: PhysicalDeviceInfo, instance: Instance, surface: vk.SurfaceKHR) !bool {
        var format_count: u32 = undefined;
        _ = try instance.vki.getPhysicalDeviceSurfaceFormatsKHR(self.handle, surface, &format_count, null);

        var present_mode_count: u32 = undefined;
        _ = try instance.vki.getPhysicalDeviceSurfacePresentModesKHR(self.handle, surface, &present_mode_count, null);

        return format_count > 0 and present_mode_count > 0;
    }
};

const DeviceDispatch = struct {
    vkDestroyDevice: vk.PfnDestroyDevice,
    vkGetDeviceQueue: vk.PfnGetDeviceQueue,

    usingnamespace vk.DeviceWrapper(@This());
};
