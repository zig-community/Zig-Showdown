const std = @import("std");

pub const Graphics = @import("Renderer.zig").Configuration;

pub const KeyMapping = struct {
    up: []const u32 = &[_]u32{ 17, 103 },
    down: []const u32 = &[_]u32{ 31, 108 },
    left: []const u32 = &[_]u32{ 30, 105 },
    right: []const u32 = &[_]u32{ 32, 106 },
    accept: []const u32 = &[_]u32{28},
    back: []const u32 = &[_]u32{ 1, 14 },
    jump: []const u32 = &[_]u32{57},
};

pub const Video = struct {
    resolution: [2]u16 = [2]u16{ 1280, 720 },
    fullscreen: bool = false,
};

pub const Audio = struct {
    /// Index of the audio device to be used or `null` if none
    device_index: ?u16 = null,

    volume: Volume = .{},

    pub const Volume = struct {
        /// Total volume of the game, this affects everything
        master: f32 = 1.0,

        /// This volume affects sounds from the group "voice"
        voice: f32 = 1.0,

        /// This volume affects sounds from the group "interface"
        interface: f32 = 1.0,

        /// This volume affects sounds from the group "effects"
        effects: f32 = 1.0,

        /// This volume affects sounds from the group "music"
        music: f32 = 1.0,
    };
};

keymap: KeyMapping = .{},
video: Video = .{},
audio: Audio = .{},
graphics: Graphics = .{},
name: []const u8 = "Ziguana",
