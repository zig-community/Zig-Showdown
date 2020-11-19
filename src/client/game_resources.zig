const std = @import("std");
const res = @import("resource_pool.zig");
const draw = @import("pixel_draw");

const Self = @This();

pub const usage = struct {
    pub const generic_render = 0x01;
    pub const menu_render = 0x02;
};

pub const TexturePool = res.ResourcePool(draw.Texture, loadTexture, freeTexture);

textures: TexturePool,

pub fn init(allocator: *std.mem.Allocator) Self {
    return Self{
        .textures = TexturePool.init(allocator),
    };
}

pub fn deinit(self: *Self) void {
    self.textures.deinit();
    self.* = undefined;
}

fn loadTexture(allocator: *std.mem.Allocator, buffer: []const u8, hint: []const u8) res.Error!draw.Texture {
    return draw.textureFromTgaData(allocator, buffer) catch |err| switch (err) {
        error.OutOfMemory => return error.OutOfMemory,
        else => return error.InvalidData,
    };
}

fn freeTexture(allocator: *std.mem.Allocator, self: *draw.Texture) void {
    allocator.free(self.raw);
    self.* = undefined;
}
