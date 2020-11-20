//! This tool converts Wavefront OBJ to the projects own model format
const std = @import("std");
const args = @import("args");
const zlm = @import("zlm");
const wavefront_obj = @import("wavefront-obj");

var gpa = std.heap.GeneralPurposeAllocator(.{}){};
const allocator = &gpa.allocator;

pub fn main() !u8 {
    defer _ = gpa.deinit();

    var cli = try args.parseForCurrentProcess(struct {
        // nothing…
    }, allocator);
    defer cli.deinit();

    if (cli.positionals.len != 1)
        return 1;

    var out_file = try allocator.dupe(u8, cli.positionals[0]);
    defer allocator.free(out_file);

    out_file[out_file.len - 4 ..][0..4].* = ".mdl".*;

    var bsp_file = try std.fs.cwd().openFile(cli.positionals[0], .{});
    defer bsp_file.close();

    var model = try wavefront_obj.load(allocator, bsp_file.inStream());
    defer model.deinit();

    const Vertex = extern struct {
        position: zlm.Vec3,
        normal: zlm.Vec3,
        uv: zlm.Vec2,

        fn eql(a: @This(), b: @This()) bool {
            return std.math.approxEqAbs(f32, a.position.x, b.position.x, 1e-9) and
                std.math.approxEqAbs(f32, a.position.y, b.position.y, 1e-9) and
                std.math.approxEqAbs(f32, a.position.z, b.position.z, 1e-9) and
                std.math.approxEqAbs(f32, a.normal.x, b.normal.x, 1e-9) and
                std.math.approxEqAbs(f32, a.normal.y, b.normal.y, 1e-9) and
                std.math.approxEqAbs(f32, a.normal.z, b.normal.z, 1e-9) and
                std.math.approxEqAbs(f32, a.uv.x, b.uv.x, 1e-6) and
                std.math.approxEqAbs(f32, a.uv.y, b.uv.y, 1e-6);
        }
    };

    var vertices = std.ArrayList(Vertex).init(allocator);
    defer vertices.deinit();

    var indices = std.ArrayList(u32).init(allocator);
    defer indices.deinit();

    for (model.faces.items) |face| {
        if (face.count != 3) {
            std.debug.warn("Model must be triangulated!\n", .{});
            return 1;
        }

        for (face.vertices[0..3]) |src_vtx| {
            var dst_vertex = Vertex{
                .position = model.positions.items[src_vtx.position].swizzle("xyz"),
                .normal = undefined,
                .uv = undefined,
            };
            if (src_vtx.normal) |i| {
                dst_vertex.normal = model.normals.items[i].normalize();
            } else {
                dst_vertex.normal = zlm.Vec3.zero;
            }
            if (src_vtx.textureCoordinate) |i| {
                dst_vertex.uv = model.textureCoordinates.items[i].swizzle("xy");
            } else {
                dst_vertex.uv = zlm.Vec2.zero;
            }

            // Deduplicate all vertices
            const index = for (vertices.items) |v, i| {
                if (v.eql(dst_vertex))
                    break i;
            } else blk: {
                const ind = vertices.items.len;
                try vertices.append(dst_vertex);
                break :blk ind;
            };

            try indices.append(@intCast(u32, index));
        }
    }

    var bb_min = zlm.vec3(std.math.inf(f32), std.math.inf(f32), std.math.inf(f32));
    var bb_max = zlm.vec3(-std.math.inf(f32), -std.math.inf(f32), -std.math.inf(f32));

    for (vertices.items) |vtx| {
        bb_min = zlm.Vec3.componentMin(bb_min, vtx.position);
        bb_max = zlm.Vec3.componentMax(bb_max, vtx.position);
    }

    // Write out the final object

    var mdl_file = try std.fs.cwd().createFile(out_file, .{});
    defer mdl_file.close();

    var stream = mdl_file.outStream();

    // design goal for the file format:
    // - in-memory representation is the file content
    // - make it easily memory-mappable

    try stream.writeAll("\x69\x8a\x1f\xf5"); // 0x00: header/identification
    try stream.writeIntLittle(u32, 0x01); // 0x04: version

    try stream.writeIntLittle(u32, @intCast(u32, vertices.items.len)); // 0x08: vertex count
    try stream.writeIntLittle(u32, @intCast(u32, indices.items.len / 3)); // 0x0C: face count
    try stream.writeIntLittle(u32, @intCast(u32, model.objects.items.len)); // 0x10: object count

    try stream.writeIntLittle(u32, @bitCast(u32, bb_min.x)); // +0x14
    try stream.writeIntLittle(u32, @bitCast(u32, bb_min.y)); // +0x18
    try stream.writeIntLittle(u32, @bitCast(u32, bb_min.z)); // +0x1C

    try stream.writeIntLittle(u32, @bitCast(u32, bb_max.x)); // +0x20
    try stream.writeIntLittle(u32, @bitCast(u32, bb_max.y)); // +0x24
    try stream.writeIntLittle(u32, @bitCast(u32, bb_max.z)); // +0x28

    try stream.writeIntLittle(u32, 0); // 0x2C: padding

    // first vertex at 0x30:
    for (vertices.items) |vtx| {
        try stream.writeIntLittle(u32, @bitCast(u32, vtx.position.x)); // +0x00
        try stream.writeIntLittle(u32, @bitCast(u32, vtx.position.y)); // +0x04
        try stream.writeIntLittle(u32, @bitCast(u32, vtx.position.z)); // +0x08

        try stream.writeIntLittle(i8, mapToSInt8(vtx.normal.x)); // +0x0C
        try stream.writeIntLittle(i8, mapToSInt8(vtx.normal.y)); // +0x0D
        try stream.writeIntLittle(i8, mapToSInt8(vtx.normal.z)); // +0x0E
        try stream.writeIntLittle(u8, 0); // +0x0F (padding)

        try stream.writeIntLittle(u32, @bitCast(u32, vtx.uv.x)); // +0x10
        try stream.writeIntLittle(u32, @bitCast(u32, vtx.uv.y)); // +0x14

        try stream.writeIntLittle(u32, 0); // +0x18 (padding)
        try stream.writeIntLittle(u32, 0); // +0x1C (padding)
    }

    // first index at 0x30 + 0x20 * vertex_count
    for (indices.items) |idx| {
        try stream.writeIntLittle(u32, idx); // +0x18 (padding)
    }

    // first object at 0x30 + 0x20 * vertex_count + 0x04 * index_coun
    for (model.objects.items) |obj| {
        try stream.writeIntLittle(u32, @intCast(u32, obj.start)); // +0x00
        try stream.writeIntLittle(u32, @intCast(u32, obj.count)); // +0x04

        const mtl = obj.material orelse "";

        const name_length = 120; // pad to 0x80 byte length
        const length = std.math.min(mtl.len, name_length);
        const padding = name_length - length;

        try stream.writeAll(mtl[0..length]); // 0x08 … 0x80
        try stream.writeByteNTimes(0x00, padding);
    }

    return 0;
}

fn mapToSInt8(v: f32) i8 {
    std.debug.assert(v >= -1.0 and v <= 1.0);
    return @floatToInt(i8, 127 * v);
}
