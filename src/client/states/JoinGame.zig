//! This state provides a menu to join games.
//! Tasks:
//! - Allow the user to input a server IP
//! - Listen to UDP broadcasts and display a LAN game list
//! - optional: Load a list of games from a central "game list server"

const std = @import("std");
const Renderer = @import("root").Renderer;
const Color = @import("../renderer/Color.zig");

const Self = @This();

pub fn render(self: *Self, renderer: *Renderer, render_target: Renderer.RenderTarget, total_time: f32, delta_time: f32) !void {
    renderer.clear(render_target, Color.fromRgb(1, 0, 1));
}
