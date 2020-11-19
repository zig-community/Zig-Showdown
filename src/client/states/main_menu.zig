//! This state provides the player with the main menu
//! of the game.
//! The player can chose what to do here.

const std = @import("std");
const zwl = @import("zwl");
const painterz = @import("painterz");
const Game = @import("../game.zig");

const Self = @This();

const Canvas = painterz.Canvas(zwl.PixelBuffer, zwl.Pixel, struct {
    fn setPixel(buf: zwl.PixelBuffer, x: isize, y: isize, col: zwl.Pixel) void {
        if (x < 0 or y < 0 or x >= buf.width or y >= buf.height)
            return;
        buf.setPixel(@intCast(u16, x), @intCast(u16, y), col);
    }
}.setPixel);

pub fn update(self: *Self, total_time: f32, delta_time: f32) !void {
    //
}

pub fn render(self: *Self, render_target: zwl.PixelBuffer, total_time: f32, delta_time: f32) !void {
    // clear screen
    std.mem.set(u32, render_target.span(), @bitCast(u32, zwl.Pixel{ .r = 0x00, .g = 0xFF, .b = 0xFF }));

    var canvas = Canvas.init(render_target);

    canvas.drawLine(
        0,
        0,
        10,
        100,
        zwl.Pixel{ .r = 0xFF, .g = 0x00, .b = 0x00 },
    );
}
