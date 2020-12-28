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

const DestructionQueue = std.ArrayListUnmanaged(DestructionQueueItem);
const DestructionQueueItem = union(enum) {
    swapchain: vk.SwapchainKHR,
};

pub fn init(allocator: *Allocator, instance: Instance, device: Device) Self {
    return .{
        .allocator = allocator,
        .instance = instance,
        .device = device,
        .frame_nr = 0,
        .destruction_queues = [_]DestructionQueue{.{}} ** frame_overlap,
    };
}

pub fn deinit(self: *Self) void {
    for (self.destruction_queues) |*queue| {
        self.runDestructionQueue(queue);
        queue.deinit(self.allocator);
    }
}

pub fn beginFrame(self: *Self) void {
    const queue = &self.destruction_queues[self.frameIndex()];
    self.runDestructionQueue(queue);
    queue.shrinkRetainingCapacity(0);
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

fn runDestructionQueue(self: *Self, queue: *DestructionQueue) void {
    for (queue.items) |item| self.destroy(item);
}

fn destroy(self: *Self, item: DestructionQueueItem) void {
    switch (item) {
        .swapchain => |swapchain| {
            self.device.vkd.destroySwapchainKHR(self.device.handle, swapchain, null);
        },
    }
}
