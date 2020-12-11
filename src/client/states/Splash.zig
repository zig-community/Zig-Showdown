//! This is the intro state which displays a nice little
//! Zig logo splash, possibly with zero flying through the screen

const std = @import("std");
const math = @import("../math.zig");
const theme = @import("../theme.zig");

const Renderer = @import("../Renderer.zig");
const Input = @import("../Input.zig");
const Game = @import("../Game.zig");
const Resources = @import("../Resources.zig");

const Self = @This();

allocator: *std.mem.Allocator,
resources: *Resources,

progress: f32 = 0.0,
duration: f32,

pub fn init(allocator: *std.mem.Allocator, resources: *Resources) !Self {
    return Self{
        .resources = resources,
        .allocator = allocator,
        .duration = 3.0,
    };
}

pub fn enter(self: *Self, total_time: f32) !void {
    self.progress = 0.0;
}

pub fn update(self: *Self, input: Input, total_time: f32, delta_time: f32) !void {
    if (self.progress >= 1.2 or input.isAnyHit()) {
        Game.fromComponent(self).switchToState(.main_menu);
    }
}

pub fn render(self: *Self, renderer: *Renderer, render_target: Renderer.RenderTarget, total_time: f32, delta_time: f32) !void {
    var pass = Renderer.UiPass.init(self.allocator);
    defer pass.deinit();

    const screen_size = render_target.size();

    const mid_x: isize = @intCast(isize, screen_size.width / 2);
    const mid_y: isize = @intCast(isize, screen_size.height / 2);

    const progress = std.math.clamp(self.progress, 0.0, 1.0);
    self.progress += delta_time / self.duration;

    const line_length = @floatToInt(isize, 100 * math.smoothstep(progress));

    try pass.drawLine(
        mid_x - 50,
        mid_y - 50,
        mid_x - 50 + line_length,
        mid_y - 50,
        theme.zig_yellow,
        3,
    );

    try pass.drawLine(
        mid_x + 50,
        mid_y - 50,
        mid_x + 50 - line_length,
        mid_y - 50 + line_length,
        theme.zig_yellow,
        3,
    );

    try pass.drawLine(
        mid_x + 50 - line_length,
        mid_y + 50,
        mid_x + 50,
        mid_y + 50,
        theme.zig_yellow,
        3,
    );

    renderer.clear(render_target, theme.zig_dark);
    try renderer.submit(render_target, pass);
}
