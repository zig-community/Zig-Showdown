const std = @import("std");
const zlm = @import("zlm");

var framebuffer: [240][320]u8 = undefined;

pub fn main() !void {
    const vec3 = zlm.vec3;

    var object = Triangle{
        .vertices = [3]zlm.Vec3{
            vec3(0, 3, 5),
            vec3(-3, -3, 10),
            vec3(3, -3, 15),
        },
    };

    const aspect = @intToFloat(f32, framebuffer[0].len) / @intToFloat(f32, framebuffer.len);

    for (framebuffer) |*row, y| {
        for (row) |*pixel, x| {
            const fx = aspect * (2.0 * @intToFloat(f32, x) / @intToFloat(f32, row.len - 1) - 1.0);
            const fy = 2.0 * @intToFloat(f32, y) / @intToFloat(f32, framebuffer.len - 1) - 1.0;

            var ray = Ray{
                .origin = vec3(0, 0, 0),
                .direction = vec3(fx, fy, 1.0).normalize(),
            };

            pixel.* = if (intersect(ray, object)) |dist|
                @floatToInt(u8, 255.0 * clamp(dist - 5.0, 0.0, 10.0) / 10.0)
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

pub const Triangle = struct {
    vertices: [3]zlm.Vec3,
};

fn Intersection(comptime a: type, comptime b: type) type {
    if (a == Ray or b == Ray)
        return ?f32;
    return bool;
}

pub inline fn intersect(shape_a: anytype, shape_b: anytype) Intersection(@TypeOf(shape_a), @TypeOf(shape_b)) {
    const ShapeA = @TypeOf(shape_a);
    const ShapeB = @TypeOf(shape_b);

    const type_order = [_]type{
        Ray,
        Sphere,
        Capsule,
        Triangle,
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

    const function = switch (ShapeLeft) {
        Ray => switch (ShapeRight) {
            Ray => unreachable,
            Sphere => intersectRaySphere,
            Capsule => intersectRayCapsule,
            Triangle => intersectRayTriangle,
            else => unreachable,
        },
        Sphere => switch (ShapeRight) {
            Ray => unreachable,
            Sphere => intersectSphereSphere,
            Capsule => intersectSphereCapsule,
            Triangle => intersectSphereTriangle,
            else => unreachable,
        },
        Capsule => switch (ShapeRight) {
            Ray => unreachable,
            Sphere => unreachable,
            Capsule => @compileError(error_missing_collision),
            Triangle => @compileError(error_missing_collision),
            else => unreachable,
        },
        Triangle => switch (ShapeRight) {
            Ray => unreachable,
            Sphere => unreachable,
            Capsule => unreachable,
            Triangle => @compileError(error_missing_collision),
            else => unreachable,
        },
        else => unreachable,
    };

    return function(shape_l, shape_r);
}

fn sign(a: f32) f32 {
    return if (a > 0)
        @as(f32, 1.0)
    else if (a < 0)
        @as(f32, -1.0)
    else
        @as(f32, 0.0);
}

inline fn dot2(a: zlm.Vec3) f32 {
    return dot(a, a);
}

const dot = zlm.Vec3.dot;
const cross = zlm.Vec3.cross;
const clamp = std.math.clamp;
const sqrt = std.math.sqrt;

pub fn intersectRaySphere(ray: Ray, sphere: Sphere) ?f32 {
    // geometric solution
    const l = sphere.center.sub(ray.origin);
    const tca = dot(l, ray.direction);
    if (tca < 0)
        return null;

    const radius2 = sphere.radius * sphere.radius;

    const d2 = dot(l, l) - tca * tca;
    if (d2 > radius2)
        return null;
    const thc = sqrt(radius2 - d2);
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

pub fn intersectRayCapsule(ray: Ray, capsule: Capsule) ?f32 {
    const ba = capsule.ends[1].sub(capsule.ends[0]);
    const oa = ray.origin.sub(capsule.ends[0]);
    const baba = dot(ba, ba);
    const bard = dot(ba, ray.direction);
    const baoa = dot(ba, oa);
    const rdoa = dot(ray.direction, oa);
    const oaoa = dot(oa, oa);
    const a = baba - bard * bard;
    const b = baba * rdoa - baoa * bard;
    const c = baba * oaoa - baoa * baoa - capsule.radius * capsule.radius * baba;
    const h = b * b - a * c;
    if (h >= 0.0) {
        const t = (-b - sqrt(h)) / a;
        const y = baoa + t * bard;
        // body
        if (y > 0.0 and y < baba)
            return t;
        // caps
        const oc = if (y <= 0.0) oa else ray.origin.sub(capsule.ends[1]);
        const b2 = dot(ray.direction, oc);
        const c2 = dot(oc, oc) - capsule.radius * capsule.radius;
        const h2 = b2 * b2 - c2;
        if (h2 > 0.0)
            return (-b2 - sqrt(h2));
    }
    return null;
}

pub fn intersectRayTriangle(ray: Ray, tris: Triangle) ?f32 {
    const v1v0 = tris.vertices[1].sub(tris.vertices[0]);
    const v2v0 = tris.vertices[2].sub(tris.vertices[0]);
    const rov0 = ray.origin.sub(tris.vertices[0]);
    const n = cross(v1v0, v2v0);
    const q = cross(rov0, ray.direction);
    const d = 1.0 / dot(ray.direction, n);
    const u = -d * dot(q, v2v0);
    const v = d * dot(q, v1v0);
    const t = -d * dot(n, rov0);
    if (u < 0.0 or u > 1.0 or v < 0.0 or (u + v) > 1.0)
        return null;
    return t;
}

pub fn intersectSphereSphere(a: Sphere, b: Sphere) bool {
    const d = a.center.sub(b.center).length() - (a.radius + b.radius);
    return (d <= 0);
}

pub fn intersectSphereCapsule(sphere: Sphere, capsule: Capsule) bool {
    const pa = sphere.center.sub(capsule.ends[0]);
    const ba = capsule.ends[1].sub(capsule.ends[0]);
    const h = clamp(dot(pa, ba) / dot(ba, ba), 0.0, 1.0);
    const dist = pa.sub(ba.scale(h)).length() - sphere.radius - capsule.radius;
    return (dist <= 0);
}

pub fn intersectSphereTriangle(sphere: Sphere, triangle: Triangle) bool {
    const a = triangle.vertices[0];
    const b = triangle.vertices[1];
    const c = triangle.vertices[2];

    const ba = b.sub(a);
    const pa = sphere.center.sub(a);
    const cb = c.sub(b);
    const pb = sphere.center.sub(b);
    const ac = a.sub(c);
    const pc = sphere.center.sub(c);
    const nor = cross(ba, ac);

    const x = sign(dot(cross(ba, nor), pa)) +
        sign(dot(cross(cb, nor), pb)) +
        sign(dot(cross(ac, nor), pc));

    const dist2 = if (x < 2.0)
        std.math.min(
            std.math.min(
                dot2(ba.scale(clamp(dot(ba, pa) / dot2(ba), 0.0, 1.0)).sub(pa)),
                dot2(cb.scale(clamp(dot(cb, pb) / dot2(cb), 0.0, 1.0)).sub(pb)),
            ),
            dot2(ac.scale(clamp(dot(ac, pc) / dot2(ac), 0.0, 1.0)).sub(pc)),
        )
    else
        dot(nor, pa) * dot(nor, pa) / dot2(nor);

    return (sqrt(dist2) < sphere.radius);
}

test "ray sphere" {
    std.testing.expect(intersect(
        Ray{
            .origin = zlm.vec3(0, 0, 0),
            .direction = zlm.vec3(1, 0, 0),
        },
        Sphere{
            .center = zlm.vec3(2, 0, 0),
            .radius = 1.0,
        },
    ) != null);
    std.testing.expect(intersect(
        Ray{
            .origin = zlm.vec3(0, 0, 0),
            .direction = zlm.vec3(0, 1, 0),
        },
        Sphere{
            .center = zlm.vec3(2, 0, 0),
            .radius = 1.0,
        },
    ) == null);
}

test "ray capsule" {
    std.testing.expect(intersect(
        Ray{
            .origin = zlm.vec3(0, 0, 0),
            .direction = zlm.vec3(1, 1, 0).normalize(),
        },
        Capsule{
            .ends = [2]zlm.Vec3{
                zlm.vec3(2, -2, 0),
                zlm.vec3(2, 2, 0),
            },
            .radius = 1.0,
        },
    ) != null);
    std.testing.expect(intersect(
        Ray{
            .origin = zlm.vec3(0, 0, 0),
            .direction = zlm.vec3(1, -1, 0).normalize(),
        },
        Capsule{
            .ends = [2]zlm.Vec3{
                zlm.vec3(2, -2, 0),
                zlm.vec3(2, 2, 0),
            },
            .radius = 1.0,
        },
    ) != null);
    std.testing.expect(intersect(
        Ray{
            .origin = zlm.vec3(0, 0, 0),
            .direction = zlm.vec3(0, 1, 0),
        },
        Capsule{
            .ends = [2]zlm.Vec3{
                zlm.vec3(2, -2, 0),
                zlm.vec3(2, 2, 0),
            },
            .radius = 1.0,
        },
    ) == null);
}

test "ray triangle" {
    std.testing.expect(intersect(
        Ray{
            .origin = zlm.vec3(0, 0, 0),
            .direction = zlm.vec3(1, 0, 0),
        },
        Triangle{
            .vertices = [3]zlm.Vec3{
                zlm.vec3(1, -1, -1),
                zlm.vec3(1, 1, -1),
                zlm.vec3(1, 0, 1),
            },
        },
    ) != null);
    std.testing.expect(intersect(
        Ray{
            .origin = zlm.vec3(0, 0, 0),
            .direction = zlm.vec3(0, 1, 0),
        },
        Triangle{
            .vertices = [3]zlm.Vec3{
                zlm.vec3(1, -1, -1),
                zlm.vec3(1, 1, -1),
                zlm.vec3(1, 0, 1),
            },
        },
    ) == null);
}

test "sphere sphere" {
    std.testing.expectEqual(true, intersect(
        Sphere{
            .center = zlm.vec3(0, 0, 0),
            .radius = 1.0,
        },
        Sphere{
            .center = zlm.vec3(1, 0, 0),
            .radius = 1.0,
        },
    ));
    std.testing.expectEqual(false, intersect(
        Sphere{
            .center = zlm.vec3(0, 0, 0),
            .radius = 1.0,
        },
        Sphere{
            .center = zlm.vec3(3, 0, 0),
            .radius = 1.0,
        },
    ));
}

test "sphere capsule" {
    std.testing.expectEqual(true, intersect(
        Sphere{
            .center = zlm.vec3(0, 2, 0),
            .radius = 1.25,
        },
        Capsule{
            .ends = [2]zlm.Vec3{
                zlm.vec3(-1, 0, 0),
                zlm.vec3(1, 0, 0),
            },
            .radius = 1.0,
        },
    ));
    std.testing.expectEqual(false, intersect(
        Sphere{
            .center = zlm.vec3(0, 2, 0),
            .radius = 0.75,
        },
        Capsule{
            .ends = [2]zlm.Vec3{
                zlm.vec3(-1, 0, 0),
                zlm.vec3(1, 0, 0),
            },
            .radius = 1.0,
        },
    ));
}

test "sphere triangle" {
    std.testing.expectEqual(true, intersect(
        Sphere{
            .center = zlm.vec3(0, 0, 0),
            .radius = 1.25,
        },
        Triangle{
            .vertices = [3]zlm.Vec3{
                zlm.vec3(1, -1, -1),
                zlm.vec3(1, 1, -1),
                zlm.vec3(1, 0, 1),
            },
        },
    ));
    std.testing.expectEqual(false, intersect(
        Sphere{
            .center = zlm.vec3(0, 0, 0),
            .radius = 0.75,
        },
        Triangle{
            .vertices = [3]zlm.Vec3{
                zlm.vec3(1, -1, -1),
                zlm.vec3(1, 1, -1),
                zlm.vec3(1, 0, 1),
            },
        },
    ));
}
