const std = @import("std");

const Self = @This();

r: u8,
g: u8,
b: u8,
a: u8 = 0xFF,

pub fn fromRgb(r: f32, g: f32, b: f32) Self {
    return Self{
        .r = @floatToInt(u8, std.math.clamp(r, 0.0, 1.0)),
        .g = @floatToInt(u8, std.math.clamp(g, 0.0, 1.0)),
        .b = @floatToInt(u8, std.math.clamp(b, 0.0, 1.0)),
    };
}
