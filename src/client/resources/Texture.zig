const std = @import("std");
const draw = @import("pixel_draw");

const resource_pool = @import("../resource_pool.zig");
const Renderer = @import("../Renderer.zig");

const Self = @This();

const Pixel = packed struct {
    r: u8,
    g: u8,
    b: u8,
    a: u8,
};

width: usize,
height: usize,
pixels: []align(4) const Pixel,
data_mutable: bool,

renderer_detail: Renderer.details.Texture,

pub inline fn data(self: Self) []align(4) const Pixel {
    return self.pixels;
}

pub fn mutData(self: Self) ![]align(4) Pixel {
    if (self.data_mutable == false)
        return error.ImmutableTexture;
    return @intToPtr([*]align(4) Pixel, @ptrToInt(self.pixels.ptr))[0 .. self.width * self.height];
}

pub fn toPixelDraw(self: Self) draw.Texture {
    return draw.Texture{
        .width = @intCast(u32, self.width),
        .height = @intCast(u32, self.height),
        .raw = @intToPtr([*]u8, @ptrToInt(self.data().ptr))[0 .. 4 * self.width * self.height],
    };
}

pub fn create(renderer: *Renderer, allocator: *std.mem.Allocator, width: usize, height: usize) !Self {
    var tex = Self{
        .width = width,
        .height = height,
        .pixels = try allocator.allocAdvanced(Pixel, 4, width * height, .exact),
        .data_mutable = true,
        .renderer_detail = undefined,
    };
    errdefer allocator.free(tex.pixels);
    tex.renderer_detail = try Renderer.details.createTexture(renderer, &tex);
    return tex;
}

pub fn deinit(renderer: *Renderer, allocator: *std.mem.Allocator, self: *Self) void {
    Renderer.details.destroyTexture(renderer, &self.renderer_detail);
    if (self.data_mutable) {
        allocator.free(self.mutData() catch unreachable);
    }
    self.* = undefined;
}

pub fn loadFromMemory(renderer: *Renderer, allocator: *std.mem.Allocator, raw_data: resource_pool.BufferView, hint: []const u8) resource_pool.Error!Self {

    // CHANGES IN HERE MUST BE REFLECTED IN
    // src/tools/tex-conv.zig
    if (!std.mem.eql(u8, raw_data[0..4], "\x99\x5b\x12\x99"))
        return error.InvalidData;

    if (std.mem.readIntLittle(u32, raw_data[4..8]) != 0x01)
        return error.InvalidData;

    var tex = Self{
        .width = std.mem.readIntLittle(u16, raw_data[8..10]),
        .height = std.mem.readIntLittle(u16, raw_data[10..12]),
        .pixels = std.mem.bytesAsSlice(Pixel, @alignCast(4, raw_data[16..])),
        .data_mutable = false,
        .renderer_detail = undefined,
    };
    tex.renderer_detail = try Renderer.details.createTexture(renderer, &tex);
    return tex;
}
