const std = @import("std");
const network = @import("network");

pub fn main() anyerror!void {
    try network.init();
    defer network.deinit();

    std.log.info("All your codebase are belong to us.", .{});
}
