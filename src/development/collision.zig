const std = @import("std");
const zlm = @import("zlm");

var framebuffer: [240][320]u8 = undefined;

pub fn main() !void {
    const vec3 = zlm.vec3;

    var sphere = Sphere{
        .center = vec3(0, 0, 10),
        .radius = 1.0,
    };

    for (framebuffer) |*row, y| {
        for (row) |*pixel, x| {
            const fx = 2.0 * @intToFloat(f32, x) / @intToFloat(f32, framebuffer.len - 1) - 1.0;
            const fy = 2.0 * @intToFloat(f32, y) / @intToFloat(f32, row.len - 1) - 1.0;

            var ray = Ray{
                .origin = vec3(0, 0, 0),
                .direction = vec3(fx, fy, 1.0).normalize(),
            };

            pixel.* = if (intersect(ray, sphere) != null)
                0xFF
            else
                0x00;
        }
    }

    // Write result
    {
        errdefer std.fs.cwd().deleteFile("collision-debug.pgm") catch {};
        var f = try std.fs.cwd().createFile("collision-debug.pgm", .{});
        defer f.close();

        try f.writeAll("P5 320 240 255\n");
        try f.writeAll(std.mem.sliceAsBytes(&framebuffer));
    }
}

pub const Ray = struct {
    origin: zlm.Vec3,
    direction: zlm.Vec3,
};

pub const Capsule = struct {
    ends: [2]zlm.Vec3,
    radius: f32,
};

pub const Sphere = struct {
    center: zlm.Vec3,
    radius: f32,
};

pub fn intersect(shape_a: anytype, shape_b: anytype) ?f32 {
    const ShapeA = @TypeOf(shape_a);
    const ShapeB = @TypeOf(shape_b);

    const type_order = [_]type{
        Ray,
        Capsule,
        Sphere,
    };
    const ind_a = inline for (type_order) |T, i| {
        if (T == ShapeA)
            break i;
    } else @compileError(@typeName(ShapeA) ++ " is not a valid shape type!");
    const ind_b = inline for (type_order) |T, i| {
        if (T == ShapeB)
            break i;
    } else @compileError(@typeName(ShapeB) ++ " is not a valid shape type!");

    const ShapeLeft = if (ind_a < ind_b) ShapeA else ShapeB;
    const ShapeRight = if (ind_a < ind_b) ShapeB else ShapeA;

    const shape_l = if (ind_a < ind_b) shape_a else shape_b;
    const shape_r = if (ind_a < ind_b) shape_b else shape_a;

    const error_missing_collision = "Collision between " ++ @typeName(ShapeLeft) ++ " and " ++ @typeName(ShapeRight) ++ " is not implemented yet!";

    return switch (ShapeLeft) {
        Ray => switch (ShapeRight) {
            Sphere => intersectRaySphere(shape_l, shape_r),
            else => @compileError(error_missing_collision),
        },
        else => @compileError(error_missing_collision),
    };
}

pub fn intersectRaySphere(ray: Ray, sphere: Sphere) ?f32 {
    // geometric solution
    const l = sphere.center.sub(ray.origin);
    const tca = zlm.Vec3.dot(l, ray.direction);
    if (tca < 0)
        return null;

    const radius2 = sphere.radius * sphere.radius;

    const d2 = zlm.Vec3.dot(l, l) - tca * tca;
    if (d2 > radius2)
        return null;
    const thc = std.math.sqrt(radius2 - d2);
    var t0 = tca - thc;
    var t1 = tca + thc;

    if (t0 > t1)
        std.mem.swap(f32, &t0, &t1);

    if (t0 < 0) {
        t0 = t1; // if t0 is negative, let's use t1 instead
        if (t0 < 0)
            return null; // both t0 and t1 are negative
    }

    return t0;
}
