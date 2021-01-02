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
                @floatToInt(u8, 255.0 * clamp(dist.distance - 5.0, 0.0, 10.0) / 10.0)
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

pub const RayObjectIntersection = struct {
    distance: f32,
};

pub const VolumeIntersection = struct {
    const none: ?VolumeIntersection = null;
    const some: ?VolumeIntersection = @This(){};
};

fn Intersection(comptime a: type, comptime b: type) type {
    if (a == Ray or b == Ray)
        return ?RayObjectIntersection;
    return ?VolumeIntersection;
}

/// Intersects two different geometric shapes. Always returns an optional struct value that is non-`null`
/// when an intersection happened and `null` if there is no intersection.
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
            Capsule => intersectCapsuleCapsule,
            Triangle => intersectCapsuleTriangle,
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
const abs = std.math.absFloat;

inline fn saturate(f: f32) f32 {
    return clamp(f, 0.0, 1.0);
}

pub fn intersectRaySphere(ray: Ray, sphere: Sphere) ?RayObjectIntersection {
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

    return RayObjectIntersection{ .distance = t0 };
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

pub fn intersectRayCapsule(ray: Ray, capsule: Capsule) ?RayObjectIntersection {
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
            return RayObjectIntersection{ .distance = t };
        // caps
        const oc = if (y <= 0.0) oa else ray.origin.sub(capsule.ends[1]);
        const b2 = dot(ray.direction, oc);
        const c2 = dot(oc, oc) - capsule.radius * capsule.radius;
        const h2 = b2 * b2 - c2;
        if (h2 > 0.0)
            return RayObjectIntersection{ .distance = (-b2 - sqrt(h2)) };
    }
    return null;
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

pub fn intersectRayTriangle(ray: Ray, tris: Triangle) ?RayObjectIntersection {
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
    return RayObjectIntersection{ .distance = t };
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

pub fn intersectSphereSphere(a: Sphere, b: Sphere) ?VolumeIntersection {
    const d = a.center.sub(b.center).length() - (a.radius + b.radius);
    return if (d <= 0) VolumeIntersection.some else VolumeIntersection.none;
}

test "sphere sphere" {
    std.testing.expectEqual(VolumeIntersection.some, intersect(
        Sphere{
            .center = zlm.vec3(0, 0, 0),
            .radius = 1.0,
        },
        Sphere{
            .center = zlm.vec3(1, 0, 0),
            .radius = 1.0,
        },
    ));
    std.testing.expectEqual(VolumeIntersection.none, intersect(
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

pub fn intersectSphereCapsule(sphere: Sphere, capsule: Capsule) ?VolumeIntersection {
    const pa = sphere.center.sub(capsule.ends[0]);
    const ba = capsule.ends[1].sub(capsule.ends[0]);
    const h = clamp(dot(pa, ba) / dot(ba, ba), 0.0, 1.0);
    const dist = pa.sub(ba.scale(h)).length() - sphere.radius - capsule.radius;
    return if (dist <= 0) VolumeIntersection.some else VolumeIntersection.none;
}

test "sphere capsule" {
    std.testing.expectEqual(VolumeIntersection.some, intersect(
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
    std.testing.expectEqual(VolumeIntersection.none, intersect(
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

pub fn intersectSphereTriangle(sphere: Sphere, triangle: Triangle) ?VolumeIntersection {
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

    return if (sqrt(dist2) < sphere.radius) VolumeIntersection.some else VolumeIntersection.none;
}

test "sphere triangle" {
    std.testing.expectEqual(VolumeIntersection.some, intersect(
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
    std.testing.expectEqual(VolumeIntersection.none, intersect(
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

fn getClosestPointOnLineSegment(a: zlm.Vec3, b: zlm.Vec3, point: zlm.Vec3) zlm.Vec3 {
    const ab = b.sub(a);
    const t = dot(point.sub(a), ab) / dot(ab, ab);
    return a.add(ab.scale(saturate(t))); // saturate(t) can be written as: min((max(t, 0), 1)
}

// capsule functions are implemented after
// https://wickedengine.net/2020/04/26/capsule-collision-detection/

pub fn intersectCapsuleCapsule(a: Capsule, b: Capsule) ?VolumeIntersection {
    // capsule A:
    const a_A = a.ends[1];
    const a_B = a.ends[0];

    // capsule B:
    const b_A = b.ends[1];
    const b_B = b.ends[0];

    // vectors between line endpoints:
    const v0 = b_A.sub(a_A);
    const v1 = b_B.sub(a_A);
    const v2 = b_A.sub(a_B);
    const v3 = b_B.sub(a_B);

    // squared distances:
    const d0 = dot(v0, v0);
    const d1 = dot(v1, v1);
    const d2 = dot(v2, v2);
    const d3 = dot(v3, v3);

    // select best potential endpoint on capsule A:
    const helper_point =
        if (d2 < d0 or d2 < d1 or d3 < d0 or d3 < d1)
        a_B
    else
        a_A;

    // select point on capsule B line segment nearest to best potential endpoint on A capsule:
    const bestB = getClosestPointOnLineSegment(b_A, b_B, helper_point);

    // now do the same for capsule A segment:
    const bestA = getClosestPointOnLineSegment(a_A, a_B, bestB);

    const penetration_normal = bestA.sub(bestB);
    const len = penetration_normal.length();
    // penetration_normal /= len;  // normalize
    const penetration_depth = a.radius + b.radius - len;
    return if (penetration_depth > 0.0)
        VolumeIntersection.some
    else
        VolumeIntersection.none;
}

test "capsule capsule" {
    // Test Geometry:
    //    /'\
    //    | | <===>
    //    \_/
    std.testing.expectEqual(VolumeIntersection.some, intersect(
        Capsule{
            .ends = [2]zlm.Vec3{
                zlm.vec3(2, 0, 0),
                zlm.vec3(4, 0, 0),
            },
            .radius = 1.25,
        },
        Capsule{
            .ends = [2]zlm.Vec3{
                zlm.vec3(0, -2, 0),
                zlm.vec3(0, 2, 0),
            },
            .radius = 1.0,
        },
    ));
    std.testing.expectEqual(VolumeIntersection.none, intersect(
        Capsule{
            .ends = [2]zlm.Vec3{
                zlm.vec3(2, 0, 0),
                zlm.vec3(4, 0, 0),
            },
            .radius = 0.75,
        },
        Capsule{
            .ends = [2]zlm.Vec3{
                zlm.vec3(0, -2, 0),
                zlm.vec3(0, 2, 0),
            },
            .radius = 1.0,
        },
    ));
}

pub fn intersectCapsuleTriangle(capsule: Capsule, triangle: Triangle) ?VolumeIntersection {
    const A = capsule.ends[0];
    const B = capsule.ends[1];

    const capsule_normal = B.sub(A).normalize();

    const p0 = triangle.vertices[0];
    const p1 = triangle.vertices[1];
    const p2 = triangle.vertices[2];

    const N = cross(
        p1.sub(p0).normalize(),
        p0.sub(p2).normalize(),
    );

    // Then for each triangle, ray-plane intersection:
    //  N is the triangle plane normal (it was computed in sphere - triangle intersection case)
    const t = dot(N, (p0.sub(capsule.ends[0])).scale(1.0 / abs(dot(N, capsule_normal))));
    const line_plane_intersection = capsule.ends[0].add(capsule_normal.scale(t));

    // Determine whether line_plane_intersection is inside all triangle edges:
    const c0 = cross(line_plane_intersection.sub(p0), p1.sub(p0));
    const c1 = cross(line_plane_intersection.sub(p1), p2.sub(p1));
    const c2 = cross(line_plane_intersection.sub(p2), p0.sub(p2));
    const inside = (dot(c0, N) <= 0) and (dot(c1, N) <= 0) and (dot(c2, N) <= 0);

    const reference_point = if (inside)
        line_plane_intersection
    else blk: {
        // Edge 1:
        const point1 = getClosestPointOnLineSegment(p0, p1, line_plane_intersection);
        const v1 = line_plane_intersection.sub(point1);
        const distsq_1 = dot(v1, v1);
        var best_dist = distsq_1;

        var ref_pt = point1;

        // Edge 2:
        const point2 = getClosestPointOnLineSegment(p1, p2, line_plane_intersection);
        const v2 = line_plane_intersection.sub(point2);
        const distsq_2 = dot(v2, v2);
        if (distsq_2 < best_dist) {
            ref_pt = point2;
            best_dist = distsq_2;
        }

        // Edge 3:
        const point3 = getClosestPointOnLineSegment(p2, p0, line_plane_intersection);
        const v3 = line_plane_intersection.sub(point3);
        const distsq_3 = dot(v3, v3);
        if (distsq_3 < best_dist) {
            ref_pt = point3;
            best_dist = distsq_3;
        }

        break :blk ref_pt;
    };

    // The center of the best sphere candidate:
    const center = getClosestPointOnLineSegment(A, B, reference_point);

    // There is a corner case with this. When the capsule line is parallel to the triangle plane, the
    // ray–plane trace will fail. You can detect this case by checking the dot product between the
    // ray direction (CapsuleNormal) and triangle normal (N). If it’s zero, then they are parallel.
    // When this happens, instead of relying on the tracing, a simple fix is to just take an arbitrary
    // point (for example the first corner) from the triangle and use that as reference point. The
    // reference point will be used the same way as the intersection point, to determine the closest
    // point on the capsule A-B segment.

    return intersectSphereTriangle(
        Sphere{
            .center = center,
            .radius = capsule.radius,
        },
        triangle,
    );
}

test "capsule triangle" {
    // Test Geometry:
    //    /'\
    //    | |
    //    \_/
    //    ___
    std.testing.expectEqual(VolumeIntersection.some, intersect(
        Capsule{
            .ends = [2]zlm.Vec3{
                zlm.vec3(1, 0, 0),
                zlm.vec3(3, 0, 0),
            },
            .radius = 1.25,
        },
        Triangle{
            .vertices = [3]zlm.Vec3{
                zlm.vec3(0, -1, -1),
                zlm.vec3(0, 1, -1),
                zlm.vec3(0, 0, 1),
            },
        },
    ));
    std.testing.expectEqual(VolumeIntersection.none, intersect(
        Capsule{
            .ends = [2]zlm.Vec3{
                zlm.vec3(1, 0, 0),
                zlm.vec3(3, 0, 0),
            },
            .radius = 0.75,
        },
        Triangle{
            .vertices = [3]zlm.Vec3{
                zlm.vec3(0, -1, -1),
                zlm.vec3(0, 1, -1),
                zlm.vec3(0, 0, 1),
            },
        },
    ));
}
