//! This menu is overlayed over the `game` state
//! and captures input. It allows the player to quickly
//! go into the options menu or leave the game.

const std = @import("std");
const Renderer = @import("root").Renderer;
const Color = @import("../renderer/Color.zig");

const Self = @This();

pub fn render(self: *Self, renderer: *Renderer, render_target: Renderer.RenderTarget, total_time: f32, delta_time: f32) !void {
    renderer.clear(render_target, Color.fromRgb(0, 0.5, 0));
}
