const builtin = @import("builtin");

pub const Platform = blk: {
    switch (builtin.os.tag) {
        .linux => {
            if (@import("build_options").wayland) {
                break :blk @import("wayland.zig").Platform;
            } else {
                break :blk @import("x11.zig").Platform;
            }
        },
        .windows => break :blk @import("win32.zig").Platform,
        else => @compileError("Unsupported OS"),
    }
};
