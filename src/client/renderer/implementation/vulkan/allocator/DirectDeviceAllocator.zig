const std = @import("std");
const vk = @import("vulkan");

const Device = @import("../Device.zig");
const DeviceAllocator = @import("DeviceAllocator.zig");
const Allocation = DeviceAllocator.Allocation;
const Error = DeviceAllocator.Error;

const Self = @This();

device_allocator: DeviceAllocator,

pub fn init() Self {
    return .{
        .device_allocator = .{
            .alloc_fn = alloc,
            .free_fn = free,
        },
    };
}

fn alloc(
    device_allocator: *DeviceAllocator,
    device: *Device,
    requirements: vk.MemoryRequirements,
    flags: vk.MemoryPropertyFlags,
) Error!Allocation {
    const self = @fieldParentPtr(Self, "device_allocator", device_allocator);
    // We don't need to mind alignment in this call, as allocateMemory is guaranteed to
    // return a properly aligned memory buffer for any possible alignment returned by
    // `get*MemoryRequirements`.
    const mem = device.vkd.allocateMemory(device.handle, .{
        .allocation_size = requirements.size,
        .memory_type_index = try device.pdev.findMemoryTypeIndex(requirements.memory_type_bits, flags),
    }, null) catch |err| switch (err) {
        error.InvalidExternalHandle => unreachable, // Provided by a p_next struct
        error.InvalidOpaqueCaptureAddress => unreachable, // Provided by a p_next struct
        else => |narrow| return narrow,
    };

    return Allocation{
        .memory = mem,
        .offset = 0,
    };
}

fn free(device_allocator: *DeviceAllocator, device: *Device, allocation: Allocation) void {
    const self = @fieldParentPtr(Self, "device_allocator", device_allocator);
    device.vkd.freeMemory(device.handle, allocation.memory, null);
}
