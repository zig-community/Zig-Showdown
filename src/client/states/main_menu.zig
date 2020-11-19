//! This state provides the player with the main menu
//! of the game.
//! The player can chose what to do here.

const std = @import("std");
const zwl = @import("zwl");
const painterz = @import("painterz");
const theme = @import("../theme.zig");
const math = @import("../math.zig");
const Game = @import("../game.zig");

const Self = @This();

const Canvas = painterz.Canvas(zwl.PixelBuffer, zwl.Pixel, struct {
    fn setPixel(buf: zwl.PixelBuffer, x: isize, y: isize, col: zwl.Pixel) void {
        if (x < 0 or y < 0 or x >= buf.width or y >= buf.height)
            return;
        buf.setPixel(@intCast(u16, x), @intCast(u16, y), col);
    }
}.setPixel);

const MenuItem = struct {
    const extension_time = 0.3;
    title: []const u8,
    extension: f32 = 0.0,
};

const MENU_SP = 0;
const MENU_JOIN = 1;
const MENU_HOST = 2;
const MENU_OPTIONS = 3;
const MENU_CREDITS = 4;
const MENU_QUIT = 5;

items: [6]MenuItem = [6]MenuItem{
    MenuItem{
        .title = "Singleplayer",
        .extension = 1.0,
    },
    MenuItem{
        .title = "Join Game",
    },
    MenuItem{
        .title = "Host Game",
    },
    MenuItem{
        .title = "Options",
    },
    MenuItem{
        .title = "Credits",
    },
    MenuItem{
        .title = "Quit",
    },
},
current_item: usize = 0,

timer: f32 = 0.0,

pub fn enter(self: *Self, total_time: f32) !void {
    for (self.items) |*item| {
        item.extension = 0.0;
    }

    self.current_item = 0;
    self.items[self.current_item].extension = 1.0;
}

pub fn update(self: *Self, total_time: f32, delta_time: f32) !void {
    if (self.timer >= 1.0) {
        self.current_item = if (self.current_item == 5)
            0
        else
            self.current_item + 1;
        self.timer = 0;
    }
    self.timer += delta_time;
}

pub fn render(self: *Self, render_target: zwl.PixelBuffer, total_time: f32, delta_time: f32) !void {
    // clear screen
    std.mem.set(u32, render_target.span(), @bitCast(u32, theme.zig_dark));

    var canvas = Canvas.init(render_target);

    for (self.items) |*item, index| {
        const top = @intCast(isize, render_target.height - self.items.len * 50 + 40 * index);

        const height = 30;
        const default_width = 250;

        const top_width = default_width + @floatToInt(isize, 50 * math.smoothstep(item.extension));
        const bot_width = default_width + @floatToInt(isize, 30 * math.smoothstep(item.extension));

        const poly = [_]painterz.Point{
            .{ .x = 0, .y = 0 },
            .{ .x = top_width, .y = 0 },
            .{ .x = bot_width, .y = height },
            .{ .x = 0, .y = height },
        };

        canvas.fillPolygon(0, top, theme.zig_yellow, &poly);
        // canvas.drawPolygon(0, top, theme.zig_bright, &poly);

        const extended = (index == self.current_item);
        item.extension = std.math.clamp(
            if (extended) item.extension + delta_time / MenuItem.extension_time else item.extension - delta_time / MenuItem.extension_time,
            0.0,
            1.0,
        );
    }
}
