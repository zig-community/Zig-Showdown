//! This state will display credits

const std = @import("std");
const Renderer = @import("root").Renderer;
const Color = @import("../renderer/Color.zig");

const Self = @This();

pub fn render(self: *Self, renderer: *Renderer, render_target: Renderer.RenderTarget, total_time: f32, delta_time: f32) !void {
    renderer.clear(Color.fromRgb(1, 1, 0));
}
