const std = @import("std");
const vk = @import("vulkan");
const Instance = @import("Instance.zig");
const Device = @import("Device.zig");
const asManyPtr = @import("util.zig").asManyPtr;
const Allocator = std.mem.Allocator;

const Self = @This();
const acquire_timeout = 1 * std.time.ns_per_s;

/// This structure models a set of options that need to be considered when (re) creating
/// a swapchain.
pub const CreateInfo = struct {
    /// The surface backing the swapchain.
    surface: vk.SurfaceKHR,

    /// Whether vsync needs to be enabled. Currently, either mailbox or immediate is
    /// preferred, and vsync is used as fallback option. Setting this field to true
    /// overrides the present mode to .fifo_khr, which is vsync.
    vsync: bool = false,

    /// The desired extent of the swap images. Note that the actual size can differ in
    /// odd cases, for example in race conditions where the window size changes after
    /// (re)init has already been called.
    desired_extent: vk.Extent2D,

    /// The intended usage of the swap images. This is in most cases just .color_attachment_bit.
    swap_image_usage: vk.ImageUsageFlags,

    /// The list of queue families that will make use of the swap images. The indices in
    /// this slice need to be unique. The simplest method is to just pass in the result
    /// of `Device.uniqueQueueFamilies()`.
    queue_family_indices: []const u32,
};

handle: vk.SwapchainKHR,
surface_format: vk.SurfaceFormatKHR,
extent: vk.Extent2D,

allocator: *Allocator,
images: []vk.Image,
image_views: []vk.ImageView,
image_index: u32,

/// Attempt to initialize a new swapchain.
pub fn init(
    instance: *const Instance,
    device: *const Device,
    allocator: *Allocator,
    create_info: CreateInfo,
) !Self {
    var self = Self{
        .handle = .null_handle,
        .surface_format = undefined,
        .extent = undefined,
        .allocator = allocator,
        .images = try allocator.alloc(vk.Image, 0),
        .image_views = try allocator.alloc(vk.ImageView, 0),
        .image_index = undefined,
    };

    self.reinit(instance, device, create_info) catch |err| {
        self.deinit(device);
        return err;
    };

    return self;
}

/// Recreate the swapchain, where the current swapchain handle is recycled. Note that
/// if this function fails, it can still be called again. Furthermore, deinit needs to
/// be called to deinitialize the swapchain regardless whether this function fails.
pub fn reinit(
    self: *Self,
    instance: *const Instance,
    device: *const Device,
    create_info: CreateInfo,
) !void {
    const pdev = device.pdev.handle;
    self.surface_format = try findSurfaceFormat(instance, pdev, create_info, self.allocator);
    var present_mode = try findPresentMode(instance, pdev, create_info.surface, self.allocator);

    // There seems to be a bug in the validation layers that causes a message to be printed about
    // fifo being unsupported if getPhysicalDeviceSurfacePresentModesKHR is not called. To work around
    // this for now, just override the value after calling that function. (It needs to be called with a
    // a valid pointer as well it seems).
    // fifo needs to be supported on every platform, so just overriding the result here is safe.
    if (create_info.vsync) {
        present_mode = .fifo_khr;
    }

    const caps = try instance.vki.getPhysicalDeviceSurfaceCapabilitiesKHR(pdev, create_info.surface);
    self.extent = findActualExtent(caps, create_info.desired_extent);

    if (!caps.supported_usage_flags.contains(create_info.swap_image_usage)) {
        return error.UnsupportedSwapImageUsage;
    }

    var image_count = caps.min_image_count + 1;
    if (caps.max_image_count > 0) {
        image_count = std.math.min(image_count, caps.max_image_count);
    }

    const old_handle = self.handle;
    self.handle = try device.vkd.createSwapchainKHR(device.handle, .{
        .flags = .{},
        .surface = create_info.surface,
        .min_image_count = image_count,
        .image_format = self.surface_format.format,
        .image_color_space = self.surface_format.color_space,
        .image_extent = self.extent,
        .image_array_layers = 1,
        .image_usage = create_info.swap_image_usage,
        .image_sharing_mode = if (create_info.queue_family_indices.len > 1) .concurrent else .exclusive,
        .queue_family_index_count = @intCast(u32, create_info.queue_family_indices.len),
        .p_queue_family_indices = create_info.queue_family_indices.ptr,
        .pre_transform = caps.current_transform,
        .composite_alpha = .{.opaque_bit_khr = true},
        .present_mode = present_mode,
        .clipped = vk.TRUE,
        .old_swapchain = self.handle,
    }, null);

    // TODO: Destroy the handle *after* acquiring the first frame, the give the
    // presentation engine the opportunity to finish presenting to the old frames.
    // It's technically valid to nuke the swapchain at any point, ut this should
    // be a little more efficient.
    device.vkd.destroySwapchainKHR(device.handle, old_handle, null);

    try self.fetchSwapImages(device);
    try self.createImageViews(device);

    self.image_index = undefined;
}

