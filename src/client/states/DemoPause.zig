//! This state is a "hidden" state not reachable in the normal gameplay
//! It is meant for screen captures and will just wait for a key press of "jump",
//! then transition to .splash

const std = @import("std");
const math = @import("../math.zig");
const theme = @import("../theme.zig");

const Renderer = @import("../Renderer.zig");
const Input = @import("../Input.zig");
const Game = @import("../Game.zig");

const Self = @This();

// workaround for zero-sized types
non_zero: u1 = 0,

pub fn init() Self {
    return Self{};
}

pub fn update(self: *Self, input: Input, total_time: f32, delta_time: f32) !void {
    if (input.isHit(.jump)) {
        Game.fromComponent(self).switchToState(.splash);
    }
}

pub fn render(self: *Self, renderer: *Renderer, render_target: Renderer.RenderTarget, total_time: f32, delta_time: f32) !void {
    renderer.clear(render_target, theme.zig_dark);
}
