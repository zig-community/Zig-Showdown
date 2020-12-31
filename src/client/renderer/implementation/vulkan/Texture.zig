const std = @import("std");
const vk = @import("vulkan");

const Context = @import("Context.zig");
const DescriptorManager = @import("DescriptorManager.zig");
const Resources = @import("../../../Resources.zig");
const Allocation = @import("allocator/DeviceAllocator.zig").Allocation;

const Self = @This();

image: vk.Image,
view: vk.ImageView,
allocation: Allocation,
descriptor_index: u32,

pub fn init(ctx: *Context, dm: *DescriptorManager, backing: *Resources.Texture) !Self {
    const image = try ctx.device.vkd.createImage(ctx.device.handle, .{
        .flags = .{},
        .image_type = .@"2d",
        .format = Context.texture_format,
        .extent = .{
            .width = @intCast(u32, backing.width),
            .height = @intCast(u32, backing.height),
            .depth = 1
        },
        .mip_levels = 1,
        .array_layers = 1,
        .samples = .{.@"1_bit" = true},
        .tiling = .optimal,
        .usage = .{.sampled_bit = true, .transfer_dst_bit = true},
        .sharing_mode = .exclusive,
        .queue_family_index_count = 0,
        .p_queue_family_indices = undefined,
        .initial_layout = .@"undefined",
    }, null);
    errdefer ctx.device.vkd.destroyImage(ctx.device.handle, image, null);

    const allocation = try ctx.device_allocator.device_allocator.allocAndBindImage(&ctx.device, image, .{.device_local_bit = true});
    errdefer ctx.device_allocator.device_allocator.free(&ctx.device, allocation);

    const view = try ctx.device.vkd.createImageView(ctx.device.handle, .{
        .flags = .{},
        .image = image,
        .view_type = .@"2d",
        .format = Context.texture_format,
        .components = .{.r = .identity, .g = .identity, .b = .identity, .a = .identity},
        .subresource_range = .{
            .aspect_mask = .{.color_bit = true},
            .base_mip_level = 0,
            .level_count = 1,
            .base_array_layer = 0,
            .layer_count = 1,
        },
    }, null);
    errdefer ctx.device.vkd.destroyImageView(ctx.device.handle, view, null);

    const index = try dm.allocateTextureDescriptor(ctx, view);

    return Self{
        .image = image,
        .view = view,
        .allocation = allocation,
        .descriptor_index = index,
    };
}

pub fn deinit(self: *Self, ctx: *Context, dm: *DescriptorManager) void {
    // As this texture could still be in use by some part of the renderer, destruction of
    // all its components is defered until a `Context.frame_overlap` frames later.
    // TODO: This should probably not be responsible for defering destruction.

    // The DescriptorManager handles defered destruction itself.
    dm.freeTextureDescriptor(ctx, self.descriptor_index);

    // When any of these functions fail, the item hasn't been queued, and so we just ignore it.
    // That will be a resource leak, but we are likely to have bigger problems in that
    // case anyway.
    ctx.deferDestruction(.{.image_view = self.view}) catch {};
    ctx.deferDestruction(.{.image = self.image}) catch {};
    ctx.deferDestruction(.{.allocation = self.allocation}) catch {};

    self.* = undefined;
}
