const std = @import("std");

const Self = @This();

arena: std.heap.ArenaAllocator,

pub fn deinit(self: *Self) void {
    self.arena.deinit();
    self.* = undefined;
}

pub fn loadFromMemory(allocator: *std.mem.Allocator, raw_data: []const u8) !Self {
    var map = Self{
        .arena = std.heap.ArenaAllocator.init(allocator),
    };
    errdefer map.arena.deinit();

    // TODO: raw_data already contains a ready-to-use data structure, just duplicate it and be happy!

    return map;
}
