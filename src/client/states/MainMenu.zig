//! This state provides the player with the main menu
//! of the game.
//! The player can chose what to do here.

const std = @import("std");
const Renderer = @import("root").Renderer;
const painterz = @import("painterz");
const theme = @import("../theme.zig");
const math = @import("../math.zig");
const ui = @import("../ui.zig");

const Input = @import("../Input.zig");
const Game = @import("../Game.zig");
const Resources = @import("../Resources.zig");

const Self = @This();

const MenuItem = struct {
    const extension_time = 0.3;
    title: []const u8,
    extension: f32 = 0.0,
    last_rectangle: ui.Rectangle = .{
        .x = 0,
        .y = 0,
        .width = 0,
        .height = 0,
    },
};

const MENU_SP = 0;
const MENU_JOIN = 1;
const MENU_HOST = 2;
const MENU_OPTIONS = 3;
const MENU_CREDITS = 4;
const MENU_QUIT = 5;

const item_height = 30;
const default_width = 250;
const top_extension = 50;
const bottom_extension = 30;

resources: *Resources,
allocator: *std.mem.Allocator,

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

items_font_id: Resources.FontPool.ResourceName,
background_ids: [3]Resources.TexturePool.ResourceName,
logo_id: Resources.TexturePool.ResourceName,
current_background: usize = 0,

pub fn init(allocator: *std.mem.Allocator, resources: *Resources) !Self {
    return Self{
        .resources = resources,
        .allocator = allocator,

        .items_font_id = try resources.fonts.getName("/assets/font.tex"),
        .background_ids = [3]Resources.TexturePool.ResourceName{
            try resources.textures.getName("/assets/backgrounds/matte-01.tex"),
            try resources.textures.getName("/assets/backgrounds/matte-02.tex"),
            try resources.textures.getName("/assets/backgrounds/matte-03.tex"),
        },
        .logo_id = try resources.textures.getName("/assets/logo.tex"),
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

fn triggerItem(self: *Self, index: usize) void {
    switch (index) {
        MENU_SP => Game.fromComponent(self).switchToState(.create_sp_game), // TODO: this should be .create_sp_game, but for debugging it's easier this way
        MENU_JOIN => Game.fromComponent(self).switchToState(.join_game),
        MENU_HOST => Game.fromComponent(self).switchToState(.create_server),
        MENU_OPTIONS => Game.fromComponent(self).switchToState(.options),
        MENU_CREDITS => Game.fromComponent(self).switchToState(.credits),
        MENU_QUIT => Game.fromComponent(self).running = false,
        else => unreachable,
    }
}

pub fn update(self: *Self, input: Input, total_time: f32, delta_time: f32) !void {
    if (input.isHit(.up) and self.current_item > 0) {
        self.current_item -= 1;
    }
    if (input.isHit(.down) and self.current_item < self.items.len - 1) {
        self.current_item += 1;
    }
    if (input.isHit(.accept) or input.isHit(.jump)) {
        self.triggerItem(self.current_item);
    }
    if (input.mouseDelta().any()) {
        for (self.items) |item, i| {
            if (item.last_rectangle.contains(input.mouse_x, input.mouse_y))
                self.current_item = i;
        }
    }
    if (input.isHit(.left_mouse)) {
        for (self.items) |item, i| {
            if (item.last_rectangle.contains(input.mouse_x, input.mouse_y))
                self.triggerItem(i);
        }
    }
}

pub fn render(self: *Self, renderer: *Renderer, render_target: Renderer.RenderTarget, total_time: f32, delta_time: f32) !void {
    var pass = Renderer.UiPass.init(self.allocator);
    defer pass.deinit();

    const screen_size = render_target.size();

    const font = try self.resources.fonts.get(self.items_font_id, Resources.usage.menu_render);
    const background = try self.resources.textures.get(self.background_ids[self.current_background], Resources.usage.menu_render);
    const logo = try self.resources.textures.get(self.logo_id, Resources.usage.menu_render);

    try pass.drawImageStretched(
        .{
            .x = 0,
            .y = 0,
            .width = screen_size.width,
            .height = screen_size.height,
        },
        null,
        background,
    );

    const aspect = @intToFloat(f32, logo.width) / @intToFloat(f32, logo.height);

    try pass.drawImageStretched(
        .{
            .x = @floatToInt(isize, 0.2 * @intToFloat(f32, screen_size.width)),
            .y = 45,
            .width = @floatToInt(usize, 0.6 * @intToFloat(f32, screen_size.width)),
            .height = @floatToInt(usize, 0.6 * @intToFloat(f32, screen_size.width) / aspect),
        },
        null,
        logo,
    );

    for (self.items) |*item, index| {
        const top = @intCast(isize, screen_size.height - self.items.len * 50 + 40 * index);

        const top_width = default_width + @floatToInt(isize, top_extension * math.smoothstep(item.extension));
        const bot_width = default_width + @floatToInt(isize, bottom_extension * math.smoothstep(item.extension));

        item.last_rectangle = ui.Rectangle{
            .x = 0,
            .y = top,
            .width = @intCast(usize, std.math.max(top_width, bot_width)),
            .height = item_height,
        };

        const poly = [_]Renderer.UiPass.Point{
            .{ .x = 0, .y = 0 },
            .{ .x = top_width, .y = 0 },
            .{ .x = bot_width, .y = item_height },
            .{ .x = 0, .y = item_height },
        };

        try pass.fillPolygon(0, top, theme.zig_yellow, &poly);

        const pad = @intCast(isize, (item_height - font.glyph_size.height) / 2);

        try pass.drawString(pad, top + pad, font, theme.zig_bright, item.title);

        const extended = (index == self.current_item);
        item.extension = std.math.clamp(
            if (extended) item.extension + delta_time / MenuItem.extension_time else item.extension - delta_time / MenuItem.extension_time,
            0.0,
            1.0,
        );
    }

    renderer.clear(render_target, theme.zig_dark);
    try renderer.submit(render_target, pass);
}

// old render code:
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
