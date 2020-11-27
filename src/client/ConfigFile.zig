const std = @import("std");

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

keymap: KeyMapping = .{},
video: Video = .{},
name: []const u8 = "Ziguana",
