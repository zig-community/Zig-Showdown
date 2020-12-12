const std = @import("std");
const vk = @import("vulkan");
const Instance = @import("Instance.zig");
const Device = @import("Device.zig");
const VulkanRenderer = @import("VulkanRenderer.zig");
const Renderer = @import("../../../Renderer.zig");

pub const Self = @This();

pipeline: vk.GraphicsPipeline,

pub fn init(r: *VulkanRenderer) !void {

}

pub fn deinit(r: *VulkanRenderer) void {

}

pub fn draw(r: *VulkanRenderer, pass: Renderer.UiPass) !void {

}
