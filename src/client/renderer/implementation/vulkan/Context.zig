const std = @import("std");
const zwl = @import("zwl");
const vk = @import("vulkan");

const Instance = @import("Instance.zig");
const Device = @import("Device.zig");

const Allocator = std.mem.Allocator;

pub const log = std.log.scoped(.vulkan);

pub const frame_overlap = 2;
pub const frame_timeput = 1 * std.time.ns_per_s;

const Self = @This();

allocator: *Allocator,
instance: Instance,
device: Device,

pub fn init(allocator: *Allocator, instance: Instance, device: Device) Self {
    return .{
        .allocator = allocator,
        .instance = instance,
        .device = device,
    };
}
