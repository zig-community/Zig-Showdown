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

    const wavefront_obj = @import("wavefront-obj");

    var fbs = std.io.fixedBufferStream(raw_data);

    var model = try wavefront_obj.load(allocator, fbs.inStream());
    defer model.deinit();

    return map;
}

test "Load obj based map" {
    var bsp_buffer = try std.fs.cwd().readFileAlloc(std.testing.allocator, "assets/maps/demo.obj", 1 << 30);
    defer std.testing.allocator.free(bsp_buffer);

    var map = try loadFromMemory(std.testing.allocator, bsp_buffer);
    defer map.deinit();
}
