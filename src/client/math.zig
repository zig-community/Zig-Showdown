const std = @import("std");

pub fn smoothstep(x: f32) f32 {
    const t = std.math.clamp(x, 0.0, 1.0);
    return t * t * (3.0 - 2.0 * t);
}

pub fn lerp(v0: f32, v1: f32, f: f32) f32 {
    return v0 + (v1 - v0) * f;
}
