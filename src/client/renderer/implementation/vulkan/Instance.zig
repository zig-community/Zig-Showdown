const std = @import("std");
const vk = @import("vulkan");
const Device = @import("Device.zig");
const Allocator = std.mem.Allocator;
const PhysicalDevice = Device.PhysicalDevice;

const Self = @This();

vki: InstanceDispatch,
handle: vk.Instance,

/// Initialize a Vulkan instance. This entails retrieving all required base and instance
/// function pointers, as well as actually initializing the instance. `inst_exts` is a list
/// of instance extensions that are required.
pub fn init(
    loader: vk.PfnGetInstanceProcAddr,
    inst_exts: []const [*:0]const u8,
    app_info: vk.ApplicationInfo
) !Self {
    const vkb = try BaseDispatch.load(loader);

    // TODO: Manually check extension support?
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

/// Retrieve a list of PhysicalDevice's that the system supports. The result needs to be
/// freed with `allocator`.
pub fn enumeratePhysicalDevices(self: Self, allocator: *Allocator) ![]PhysicalDevice {
    var device_count: u32 = undefined;
    _ = try self.vki.enumeratePhysicalDevices(self.handle, &device_count, null);

    const handles = try allocator.alloc(vk.PhysicalDevice, device_count);
    defer allocator.free(handles);
    _ = try self.vki.enumeratePhysicalDevices(self.handle, &device_count, handles.ptr);

    const pdevs = try allocator.alloc(PhysicalDevice, device_count);
    errdefer allocator.free(pdevs);
    for (pdevs) |*pdev, i| pdev.* = PhysicalDevice.init(self, handles[i]);

    return pdevs;
}

/// Attempt to find *any* device that supports surface and has the required extensions and
/// queues.
pub fn findAndCreateDevice(
    self: Self,
    allocator: *Allocator,
    surface: vk.SurfaceKHR,
    extensions: []const [*:0]const u8,
) !Device {
    unreachable; // TODO
}

pub const BaseDispatch = struct {
    vkCreateInstance: vk.PfnCreateInstance,

    usingnamespace vk.BaseWrapper(@This());
};

pub const InstanceDispatch = struct {
    vkDestroyInstance: vk.PfnDestroyInstance,
    vkEnumeratePhysicalDevices: vk.PfnEnumeratePhysicalDevices,
    vkGetPhysicalDeviceProperties: vk.PfnGetPhysicalDeviceProperties,
    vkGetPhysicalDeviceMemoryProperties: vk.PfnGetPhysicalDeviceMemoryProperties,
    vkGetPhysicalDeviceSurfaceFormatsKHR: vk.PfnGetPhysicalDeviceSurfaceFormatsKHR,
    vkGetPhysicalDeviceSurfacePresentModesKHR: vk.PfnGetPhysicalDeviceSurfacePresentModesKHR,

    usingnamespace vk.InstanceWrapper(@This());
};
