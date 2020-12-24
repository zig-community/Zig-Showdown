const std = @import("std");

const Self = @This();

path: []const u8,

pub fn format(
    self: Self,
    comptime fmt: []const u8,
    options: std.fmt.FormatOptions,
    writer: anytype
) !void {
    const separators =  &[_]u8{ std.fs.path.sep_windows, std.fs.path.sep_posix };
    var i: usize = 0;
    while (std.mem.indexOfAnyPos(u8, self.path, i, separators)) |j| {
        try writer.writeAll(self.path[i .. j]);
        switch (std.fs.path.sep) {
            std.fs.path.sep_windows => try writer.writeAll("\\\\"),
            std.fs.path.sep_posix => try writer.writeByte(std.fs.path.sep_posix),
            else => unreachable
        }

        i = j + 1;
    }

    try writer.writeAll(self.path[i..]);
}
