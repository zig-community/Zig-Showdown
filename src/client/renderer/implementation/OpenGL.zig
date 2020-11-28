const std = @import("std");
const zwl = @import("zwl");
const WindowPlatform = @import("../../main.zig").WindowPlatform;
const Renderer = @import("../../Renderer.zig");
const Color = @import("../Color.zig");

const Self = @This();

pub fn init(allocator: *std.mem.Allocator, window: *WindowPlatform.Window) !Self {
    return Self{};
}

pub fn deinit(self: *Self) void {
    self.* = undefined;
}

pub fn beginFrame(self: *Self) void {
    // stub
}

pub fn endFrame(self: *Self) void {
    // stub
}

pub fn clear(self: *Self, rt: Renderer.RenderTarget, color: Color) void {
    // stub
}

pub fn submitUiPass(self: *Self, render_target: Renderer.RenderTarget, pass: Renderer.UiPass) !void {
    // stub
}

pub fn submitScenePass(self: *Self, render_target: Renderer.RenderTarget, pass: Renderer.ScenePass) !void {
    // stub
}

pub fn submitTransition(self: *Self, render_target: Renderer.RenderTarget, transition: Renderer.Transition) !void {
    // stub
}
