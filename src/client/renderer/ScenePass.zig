const std = @import("std");
const zlm = @import("zlm");

const Resources = @import("../Resources.zig");
const Camera = @import("../Camera.zig");

const Self = @This();

pub const Transform = zlm.Mat4;

const DrawCall = union(enum) {
    model: struct {
        model: Resources.Model,
        transform: Transform,
    },
};

drawcalls: std.ArrayList(DrawCall),
camera: Camera = Camera{
    .position = zlm.Vec3.zero,
    .euler = zlm.Vec3.zero,
},

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
