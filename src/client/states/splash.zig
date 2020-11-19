//! This is the intro state which displays a nice little
//! Zig logo splash, possibly with zero flying through the screen

const std = @import("std");
const zwl = @import("zwl");
const painterz = @import("painterz");
const math = @import("../math.zig");

const Game = @import("../game.zig");

const Canvas = painterz.Canvas(zwl.PixelBuffer, zwl.Pixel, struct {
    fn setPixel(buf: zwl.PixelBuffer, x: isize, y: isize, col: zwl.Pixel) void {
        if (x < 1 or y < 1 or x >= buf.width - 1 or y >= buf.height - 1)
            return;
        buf.setPixel(@intCast(u16, x), @intCast(u16, y), col);
        buf.setPixel(@intCast(u16, x + 1), @intCast(u16, y), col);
        buf.setPixel(@intCast(u16, x - 1), @intCast(u16, y), col);
        buf.setPixel(@intCast(u16, x), @intCast(u16, y + 1), col);
        buf.setPixel(@intCast(u16, x), @intCast(u16, y - 1), col);
    }
}.setPixel);

const Self = @This();

progress: f32 = 0.0,
duration: f32,

pub fn init() Self {
    return Self{
        .duration = 3.0,
    };
}

pub fn enter(self: *Self, total_time: f32) !void {
    self.progress = 0.0;
}

pub fn update(self: *Self, total_time: f32, delta_time: f32) !void {
    if (total_time >= self.duration + 1.0) {
        Game.fromComponent(self).switchToState(.main_menu);
    }
}

const zig_yellow = zwl.Pixel{ .r = 0xF7, .g = 0xA4, .b = 0x1D };

pub fn render(self: *Self, render_target: zwl.PixelBuffer, total_time: f32, delta_time: f32) !void {
    std.mem.set(u32, render_target.span(), @bitCast(u32, zwl.Pixel{ .r = 0x11, .g = 0x11, .b = 0x11 }));

    var canvas = Canvas.init(render_target);

    const mid_x: isize = render_target.width / 2;
    const mid_y: isize = render_target.height / 2;

    const progress = std.math.clamp(self.progress, 0.0, 1.0);
    self.progress += delta_time / self.duration;

    const line_length = @floatToInt(isize, 100 * math.smoothstep(progress));

    canvas.drawLine(
        mid_x - 50,
        mid_y - 50,
        mid_x - 50 + line_length,
        mid_y - 50,
        zig_yellow,
    );

    canvas.drawLine(
        mid_x + 50,
        mid_y - 50,
        mid_x + 50 - line_length,
        mid_y - 50 + line_length,
        zig_yellow,
    );

    canvas.drawLine(
        mid_x + 50 - line_length,
        mid_y + 50,
        mid_x + 50,
        mid_y + 50,
        zig_yellow,
    );
}
