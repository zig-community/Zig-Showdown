//! This state contains the core gameplay.
//! Tasks:
//! - Render the world
//! - Process input into movement
//! - Do game logic
//! - Update network
//! - optional: Announce the game via UDP broadcast to LAN

const std = @import("std");
const zwl = @import("zwl");

const Self = @This();

pub fn render(self: *Self, render_target: zwl.PixelBuffer, total_time: f32, delta_time: f32) !void {
    std.mem.set(u32, render_target.span(), @bitCast(u32, zwl.Pixel{ .r = 0xFF, .g = 0x00, .b = 0xFF }));
}
