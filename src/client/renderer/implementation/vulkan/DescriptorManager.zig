const std = @import("std");
const vk = @import("vulkan");
const util = @import("util.zig");

const Context = @import("Context.zig");
const SmallBuf = util.SmallBuf;
const asManyPtr = util.asManyPtr;

const Self = @This();

//! TODO: Document this file better

// Maximum number of texture descriptors.
// This needs to be kept in sync with all Vulkan shaders!
const texture_pool_size = 1024;

const PendingUpdate = struct {
    index: u32,
    image_view: vk.ImageView,
};

const PendingUpdateQueue = std.ArrayListUnmanaged(PendingUpdate);
const PendingFreeQueue = std.ArrayListUnmanaged(u32);

pool: vk.DescriptorPool,
set_layout: vk.DescriptorSetLayout,
sets: [Context.frame_overlap]vk.DescriptorSet,
pipeline_layout: vk.PipelineLayout,

free_textures: std.ArrayListUnmanaged(u32),

pending_updates: [Context.frame_overlap]PendingUpdateQueue,
pending_frees: PendingFreeQueue,

// These two are stored in the struct so that we don't need to reallocate them every time
image_infos: std.ArrayListUnmanaged(vk.DescriptorImageInfo),
writes: std.ArrayListUnmanaged(vk.WriteDescriptorSet),

pub fn init(ctx: *Context) !Self {
    // The bindings used by the entire renderer.
    // These bindings must be kept in sync with all Vulkan shaders!
    // TODO: Think of better way to encode this struct
    const bindings = [_]vk.DescriptorSetLayoutBinding{
        .{ // layout(set = 0, binding = 0) uniform sampler texture_sampler;
            .binding = 0,
            .descriptor_type = .sampler,
            .descriptor_count = 1,
            .stage_flags = .{.vertex_bit = true, .fragment_bit = true, .compute_bit = true},
            .p_immutable_samplers = asManyPtr(&ctx.texture_sampler),
        },
        .{ // layout(set = 0, binding = 1) uniform texture2D textures[texture_pool_size];
            .binding = 1,
            .descriptor_type = .sampled_image,
            .descriptor_count = texture_pool_size,
            .stage_flags = .{.vertex_bit = true, .fragment_bit = true, .compute_bit = true},
            .p_immutable_samplers = null,
        },
    };

    var self = Self{
        .pool = .null_handle,
        .set_layout = .null_handle,
        .sets = [_]vk.DescriptorSet{ .null_handle } ** Context.frame_overlap,
        .pipeline_layout = .null_handle,

        .free_textures = .{},

        .pending_updates = [_]PendingUpdateQueue{.{}} ** Context.frame_overlap,
        .pending_frees = PendingFreeQueue{},

        .image_infos = .{},
        .writes = .{},
    };
    errdefer self.deinit(ctx);

    try self.initDescriptorPool(ctx, &bindings);
    try self.initDescriptorSets(ctx, &bindings);
    try self.initPipelineLayout(ctx);

    try self.free_textures.resize(ctx.allocator, texture_pool_size);
    for (self.free_textures.items) |*x, i| x.* = @intCast(u32, i);

    // Make sure that the pending free array list will have enough space
    // for all textures to be de-allocated at once.
    try self.pending_frees.ensureCapacity(ctx.allocator, texture_pool_size);

    return self;
}

pub fn deinit(self: *Self, ctx: *Context) void {
    self.image_infos.deinit(ctx.allocator);
    self.writes.deinit(ctx.allocator);

    self.pending_frees.deinit(ctx.allocator);

    for (self.pending_updates) |*puq| {
        puq.deinit(ctx.allocator);
    }

    ctx.device.vkd.destroyPipelineLayout(ctx.device.handle, self.pipeline_layout, null);
    // Destroying the pool frees any associated descriptor sets
    ctx.device.vkd.destroyDescriptorPool(ctx.device.handle, self.pool, null);
    self.free_textures.deinit(ctx.allocator);
    ctx.device.vkd.destroyDescriptorSetLayout(ctx.device.handle, self.set_layout, null);
}

/// Allocate a texture descriptor for `image_view`. This function also schedules
/// an internal function which updates the descriptor when `processPendingUpdates`
/// is queued. Note that this function requires intricate lifetime management of
/// image_view: When the image view is deleted during a frame, but is also already
/// queued to be rendered somewhere, its destruction should be defered using
/// `Context.deferDestruction`. The associated desctriptor can be freed immediately using
/// `freeTextureDescriptor`, as this function makes sure that frees are only processed
/// AFTER all updates for the current frame are performed.
pub fn allocateTextureDescriptor(self: *Self, ctx: *Context, image_view: vk.ImageView) !u32 {
    const index = self.free_textures.popOrNull() orelse return error.OutOfDescriptors;

    // Schedule the write for future frames
    // If the image view is destroyed in the mean time, it needs to be removed from here!
    for (self.pending_updates) |*puq| {
        try puq.append(ctx.allocator, .{.index = index, .image_view = image_view});
    }
    return index;
}

/// Schedule texture descriptor index `index` to be freed. The actual processing of this
/// will only happen AFTER the updates for the current frame are written in
/// `processPendingUpdates`. Updates for the next few frames are also scratched in that
/// function.
pub fn freeTextureDescriptor(self: *Self, ctx: *Context, index: u32) void {
    if (std.builtin.mode == .Debug) {
        // Make sure that the texture is not already freed.
        // Doing this check now means we both need to check the free textures
        // list AND the free queue, but it will be easier to track down when the
        // incorrect texture was freed.
        if (std.mem.indexOfScalar(u32, self.free_textures.items, index) != null) {
            Context.log.err("Duplicate free of texture index {} (already freed)", .{ index });
            return;
        } else if (std.mem.indexOfScalar(u32, self.pending_frees.items, index) != null) {
            Context.log.err("Duplicate free of texture index {} (already pending for free", .{ index });
            return;
        } else if (index >= texture_pool_size) {
            Context.log.err("Free of invalid texture index {}", .{ index });
            return;
        }
    }

    // The capacity was ensured in the constructor. That will hold up as long
    // as no duplicate frees happen.
    self.pending_frees.appendAssumeCapacity(index);
}

