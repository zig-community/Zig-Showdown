const std = @import("std");

const Resources = @import("../Resources.zig");

const Self = @This();

const DrawCall = union(enum) {
    model: struct {
        model: Resources.Model, transform: Transform
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

