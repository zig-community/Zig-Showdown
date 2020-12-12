const std = @import("std");
const res = @import("resource_pool.zig");

const Audio = @import("Audio.zig");

pub const Renderer = @import("Renderer.zig");
pub const Model = @import("resources/Model.zig");
pub const Texture = @import("resources/Texture.zig");
pub const Font = @import("resources/Font.zig");
pub const Sound = @import("resources/Sound.zig");

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

const ResourceRoot = if (res.uses_embedded_data)
    void
else
    std.fs.Dir;

root_directory: ResourceRoot,
textures: TexturePool,
models: ModelPool,
fonts: FontPool,
sounds: SoundPool,

pub fn init(allocator: *std.mem.Allocator, renderer: *Renderer, audio: *Audio) !Self {
    var path: [std.fs.MAX_PATH_BYTES]u8 = undefined;

    const assets_folder = "/assets";

    var exe_dir = try std.fs.selfExeDirPath(&path);
    std.debug.assert(exe_dir.len < path.len - assets_folder.len);

    var root = path[0..exe_dir.len];
    root.len += assets_folder.len;
    root[root.len - assets_folder.len ..][0..assets_folder.len].* = assets_folder.*;

    var dir = if (res.uses_embedded_data) {} else
        try std.fs.cwd().openDir(root, .{});
    errdefer dir.close();

    return Self{
        .root_directory = dir,
        .textures = TexturePool.init(allocator, dir, renderer),
        .models = ModelPool.init(allocator, dir, renderer),
        .fonts = FontPool.init(allocator, dir, renderer),
        .sounds = SoundPool.init(allocator, dir, audio),
    };
}

pub fn deinit(self: *Self) void {
    self.textures.deinit();
    self.models.deinit();
    self.fonts.deinit();
    self.sounds.deinit();
    if (!res.uses_embedded_data)
        self.root_directory.close();
    self.* = undefined;
}
