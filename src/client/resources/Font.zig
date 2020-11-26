//! A font is actually just a texture in disguise

const std = @import("std");
const draw = @import("pixel_draw");

const resource_pool = @import("../resource_pool.zig");
const Renderer = @import("../Renderer.zig");
const Texture = @import("Texture.zig");

const Self = @This();

texture: Texture,
glyph_size: Renderer.Size,

pub fn deinit(renderer: *Renderer, allocator: *std.mem.Allocator, self: *Self) void {
    Texture.deinit(renderer, allocator, &self.texture);
    self.* = undefined;
}

pub fn loadFromMemory(renderer: *Renderer, allocator: *std.mem.Allocator, raw_data: resource_pool.BufferView, hint: []const u8) resource_pool.Error!Self {
    var tex = try Texture.loadFromMemory(renderer, allocator, raw_data, hint);
    errdefer Texture.deinit(renderer, allocator, &tex);

    return Self{
        .texture = tex,
        .glyph_size = Renderer.Size{
            .width = tex.width / 16,
            .height = tex.height / 16,
        },
    };
}
