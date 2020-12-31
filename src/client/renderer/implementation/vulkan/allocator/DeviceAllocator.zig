const vk = @import("vulkan");

const Device = @import("../Device.zig");

const Self = @This();

pub const Error = error{
    OutOfDeviceMemory,
    OutOfHostMemory,
    NoSuitableMemoryType,
    Unknown,
};

pub const Allocation = struct {
    memory: vk.DeviceMemory,
    offset: vk.DeviceSize,
};

alloc_fn: fn(self: *Self, device: *Device, requirements: vk.MemoryRequirements, flags: vk.MemoryPropertyFlags) Error!Allocation,
free_fn: fn(self: *Self, device: *Device, allocation: Allocation) void,

pub fn alloc(self: *Self, device: *Device, requirements: vk.MemoryRequirements, flags: vk.MemoryPropertyFlags) Error!Allocation {
    return self.alloc_fn(self, device, requirements, flags);
}

pub fn free(self: *Self, device: *Device, allocation: Allocation) void {
    self.free_fn(self, device, allocation);
}

pub fn allocAndBindImage(self: *Self, device: *Device, image: vk.Image, flags: vk.MemoryPropertyFlags) !Allocation {
    const requirements = device.vkd.getImageMemoryRequirements(device.handle, image);
    const allocation = try self.alloc(device, requirements, flags);
    try device.vkd.bindImageMemory(device.handle, image, allocation.memory, allocation.offset);
    return allocation;
}
