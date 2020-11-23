//! This state provides the player with the main menu
//! of the game.
//! The player can chose what to do here.

const std = @import("std");
const Renderer = @import("root").Renderer;
const painterz = @import("painterz");
const theme = @import("../theme.zig");
const math = @import("../math.zig");
const Game = @import("../Game.zig");
const Resources = @import("../Resources.zig");

const Self = @This();

// const Canvas = painterz.Canvas(zwl.PixelBuffer, zwl.Pixel, struct {
//     fn setPixel(buf: zwl.PixelBuffer, x: isize, y: isize, col: zwl.Pixel) void {
//         if (x < 0 or y < 0 or x >= buf.width or y >= buf.height)
//             return;
//         buf.setPixel(@intCast(u16, x), @intCast(u16, y), col);
//     }
// }.setPixel);

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

resources: *Resources,
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

items_font_id: Resources.TexturePool.ResourceName,
background_ids: [3]Resources.TexturePool.ResourceName,
current_background: usize = 0,

pub fn init(resources: *Resources) !Self {
    return Self{
        .resources = resources,
        .items_font_id = try resources.textures.getName("/assets/font.tex"),
        .background_ids = [3]Resources.TexturePool.ResourceName{
            try resources.textures.getName("/assets/backgrounds/matte-01.tex"),
            try resources.textures.getName("/assets/backgrounds/matte-02.tex"),
            try resources.textures.getName("/assets/backgrounds/matte-03.tex"),
        },
    };
}

pub fn enter(self: *Self, total_time: f32) !void {
    for (self.items) |*item| {
        item.extension = 0.0;
    }

    self.current_item = 0;
    self.items[self.current_item].extension = 1.0;

    var rng = std.rand.DefaultPrng.init(@bitCast(u64, std.time.timestamp()));

    self.current_background = rng.random.intRangeLessThan(usize, 0, 3);
}

pub fn update(self: *Self, total_time: f32, delta_time: f32) !void {
    if (self.timer >= 1.0) {
        self.current_item = if (self.current_item == 5)
            0
        else
            self.current_item + 1;
        self.timer = 0;

        // TODO: Remove this when input works
        if (self.current_item == 0) {
            Game.fromComponent(self).switchToState(.gameplay);
        }
    }
    self.timer += delta_time;
}

fn fetchFontPixel(font: Resources.TexturePool.Resource, ix: isize, iy: isize) zwl.Pixel {
    const x = std.math.cast(usize, ix) catch return theme.zig_yellow;
    const y = std.math.cast(usize, iy) catch return theme.zig_yellow;
    if (x >= font.width or y >= font.height) return theme.zig_yellow;

    return if (font.pixels[font.width * y + x].a >= 0x80)
        theme.zig_bright
    else
        theme.zig_yellow;
}

fn fetchImagePixel(font: Resources.TexturePool.Resource, ix: isize, iy: isize) zwl.Pixel {
    const x = std.math.cast(usize, ix) catch return theme.zig_yellow;
    const y = std.math.cast(usize, iy) catch return theme.zig_yellow;
    if (x >= font.width or y >= font.height) return theme.zig_yellow;

    return zwl.Pixel{
        .r = font.pixels[font.width * y + x].r,
        .g = font.pixels[font.width * y + x].g,
        .b = font.pixels[font.width * y + x].b,
        .a = font.pixels[font.width * y + x].a,
    };
}

pub fn render(self: *Self, renderer: *Renderer, render_target: Renderer.RenderTarget, total_time: f32, delta_time: f32) !void {
    renderer.clear(render_target, theme.zig_dark);

    // var canvas = Canvas.init(render_target);

    // const font = try self.resources.textures.get(self.items_font_id, Resources.usage.menu_render);
    // const background = try self.resources.textures.get(self.background_ids[self.current_background], Resources.usage.menu_render);
    // canvas.copyRectangle(
    //     0,
    //     0,
    //     0,
    //     0,
    //     render_target.width,
    //     render_target.height,
    //     background,
    //     fetchImagePixel,
    // );

    // const glyph_w = font.width / 16;
    // const glyph_h = font.height / 16;

    // for (self.items) |*item, index| {
    //     const top = @intCast(isize, render_target.height - self.items.len * 50 + 40 * index);

    //     const height = 30;
    //     const default_width = 250;

    //     const top_width = default_width + @floatToInt(isize, 50 * math.smoothstep(item.extension));
    //     const bot_width = default_width + @floatToInt(isize, 30 * math.smoothstep(item.extension));

    //     const poly = [_]painterz.Point{
    //         .{ .x = 0, .y = 0 },
    //         .{ .x = top_width, .y = 0 },
    //         .{ .x = bot_width, .y = height },
    //         .{ .x = 0, .y = height },
    //     };

    //     canvas.fillPolygon(0, top, theme.zig_yellow, &poly);

    //     const pad = @intCast(isize, (height - glyph_h) / 2);
    //     for (item.title) |c, i| {
    //         canvas.copyRectangle(
    //             @intCast(isize, glyph_w * i) + pad,
    //             top + pad,
    //             @intCast(isize, glyph_w * (c % 16)),
    //             @intCast(isize, glyph_h * (c / 16)),
    //             glyph_w,
    //             glyph_h,
    //             font,
    //             fetchFontPixel,
    //         );
    //     }

    //     const extended = (index == self.current_item);
    //     item.extension = std.math.clamp(
    //         if (extended) item.extension + delta_time / MenuItem.extension_time else item.extension - delta_time / MenuItem.extension_time,
    //         0.0,
    //         1.0,
    //     );
    // }
}
