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

    if (cli.positionals.len < 3)
        return 1;

    var out_file = cli.positionals[1];

    var mtl_file_name = try allocator.dupe(u8, cli.positionals[0]);
    mtl_file_name[cli.positionals[0].len - 4 ..][0..4].* = ".mtl".*;
    defer allocator.free(mtl_file_name);

    var obj_file = try std.fs.cwd().openFile(cli.positionals[0], .{});
    defer obj_file.close();

    var mtl_file = try std.fs.cwd().openFile(mtl_file_name, .{});
    defer mtl_file.close();

    var model = try wavefront_obj.load(allocator, obj_file.inStream());
    defer model.deinit();

    var materials = try wavefront_obj.loadMaterials(allocator, mtl_file.inStream());
    defer materials.deinit();

    // Precompute and optimize model data:

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

    for (model.faces) |face| {
        if (face.vertices.len != 3) {
            std.log.err("Model must be triangulated!", .{});
            return 1;
        }

        for (face.vertices) |src_vtx| {
            var dst_vertex = Vertex{
                .position = model.positions[src_vtx.position].swizzle("xyz"),
                .normal = undefined,
                .uv = undefined,
            };
            if (src_vtx.normal) |i| {
                dst_vertex.normal = model.normals[i].normalize();
            } else {
                dst_vertex.normal = zlm.Vec3.zero;
            }
            if (src_vtx.textureCoordinate) |i| {
                dst_vertex.uv = model.textureCoordinates[i].swizzle("xy");
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

    for (model.objects) |obj| {
        if (obj.count == 0)
            std.debug.print("{}\n", .{obj});
    }

    // Verify used material data:
    for (model.objects) |obj| {
        const mtl_name = obj.material orelse {
            std.log.err("every object must have a material!", .{});
            return 1;
        };

        const mtl = materials.materials.get(mtl_name) orelse {
            std.log.err("material '{}' not found!", .{mtl_name});
            return 1;
        };

        const texture_file = mtl.diffuse_texture orelse {
            std.log.err("material '{}' has no diffuse texture!", .{mtl_name});
            return 1;
        };

        if (texture_file.len < 4) {
            std.log.err("'{}' is too short for a valid file name!", .{texture_file});
        }
    }

    // Write out the final object

    var mdl_file = try std.fs.cwd().createFile(out_file, .{});
    defer mdl_file.close();

    var stream = mdl_file.outStream();

    // design goal for the file format:
    // - in-memory representation is the file content
    // - make it easily memory-mappable

    // CHANGES IN HERE MUST BE REFLECTED IN
    // src/client/resources/Model.zig

    try stream.writeAll("\x69\x8a\x1f\xf5"); // 0x00: header/identification
    try stream.writeIntLittle(u32, 0x01); // 0x04: version

    try stream.writeIntLittle(u32, @intCast(u32, vertices.items.len)); // 0x08: vertex count
    try stream.writeIntLittle(u32, @intCast(u32, indices.items.len / 3)); // 0x0C: face count
    try stream.writeIntLittle(u32, @intCast(u32, model.objects.len)); // 0x10: object count

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
    for (model.objects) |obj| {
        try stream.writeIntLittle(u32, @intCast(u32, obj.start)); // +0x00
        try stream.writeIntLittle(u32, @intCast(u32, obj.count)); // +0x04

        // we checked all of the .? already further above
        const mtl = materials.materials.get(obj.material.?).?;
        const texture = mtl.diffuse_texture.?;

        var buffer = [1]u8{0} ** 120;

        _ = try std.fmt.bufPrint(&buffer, "{}/{}.tex", .{
            std.fs.path.dirname(cli.positionals[2]), // use the asset relative path
            texture[0 .. texture.len - 4],
        });

        try stream.writeAll(&buffer); // 0x08 … 0x80
    }

    return 0;
}

fn mapToSInt8(v: f32) i8 {
    std.debug.assert(v >= -1.0 and v <= 1.0);
    return @floatToInt(i8, 127 * v);
}