pub fn deinit(self: *Self, device: *const Device) void {
    for (self.image_views) |view| {
        device.vkd.destroyImageView(device.handle, view, null);
    }

    self.allocator.free(self.image_views);
    self.allocator.free(self.images);
    device.vkd.destroySwapchainKHR(device.handle, self.handle, null);
    self.* = undefined;
}

pub const PresentState = enum {
    optimal,
    suboptimal,
};

/// Acquire the next image to render to. The resulting image index can be found in `self.image_index`.
/// When the image is ready to be presented to, `image_acquired` will be signalled. This function returns the
/// swapchain state: If the swapchain should be recreated (because the window was moved to a monitor with a different)
/// pixel layout, for example), .suboptimal is returned. When this function returns error.OutOfDateKHR (or .suboptimal)
/// `self.reinit` should be called.
pub fn acquireNextImage(self: *Self, device: *const Device, image_acquired: vk.Semaphore) !PresentState {
    const result = try device.vkd.acquireNextImage(device.handle, self.handle, acquire_timeout, image_acquired, .null_handle);
    self.image_index = result.image_index;

    return switch (result.result) {
        .success => PresentState.optimal,
        .suboptimal_khr => PresentState.suboptimal,
        .not_ready => unreachable, // Only reachable if timeout is zero
        .timeout => return error.AcquireTimeout,
    };
}

/// Schedule the current swap image (self.image_index) for presentation. `wait_semaphores` is a list of
/// semaphores to wait on before presentation.
pub fn present(self: *Self, device: *const Device, wait_semaphores: []const vk.Semaphore) !void {
    _ = try device.vkd.queuePresentKHR(device.present_queue.handle, .{
        .wait_semaphore_count = @intCast(u32, wait_semaphores.len),
        .p_wait_semaphores = wait_semaphores.ptr,
        .swapchain_count = 1,
        .p_swapchains = asManyPtr(&self.handle),
        .p_image_indices = asManyPtr(&self.image_index),
        .p_results = null,
    });
}

/// Fetch the swapchain's list of swap images to internal storage.
fn fetchSwapImages(self: *Self, device: *const Device) !void {
    var count: u32 = undefined;
    _ = try device.vkd.getSwapchainImagesKHR(device.handle, self.handle, &count, null);
    self.images = try self.allocator.realloc(self.images, count);
    _ = try device.vkd.getSwapchainImagesKHR(device.handle, self.handle, &count, self.images.ptr);
}

/// Create an image view for every swap chain, and store them internally.
/// Special care is taken in this function such that it leaves the internal state valid
/// for `reinit` or `deinit`.
fn createImageViews(self: *Self, device: *const Device) !void {
    for (self.image_views) |view| {
        device.vkd.destroyImageView(device.handle, view, null);
    }

    // Early returning would make `deinit()` destroy the image views again.
    // On error, simply shrink the image view array to 0 to prevent that.
    errdefer self.image_views = self.allocator.shrink(self.image_views, 0);

    self.image_views = try self.allocator.realloc(self.image_views, self.images.len);

    // Make sure to destroy successfully created image views when one fails to be created.
    var n_successfully_created: usize = 0;
    errdefer {
        for (self.image_views[0 .. n_successfully_created]) |view| {
            device.vkd.destroyImageView(device.handle, view, null);
        }
    }

    for (self.image_views) |*view, i| {
        view.* = try device.vkd.createImageView(device.handle, .{
            .flags = .{},
            .image = self.images[i],
            .view_type = .@"2d",
            .format = self.surface_format.format,
            .components = .{.r = .identity, .g = .identity, .b = .identity, .a = .identity},
            .subresource_range = .{
                .aspect_mask = .{.color_bit = true},
                .base_mip_level = 0,
                .level_count = 1,
                .base_array_layer = 0,
                .layer_count = 1,
            },
        }, null);
        n_successfully_created = i;
    }
}

