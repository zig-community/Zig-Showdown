const std = @import("std");
const zwl = @import("zwl");
const vk = @import("vulkan");

const Instance = @import("Instance.zig");
const Device = @import("Device.zig");

const Allocator = std.mem.Allocator;

const Self = @This();

pub const log = std.log.scoped(.vulkan);

pub const frame_overlap = 2;
pub const frame_timeout = 1 * std.time.ns_per_s;

allocator: *Allocator,
instance: Instance,
device: Device,
frame_nr: usize,
destruction_queues: [frame_overlap]DestructionQueue,
texture_sampler: vk.Sampler,

const DestructionQueue = std.ArrayListUnmanaged(DestructionQueueItem);
const DestructionQueueItem = union(enum) {
    swapchain: vk.SwapchainKHR,
};

pub fn init(allocator: *Allocator, instance: Instance, device: Device) !Self {
    var self = Self{
        .allocator = allocator,
        .instance = instance,
        .device = device,
        .frame_nr = 0,
        .destruction_queues = [_]DestructionQueue{.{}} ** frame_overlap,
        .texture_sampler = .null_handle,
    };
    errdefer self.deinit();

    try self.initTextureSampler();

    return self;
}

pub fn deinit(self: *Self) void {
    self.device.vkd.destroySampler(self.device.handle, self.texture_sampler, null);

    for (self.destruction_queues) |*queue| {
        self.processDestructionQueue(queue);
        queue.deinit(self.allocator);
    }
}

pub fn beginFrame(self: *Self) void {
    const queue = &self.destruction_queues[self.frameIndex()];
    self.processDestructionQueue(queue);
}

pub fn endFrame(self: *Self) void {
    self.frame_nr += 1;
}

pub fn frameIndex(self: Self) usize {
    return self.frame_nr % frame_overlap;
}

pub fn deferDestruction(self: *Self, item: DestructionQueueItem) !void {
    try self.destruction_queues[self.frameIndex()].append(self.allocator, item);
}

fn processDestructionQueue(self: *Self, queue: *DestructionQueue) void {
    for (queue.items) |item| self.destroy(item);
    queue.shrinkRetainingCapacity(0);
}

fn destroy(self: *Self, item: DestructionQueueItem) void {
    switch (item) {
        .swapchain => |swapchain| {
            self.device.vkd.destroySwapchainKHR(self.device.handle, swapchain, null);
        },
    }
}

fn initTextureSampler(self: *Self) !void {
    self.texture_sampler = try self.device.vkd.createSampler(self.device.handle, .{
        .flags = .{},
        .mag_filter = .linear,
        .min_filter = .linear,
        .mipmap_mode = .linear,
        .address_mode_u = .repeat,
        .address_mode_v = .repeat,
        .address_mode_w = .repeat,
        .mip_lod_bias = 0,
        .anisotropy_enable = vk.FALSE,
        .max_anisotropy = 0,
        .compare_enable = vk.FALSE,
        .compare_op = .always,
        .min_lod = 0,
        .max_lod = 0,
        .border_color = .float_opaque_black,
        .unnormalized_coordinates = vk.FALSE,
    }, null);
}
