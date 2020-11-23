const std = @import("std");
const draw = @import("pixel_draw");

const renderer = @import("root").renderer;
const resource_pool = @import("../resource_pool.zig");

const Self = @This();

const Pixel = packed struct {
    r: u8,
    g: u8,
    b: u8,
    a: u8,
};

width: usize,
height: usize,
pixels: []Pixel,

renderer_detail: renderer.Texture,

pub fn toPixelDraw(self: Self) draw.Texture {
    return draw.Texture{
        .width = @intCast(u32, self.width),
        .height = @intCast(u32, self.height),
        .raw = std.mem.sliceAsBytes(self.pixels),
    };
}

pub fn deinit(allocator: *std.mem.Allocator, self: *Self) void {
    renderer.destroyTexture(&self.renderer_detail);
    allocator.free(self.pixels);
    self.* = undefined;
}

pub fn loadFromMemory(allocator: *std.mem.Allocator, raw_data: []const u8, hint: []const u8) resource_pool.Error!Self {

    // CHANGES IN HERE MUST BE REFLECTED IN
    // src/tools/tex-conv.zig
    if (!std.mem.eql(u8, raw_data[0..4], "\x99\x5b\x12\x99"))
        return error.InvalidData;

    if (std.mem.readIntLittle(u32, raw_data[4..8]) != 0x01)
        return error.InvalidData;

    const pixels = try allocator.dupe(Pixel, std.mem.bytesAsSlice(Pixel, raw_data[16..]));
    errdefer allocator.free(pixels);

    var tex = Self{
        .width = std.mem.readIntLittle(u16, raw_data[8..10]),
        .height = std.mem.readIntLittle(u16, raw_data[10..12]),
        .pixels = pixels,
        .renderer_detail = undefined,
    };
    tex.renderer_detail = try renderer.createTexture(&tex);
    return tex;
}