/// Query for a surface format that satisfies the requirements in `create_info`.
fn findSurfaceFormat(
    instance: *const Instance,
    pdev: vk.PhysicalDevice,
    create_info: CreateInfo,
    allocator: *Allocator
) !vk.SurfaceFormatKHR {
    var count: u32 = undefined;
    _ = try instance.vki.getPhysicalDeviceSurfaceFormatsKHR(pdev, create_info.surface, &count, null);

    const surface_formats = try allocator.alloc(vk.SurfaceFormatKHR, count);
    defer allocator.free(surface_formats);

    _ = try instance.vki.getPhysicalDeviceSurfaceFormatsKHR(pdev, create_info.surface, &count, surface_formats.ptr);

    // We need to check whether the intended usage of the swapchain is supported by the surface format.
    // .color_attachment_bit is apparently always supported.

    // According to https://www.khronos.org/registry/vulkan/specs/1.2-extensions/html/vkspec.html#VUID-VkImageViewCreateInfo-usage-02274
    // transfer_src_bit and transfer_dst_bit are probably right but who knows.
    const required_format_features = vk.FormatFeatureFlags{
        .sampled_image_bit = create_info.swap_image_usage.sampled_bit,
        .storage_image_bit = create_info.swap_image_usage.storage_bit,
        .color_attachment_bit = create_info.swap_image_usage.color_attachment_bit,
        .depth_stencil_attachment_bit = create_info.swap_image_usage.depth_stencil_attachment_bit,
        .transfer_src_bit = create_info.swap_image_usage.transfer_src_bit,
        .transfer_dst_bit = create_info.swap_image_usage.transfer_dst_bit,
    };

    const preferred = vk.SurfaceFormatKHR{
        .format = .b8g8r8a8_srgb, // TODO: Maybe change for 10-bit monitors? Check with Aransentin.
        .color_space = .srgb_nonlinear_khr,
    };
    var surface_format: ?vk.SurfaceFormatKHR = null;

    for (surface_formats) |sfmt| {
        const fprops = instance.vki.getPhysicalDeviceFormatProperties(pdev, sfmt.format);
        // According to the spec, swapchain images are always created with optimal tiling.
        const tiling_features = fprops.optimal_tiling_features;
        if (!tiling_features.contains(required_format_features)) {
            continue;
        }

        if (create_info.swap_image_usage.input_attachment_bit and !(
            tiling_features.color_attachment_bit or tiling_features.depth_stencil_attachment_bit)) {
            continue;
        }

        if (std.meta.eql(sfmt, preferred)) {
            return preferred;
        } else if (surface_format == null) {
            surface_format = sfmt;
        }
    }

    return surface_format orelse error.NoSupportedSurfaceFormat;
}

/// Find a present mode. Mailbox and immediate mode are preferred, and fifo is used as a
/// fallback option.
fn findPresentMode(
    instance: *const Instance,
    pdev: vk.PhysicalDevice,
    surface: vk.SurfaceKHR,
    allocator: *Allocator
) !vk.PresentModeKHR {
    var count: u32 = undefined;
    _ = try instance.vki.getPhysicalDeviceSurfacePresentModesKHR(pdev, surface, &count, null);
    const present_modes = try allocator.alloc(vk.PresentModeKHR, count);
    defer allocator.free(present_modes);
    _ = try instance.vki.getPhysicalDeviceSurfacePresentModesKHR(pdev, surface, &count, present_modes.ptr);

    const preferred = [_]vk.PresentModeKHR{
        .mailbox_khr,
        .immediate_khr,
    };

    for (preferred) |mode| {
        if (std.mem.indexOfScalar(vk.PresentModeKHR, present_modes, mode) != null) {
            return mode;
        }
    }

    return .fifo_khr;
}

/// Find the actual extent of the swapchain. Note that it may differ from the desired `extent`,
/// for example due to race conditions.
fn findActualExtent(caps: vk.SurfaceCapabilitiesKHR, extent: vk.Extent2D) vk.Extent2D {
    if (caps.current_extent.width != 0xFFFF_FFFF) {
        return caps.current_extent;
    } else {
        return .{
            .width = std.math.clamp(extent.width, caps.min_image_extent.width, caps.max_image_extent.width),
            .height = std.math.clamp(extent.height, caps.min_image_extent.height, caps.max_image_extent.height),
        };
    }
}
