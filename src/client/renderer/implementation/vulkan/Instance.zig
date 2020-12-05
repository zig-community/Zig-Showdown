const std = @import("std");
const vk = @import("vulkan");
const xcb = @import("xcb.zig");
const Device = @import("Device.zig");
const WindowPlatform = @import("../../../main.zig").WindowPlatform;
const Allocator = std.mem.Allocator;
const PhysicalDevice = Device.PhysicalDevice;
const log = @import("Vulkan.zig").log;

const Self = @This();

vki: InstanceDispatch,
handle: vk.Instance,

/// Initialize a Vulkan instance. This entails retrieving all required base and instance
/// function pointers, as well as actually initializing the instance. `inst_exts` is a list
/// of instance extensions that are required.
/// This function also checks (and reports) which extensions might not be available. The
/// list of extensions is allocated through `allocator`.
pub fn init(
    allocator: *Allocator,
    loader: vk.PfnGetInstanceProcAddr,
    required_extensions: []const [*:0]const u8,
    app_info: vk.ApplicationInfo
) !Self {
    const vkb = try BaseDispatch.load(loader);

    // Check whether the Vulkan implementation supports the required extensions.
    const extensions = try supportedExtensions(vkb, allocator);
    defer allocator.free(extensions);

    var tmp_exts = try std.mem.dupe(allocator, [*:0]const u8, required_extensions);
    defer allocator.free(tmp_exts);
    const missing_extensions = removeSupportedExtensions(extensions, tmp_exts);
    if (missing_extensions.len > 0) {
        log.crit("{} required extension(s) not supported", .{ missing_extensions.len });
        for (missing_extensions) |ext_z| {
            log.crit("Required extension '{}' not supported", .{ std.mem.spanZ(ext_z) });
        }
        return error.ExtensionNotPresent;
    }

    const handle = try vkb.createInstance(.{
        .flags = .{},
        .p_application_info = &app_info,
        .enabled_layer_count = 0,
        .pp_enabled_layer_names = undefined,
        .enabled_extension_count = @intCast(u32, required_extensions.len),
        .pp_enabled_extension_names = required_extensions.ptr,
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

/// Create a Vulkan Surface for the given Window handle.
pub fn createSurface(self: Self, window: *WindowPlatform.Window) !vk.SurfaceKHR {
    // TODO: Support other platforms.
    const x_display = @ptrCast(*WindowPlatform.PlatformXlib, window.platform).display;
    const x_window = @ptrCast(*WindowPlatform.PlatformXlib.Window, window).window;

    return try self.vki.createXlibSurfaceKHR(self.handle, .{
        .flags = .{},
        .dpy = @ptrCast(*vk.Display, x_display),
        .window = x_window,
    }, null);
}

/// Returns an array of instance extensions that is supported by the Vulkan implementation.
pub fn supportedExtensions(vkb: BaseDispatch, allocator: *Allocator) ![]vk.ExtensionProperties {
    var count: u32 = undefined;
    _ = try vkb.enumerateInstanceExtensionProperties(null, &count, null);

    const extensions = try allocator.alloc(vk.ExtensionProperties, count);
    errdefer allocator.free(extensions);

    _ = try vkb.enumerateInstanceExtensionProperties(null, &count, extensions.ptr);
    return extensions;
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

/// This struct models a list of requirements a potential device needs to satisfy in order
/// to be used as render device.
/// TODO: Add method to require a specific device (pipelineCacheUUD).
/// TODO: Add method to require specifuc device features and limits to be present.
const DeviceRequirements = struct {
    /// The surface the device needs to be compatible with.
    surface: vk.SurfaceKHR,

    /// A list of extensions that the device needs to support.
    required_extensions: []const [*:0]const u8,
};

/// Attempt to find *any* device that supports surface and has the required extensions and
/// queues.
pub fn findAndCreateDevice(
    self: Self,
    allocator: *Allocator,
    requirements: DeviceRequirements,
) !Device {
    const pdevs = try self.enumeratePhysicalDevices(allocator);
    defer allocator.free(pdevs);
    log.debug("enumeratePhysicalDevices() returned {} device(s)", .{ pdevs.len });

    var tmp_exts = try allocator.alloc([*:0]const u8, requirements.required_extensions.len);
    defer allocator.free(tmp_exts);

    for (pdevs) |pdev| {
        const msg_base_fmt = "Cannot use device '{}': ";
        const msg_base_args = .{ pdev.name() };

        // First, check whether the device supports the surface at all.
        if (!(try pdev.supportsSurface(self, requirements.surface))) {
            log.info(msg_base_fmt ++ "surface not supported", msg_base_args);
            continue;
        }

        // Second, check whether the device supports the required extensions
        const extensions = try pdev.supportedExtensions(self, allocator);
        defer allocator.free(extensions);

        std.mem.copy([*:0]const u8, tmp_exts, requirements.required_extensions);
        const missing_extensions = removeSupportedExtensions(extensions, tmp_exts);

        if (missing_extensions.len > 0) {
            log.info(msg_base_fmt ++ "{} required extension(s) not supported", msg_base_args ++ .{ missing_extensions.len });
            for (missing_extensions) |ext_z| {
                log.info("Required extension '{}' not supported", .{ std.mem.spanZ(ext_z) });
            }
            continue;
        }

        // Third, try to allocate graphics, compute and present queues.
        const queues = pdev.allocateQueues(allocator, self, requirements.surface) catch |err| {
            const message = switch (err) {
                error.NoGraphicsQueue => "Graphics not supported",
                error.NoComputeQueue => "Compute not supported",
                error.NoPresentQueue => "Present not supported",
                else => |narrow| return narrow,
            };

            log.info(msg_base_fmt ++ "{}", msg_base_args ++ .{ message });
            continue;
        };
        defer queues.deinit(allocator);

        // Everything seems to be fine, create the device.
        return Device.init(self, pdev, requirements.required_extensions, queues);
    }

    return error.NoSuitableDevice;
}

/// Removes any extension in `required_extensions` that appears in `supported_extensions`.
fn removeSupportedExtensions(supported_extensions: []const vk.ExtensionProperties, required_extensions: [][*:0]const u8) [][*:0]const u8 {
    var write_index: usize = 0;
    for (required_extensions) |ext_z| {
        const ext = std.mem.spanZ(ext_z);
        for (supported_extensions) |props| {
            const len = std.mem.indexOfScalar(u8, &props.extension_name, 0).?;
            const ext_name = props.extension_name[0 .. len];
            if (std.mem.eql(u8, ext, ext_name))
                break;
        } else {
            required_extensions[write_index] = ext_z;
            write_index += 1;
        }
    }

    return required_extensions[0 .. write_index];
}

pub const BaseDispatch = struct {
    vkCreateInstance: vk.PfnCreateInstance,
    vkEnumerateInstanceExtensionProperties: vk.PfnEnumerateInstanceExtensionProperties,

    usingnamespace vk.BaseWrapper(@This());
};

pub const InstanceDispatch = struct {
    vkDestroyInstance: vk.PfnDestroyInstance,
    vkEnumeratePhysicalDevices: vk.PfnEnumeratePhysicalDevices,
    vkEnumerateDeviceExtensionProperties: vk.PfnEnumerateDeviceExtensionProperties,
    vkGetPhysicalDeviceProperties: vk.PfnGetPhysicalDeviceProperties,
    vkGetPhysicalDeviceMemoryProperties: vk.PfnGetPhysicalDeviceMemoryProperties,
    vkGetPhysicalDeviceSurfaceFormatsKHR: vk.PfnGetPhysicalDeviceSurfaceFormatsKHR,
    vkGetPhysicalDeviceSurfacePresentModesKHR: vk.PfnGetPhysicalDeviceSurfacePresentModesKHR,
    vkGetPhysicalDeviceQueueFamilyProperties: vk.PfnGetPhysicalDeviceQueueFamilyProperties,
    vkGetPhysicalDeviceSurfaceSupportKHR: vk.PfnGetPhysicalDeviceSurfaceSupportKHR,
    vkCreateXlibSurfaceKHR: vk.PfnCreateXlibSurfaceKHR,
    vkDestroySurfaceKHR: vk.PfnDestroySurfaceKHR,
    vkCreateDevice: vk.PfnCreateDevice,
    vkGetDeviceProcAddr: vk.PfnGetDeviceProcAddr,

    usingnamespace vk.InstanceWrapper(@This());
};
