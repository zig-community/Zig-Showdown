//! This menu provides options to tweak the game.

const std = @import("std");
const Renderer = @import("../Renderer.zig");
const Resources = @import("../Resources.zig");
const Input = @import("../Input.zig");
const Game = @import("../Game.zig");
const Color = @import("../renderer/Color.zig");

const Self = @This();

resources: *Resources,
font_id: Resources.FontPool.ResourceName,

pub fn init(resources: *Resources) !Self {
    return Self{
        .resources = resources,
        .font_id = try resources.fonts.getName("/font.tex"),
    };
}

pub fn update(self: *Self, input: Input, total_time: f32, delta_time: f32) !void {
    if (input.isAnyHit()) {
        Game.fromComponent(self).switchToState(.main_menu);
    }
}

pub fn render(self: *Self, renderer: *Renderer, render_target: Renderer.RenderTarget, total_time: f32, delta_time: f32) !void {
    var pass = renderer.createUiPass();
    defer pass.deinit();

    const font = try self.resources.fonts.get(self.font_id, Resources.usage.debug_draw);
    try pass.drawString(
        10,
        @intCast(isize, renderer.screenSize().height - font.glyph_size.height - 10),
        font,
        Color.fromRgb(1, 1, 1),
        "Options Menu",
    );

    renderer.clear(render_target, Color.fromRgb(0.5, 0, 0));
    try renderer.submit(render_target, pass);
}
