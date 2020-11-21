//! This menu is overlayed over the `game` state
//! and captures input. It allows the player to quickly
//! go into the options menu or leave the game.

const std = @import("std");
const zwl = @import("zwl");

const Self = @This();

pub fn render(self: *Self, render_target: zwl.PixelBuffer, total_time: f32, delta_time: f32) !void {
    std.mem.set(u32, render_target.span(), @bitCast(u32, zwl.Pixel{ .r = 0x00, .g = 0x80, .b = 0x00 }));
}
