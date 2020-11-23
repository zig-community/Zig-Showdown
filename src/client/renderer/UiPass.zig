const std = @import("std");

const Resources = @import("../Resources.zig");
const Renderer = @import("../Renderer.zig");

const Self = @This();
const Color = Renderer.Color;

const PrimitiveStyle = union(enum) {
    texture: Resources.Texture,
    color: Renderer.Color,
};

pub const Point = struct { x: isize, y: isize };

const DrawCall = union(enum) {
    rectangle: struct {
        x: isize,
        y: isize,
        w: usize,
        h: usize,
        style: PrimitiveStyle,
    },
    line: struct {
        x0: isize,
        y0: isize,
        x1: isize,
        y1: isize,
        color: Renderer.Color,
        thickness: u8,
    },
    polygon: struct {
        points: []Point,
        style: PrimitiveStyle,
    },
};

drawcalls: std.ArrayList(DrawCall),
arena: std.heap.ArenaAllocator,

pub fn init(allocator: *std.mem.Allocator) Self {
    return Self{
        .drawcalls = std.ArrayList(DrawCall).init(allocator),
        .arena = std.heap.ArenaAllocator.init(allocator),
    };
}

pub fn deinit(self: *Self) void {
    self.drawcalls.deinit();
    self.* = undefined;
}

pub fn drawLine(self: *Self, x0: isize, y0: isize, x1: isize, y1: isize, color: Color, thickness: u8) !void {
    try self.drawcalls.append(DrawCall{
        .line = .{
            .x0 = x0,
            .y0 = y0,
            .x1 = x1,
            .y1 = y1,
            .color = color,
            .thickness = thickness,
        },
    });
}
