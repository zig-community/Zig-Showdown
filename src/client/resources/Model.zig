const std = @import("std");
const zlm = @import("zlm");

const resource_pool = @import("../resource_pool.zig");
const Renderer = @import("../Renderer.zig");

const Self = @This();

pub const Index = u32;

pub const Vertex = extern struct {
    x: f32,
    y: f32,
    z: f32,
    nx: i8,
    ny: i8,
    nz: i8,
    _padding0: u8 = 0,
    u: f32,
    v: f32,
    _padding1: u32 = 0,
    _padding2: u32 = 0,
};

comptime {
    std.debug.assert(@byteOffsetOf(Vertex, "x") == 0x00);
    std.debug.assert(@byteOffsetOf(Vertex, "y") == 0x04);
    std.debug.assert(@byteOffsetOf(Vertex, "z") == 0x08);
    std.debug.assert(@byteOffsetOf(Vertex, "nx") == 0x0C);
    std.debug.assert(@byteOffsetOf(Vertex, "ny") == 0x0D);
    std.debug.assert(@byteOffsetOf(Vertex, "nz") == 0x0E);
    std.debug.assert(@byteOffsetOf(Vertex, "u") == 0x10);
    std.debug.assert(@byteOffsetOf(Vertex, "v") == 0x14);
    std.debug.assert(@sizeOf(Vertex) == 0x20);
}

/// A mesh is a portion of the models faces that
/// is associated with a texture and
/// some material properties.
pub const Mesh = extern struct {
    offset: u32,
    length: u32,
    texture_buf: [120]u8,

    pub fn texture(self: *const @This()) []const u8 {
        return if (std.mem.indexOf(u8, &self.texture_buf, "\x00")) |idx|
            self.texture_buf[0..idx]
        else
            &self.texture_buf;
    }
};

comptime {
    std.debug.assert(@byteOffsetOf(Mesh, "offset") == 0x00);
    std.debug.assert(@byteOffsetOf(Mesh, "length") == 0x04);
    std.debug.assert(@byteOffsetOf(Mesh, "texture_buf") == 0x08);
    std.debug.assert(@sizeOf(Mesh) == 0x80);
}

arena: std.heap.ArenaAllocator,

bbox_min: zlm.Vec3,
bbox_max: zlm.Vec3,

vertices: []const Vertex,
indices: []const Index,
meshes: []const Mesh,

renderer_detail: Renderer.details.Model,

pub fn deinit(renderer: *Renderer, allocator: *std.mem.Allocator, self: *Self) void {
    Renderer.details.destroyModel(renderer, &self.renderer_detail);
    self.arena.deinit();
    self.* = undefined;
}

pub fn loadFromMemory(renderer: *Renderer, allocator: *std.mem.Allocator, raw_data: resource_pool.BufferView, hint: []const u8) resource_pool.Error!Self {

    // CHANGES IN HERE MUST BE REFLECTED IN
    // src/tools/obj-conv.zig
    if (!std.mem.eql(u8, raw_data[0..4], "\x69\x8a\x1f\xf5"))
        return error.InvalidData;

    if (std.mem.readIntLittle(u32, raw_data[4..8]) != 0x01)
        return error.InvalidData;

    var model = Self{
        .arena = std.heap.ArenaAllocator.init(allocator),

        .bbox_min = undefined,
        .bbox_max = undefined,

        .vertices = undefined,
        .indices = undefined,
        .meshes = undefined,

        .renderer_detail = undefined,
    };
    errdefer model.arena.deinit();

    const vertex_count = std.mem.readIntLittle(u32, raw_data[0x08..][0..4]);
    const face_count = std.mem.readIntLittle(u32, raw_data[0x0C..][0..4]);
    const object_count = std.mem.readIntLittle(u32, raw_data[0x10..][0..4]);

    const index_count = 3 * face_count;

    model.bbox_min.x = @bitCast(f32, std.mem.readIntLittle(u32, raw_data[0x14..][0..4]));
    model.bbox_min.y = @bitCast(f32, std.mem.readIntLittle(u32, raw_data[0x18..][0..4]));
    model.bbox_min.z = @bitCast(f32, std.mem.readIntLittle(u32, raw_data[0x1C..][0..4]));

    model.bbox_max.x = @bitCast(f32, std.mem.readIntLittle(u32, raw_data[0x20..][0..4]));
    model.bbox_max.y = @bitCast(f32, std.mem.readIntLittle(u32, raw_data[0x24..][0..4]));
    model.bbox_max.z = @bitCast(f32, std.mem.readIntLittle(u32, raw_data[0x28..][0..4]));

    // Clone the disk data, as we might to change endianess for
    // big-endian platforms
    // TODO: This can be omitted if we use mmap/@embedFile and
    // keep the data alive in the pool itself.
    var data = raw_data[0x30..]; // try model.arena.allocator.dupe(u8, );

    model.vertices = std.mem.bytesAsSlice(
        Vertex,
        @alignCast(@alignOf(Vertex), data[0 .. @sizeOf(Vertex) * vertex_count]),
    );
    model.indices = std.mem.bytesAsSlice(
        Index,
        @alignCast(@alignOf(Index), data[@sizeOf(Vertex) * vertex_count ..][0 .. @sizeOf(Index) * index_count]),
    );
    model.meshes = std.mem.bytesAsSlice(
        Mesh,
        @alignCast(@alignOf(Mesh), data[@sizeOf(Vertex) * vertex_count + @sizeOf(Index) * index_count ..][0 .. @sizeOf(Mesh) * object_count]),
    );

    // Swap endianess on big-endian platforms
    if (std.builtin.endian == .Big) {
        for (model.vertices) |*v| {
            v.x = @byteSwap(f32, v.x);
            v.y = @byteSwap(f32, v.y);
            v.z = @byteSwap(f32, v.z);
            v.u = @byteSwap(f32, v.u);
            v.v = @byteSwap(f32, v.v);
        }
        for (model.indices) |*i| {
            i.* = @byteSwap(Index, i.*);
        }
        for (model.meshes) |*m| {
            m.offset = @byteSwap(u32, m.offset);
            m.length = @byteSwap(u32, m.length);
        }
    }

    model.renderer_detail = try Renderer.details.createModel(renderer, &model);

    return model;
}
