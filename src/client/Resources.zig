const std = @import("std");
const res = @import("resource_pool.zig");

const Audio = @import("Audio.zig");

pub const Renderer = @import("Renderer.zig");
pub const Model = @import("resources/Model.zig");
pub const Texture = @import("resources/Texture.zig");
pub const Font = @import("resources/Font.zig");
pub const Sound = Audio.Sound;

const Self = @This();

pub const usage = struct {
    pub const generic_render: u32 = 1;
    pub const menu_render: u32 = 2;
    pub const level_render: u32 = 4;
    pub const debug_draw: u32 = 0x80000000;
};

pub const TexturePool = res.ResourcePool(Texture, *Renderer, Texture.loadFromMemory, Texture.deinit);
pub const FontPool = res.ResourcePool(Font, *Renderer, Font.loadFromMemory, Font.deinit);
pub const ModelPool = res.ResourcePool(Model, *Renderer, Model.loadFromMemory, Model.deinit);
pub const SoundPool = res.ResourcePool(Sound, *Audio, Sound.loadSoundFromMemory, Sound.freeSound);

textures: TexturePool,
models: ModelPool,
fonts: FontPool,
sounds: SoundPool,

pub fn init(allocator: *std.mem.Allocator, renderer: *Renderer, audio: *Audio) Self {
    return Self{
        .textures = TexturePool.init(allocator, renderer),
        .models = ModelPool.init(allocator, renderer),
        .fonts = FontPool.init(allocator, renderer),
        .sounds = SoundPool.init(allocator, audio),
    };
}

pub fn deinit(self: *Self) void {
    self.textures.deinit();
    self.models.deinit();
    self.fonts.deinit();
    self.sounds.deinit();
    self.* = undefined;
}
