//! This state allows the player to create a new
//! singleplayer game.
//! Might share some logic with `create_server`.

const std = @import("std");
const zwl = @import("zwl");

const Self = @This();

pub fn render(self: *Self, render_target: zwl.PixelBuffer, total_time: f32, delta_time: f32) !void {
    std.mem.set(u32, render_target.span(), @bitCast(u32, zwl.Pixel{ .r = 0x00, .g = 0xFF, .b = 0x00 }));
}
