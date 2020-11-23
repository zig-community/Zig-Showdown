const std = @import("std");

const Renderer = @import("../Renderer.zig");
const Resources = @import("../Resources.zig");

const Self = @This();

renderer: *Renderer,

/// The content of this texture is undefined and should not be read back on the CPU.
/// If `null`, it is assumed that the render target is the screen.
backing_texture: ?Resources.Texture,

pub fn deinit(self: *Self) void {
    if (self.backing_texture) |*texture| {
        Resources.Texture.deinit(self.renderer, self.renderer.allocator, texture);
    }
    self.* = undefined;
}
