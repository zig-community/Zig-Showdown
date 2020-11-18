const std = @import("std");
const zwl = @import("zwl");

//! This file implements the core game structure and state transitions.

pub const WindowPlatform = @import("root").WindowPlatform;

/// The core management structure for the game. This is
/// mostly platform independent game logic and rendering implementation.
pub const Game = struct {
    const Self = @This();

    pub fn init(allocator: *std.mem.Allocator) !Self {
        return Self{};
    }

    pub fn deinit(self: *Self) void {
        self.* = undefined;
    }

    pub fn update(self: *Self, time: f32) void {
        // update time step
    }

    pub fn render(self: *Self, target: zwl.PixelBuffer) void {
        var y: usize = 0;
        while (y < target.height) : (y += 1) {
            var x: usize = 0;
            while (x < target.width) : (x += 1) {
                target.setPixel(x, y, .{
                    .r = @truncate(u8, x),
                    .g = @truncate(u8, y),
                    .b = @truncate(u8, x ^ y),
                });
            }
        }
    }
};