pub fn bindDescriptorSet(self: *Self, ctx: *Context, cmd_buf: vk.CommandBuffer) void {
    ctx.device.vkd.cmdBindDescriptorSets(
        cmd_buf,
        .graphics,
        self.pipeline_layout,
        0,
        1,
        asManyPtr(&self.sets[ctx.frameIndex()]),
        0,
        undefined,
    );
}

pub fn processPendingUpdates(self: *Self, ctx: *Context) !void {
    // First, process the pending writes
    // This may include indexes which are in the pending_frees queue, which is
    // intended - the image view should always be deleted though the defered
    // deletion mechanism, and should thus still be valid in this frame.
    const puq = &self.pending_updates[ctx.frameIndex()];
    const set = self.sets[ctx.frameIndex()];

    try self.image_infos.resize(ctx.allocator, puq.items.len);
    try self.writes.resize(ctx.allocator, puq.items.len);

    const image_infos = self.image_infos.items;
    const writes = self.writes.items;

    for (puq.items) |pu, i| {
        image_infos[i] = .{
            .sampler = .null_handle,
            .image_view = pu.image_view,
            // TODO: This needs to be in sync with the global render pass in ctx.
            .image_layout = .shader_read_only_optimal,
        };

        writes[i] = .{
            .dst_set = set,
            .dst_binding = 1, // TODO: Don't hardcode this.
            .dst_array_element = pu.index,
            .descriptor_count = 1,
            .descriptor_type = .sampled_image, // TODO: Don't hardcode this.
            .p_image_info = asManyPtr(&image_infos[i]),
            .p_buffer_info = undefined,
            .p_texel_buffer_view = undefined,
        };
    }

    ctx.device.vkd.updateDescriptorSets(
        ctx.device.handle,
        @intCast(u32, writes.len),
        writes.ptr,
        0,
        undefined,
    );

    puq.shrinkRetainingCapacity(0);

    self.processPendingFrees(ctx);
}

fn processPendingFrees(self: *Self, ctx: *Context) void {
    // Pending frees and free textures should be disjoint. In debug mode, this is
    // checked for in `freeTextureDescriptor`, but maybe it should be checked again here?
    self.free_textures.appendSliceAssumeCapacity(self.pending_frees.items);

    // Cancel any scheduled updates for the next frames
    for (self.pending_frees.items) |index_to_free| {
        for (self.pending_updates) |*puq| {
            const i = for (puq.items) |pu, i| {
                    if (pu.index == index_to_free) break i;
                } else continue;

            _ = puq.swapRemove(i);
        }
    }

    self.pending_frees.shrinkRetainingCapacity(0);
}

fn initDescriptorPool(self: *Self, ctx: *Context, bindings: *const [2]vk.DescriptorSetLayoutBinding) !void {
    var pool_sizes = SmallBuf(bindings.len, vk.DescriptorPoolSize){};
    for (bindings) |binding| {
        for (pool_sizes.asSlice()) |*pool_size| {
            if (pool_size.@"type" == binding.descriptor_type) {
                pool_size.descriptor_count += binding.descriptor_count * Context.frame_overlap;
                break;
            }
        } else {
            pool_sizes.appendAssumeCapacity(.{
                .@"type" = binding.descriptor_type,
                .descriptor_count = binding.descriptor_count * Context.frame_overlap,
            });
        }
    }

    self.pool = try ctx.device.vkd.createDescriptorPool(ctx.device.handle, .{
        .flags = .{},
        .max_sets = Context.frame_overlap,
        .pool_size_count = pool_sizes.len,
        .p_pool_sizes = &pool_sizes.items,
    }, null);
}

fn initDescriptorSets(self: *Self, ctx: *Context, bindings: *const [2]vk.DescriptorSetLayoutBinding) !void {
    const flags = [_]vk.DescriptorBindingFlags{
        .{},
        .{.partially_bound_bit = true},
    };

    const dslbfci = vk.DescriptorSetLayoutBindingFlagsCreateInfo{
        .binding_count = flags.len,
        .p_binding_flags = &flags,
    };

    self.set_layout = try ctx.device.vkd.createDescriptorSetLayout(ctx.device.handle, .{
        .p_next = @ptrCast(*const c_void, &dslbfci),
        .flags = .{},
        .binding_count = bindings.len,
        .p_bindings = bindings,
    }, null);

    var layouts: [Context.frame_overlap]vk.DescriptorSetLayout = undefined;
    std.mem.set(vk.DescriptorSetLayout, &layouts, self.set_layout);

    try ctx.device.vkd.allocateDescriptorSets(ctx.device.handle, .{
        .descriptor_pool = self.pool,
        .descriptor_set_count = layouts.len,
        .p_set_layouts = &layouts,
    }, &self.sets);
}

fn initPipelineLayout(self: *Self, ctx: *Context) !void {
    self.pipeline_layout = try ctx.device.vkd.createPipelineLayout(ctx.device.handle, .{
        .flags = .{},
        .set_layout_count = 1,
        .p_set_layouts = asManyPtr(&self.set_layout),
        .push_constant_range_count = 0,
        .p_push_constant_ranges = undefined,
    }, null);
}
