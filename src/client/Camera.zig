const std = @import("std");
const zlm = @import("zlm");

const Self = @This();

/// position of the camera in the world
position: zlm.Vec3,

/// rotation around x,y and z axis.
euler: zlm.Vec3,

fov: f32 = 70.0,

pub fn getForward(self: Self) zlm.Vec3 {
    const sin = std.math.sin;
    const cos = std.math.cos;
    return zlm.vec3(
        cos(self.euler.x) * sin(self.euler.y),
        sin(self.euler.x),
        -cos(self.euler.x) * cos(self.euler.y),
    );
}

pub fn getRight(self: Self) zlm.Vec3 {
    const sin = std.math.sin;
    const cos = std.math.cos;
    return zlm.vec3(
        cos(self.euler.z) * cos(self.euler.y),
        sin(self.euler.z),
        cos(self.euler.z) * sin(self.euler.y),
    );
}
