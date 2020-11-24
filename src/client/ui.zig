const std = @import("std");

pub const Point = struct {
    const Self = @This();

    x: isize,
    y: isize,
};

pub const Rectangle = struct {
    const Self = @This();

    x: isize,
    y: isize,
    width: usize,
    height: usize,

    pub fn contains(self: Self, x: isize, y: isize) bool {
        if (x < self.x or y < self.y)
            return false;
        if (x >= self.x + @intCast(isize, self.width) or y >= self.y + @intCast(isize, self.height))
            return false;
        return true;
    }
};

pub const Size = struct {
    const Self = @This();

    width: usize,
    height: usize,
};
