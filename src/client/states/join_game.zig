//! This state provides a menu to join games.
//! Tasks:
//! - Allow the user to input a server IP
//! - Listen to UDP broadcasts and display a LAN game list
//! - optional: Load a list of games from a central "game list server"

const std = @import("std");
const zwl = @import("zwl");

const Self = @This();

pub fn render(self: *Self, render_target: zwl.PixelBuffer, total_time: f32, delta_time: f32) !void {
    std.mem.set(u32, render_target.span(), @bitCast(u32, zwl.Pixel{ .r = 0xFF, .g = 0x00, .b = 0xFF }));
}
