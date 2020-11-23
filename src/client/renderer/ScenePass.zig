const std = @import("std");

const Resources = @import("../Resources.zig");

const Self = @This();

// TODO: Replace .cam with an actual mat4
pub const Transform = @import("pixel_draw").Camera3D;

const DrawCall = union(enum) {
    model: struct {
        model: Resources.Model,
        transform: Transform,
    },
};

drawcalls: std.ArrayList(DrawCall),

pub fn init(allocator: *std.mem.Allocator) Self {
    return Self{
        .drawcalls = std.ArrayList(DrawCall).init(allocator),
    };
}

pub fn deinit(self: *Self) void {
    self.drawcalls.deinit();
    self.* = undefined;
}

pub fn drawModel(self: *Self, model: Resources.Model, transform: Transform) !void {
    try self.drawcalls.append(DrawCall{
        .model = .{
            .model = model,
            .transform = transform,
        },
    });
}
