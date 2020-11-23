//! This state allows the player to create a new
//! singleplayer game.
//! Might share some logic with `create_server`.

const std = @import("std");
const Renderer = @import("root").Renderer;
const Color = @import("../renderer/Color.zig");

const Self = @This();

pub fn render(self: *Self, renderer: *Renderer, render_target: Renderer.RenderTarget, total_time: f32, delta_time: f32) !void {
    renderer.clear(Color.fromRgb(0, 1, 0));
}
