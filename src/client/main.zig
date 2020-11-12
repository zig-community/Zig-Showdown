const std = @import("std");
const network = @import("network");
const args = @import("args");

var gpa = std.heap.GeneralPurposeAllocator(.{}){};
const global_allocator = &gpa.allocator;

pub fn main() anyerror!u8 {
    defer _ = gpa.deinit();

    try network.init();
    defer network.deinit();

    var cli = args.parseForCurrentProcess(CliArgs, global_allocator) catch |err| switch (err) {
        error.EncounteredUnknownArgument => {
            try printUsage(std.io.getStdErr().writer());
            return 1;
        },
        else => |e| return e,
    };
    defer cli.deinit();

    if (cli.options.help) {
        try printUsage(std.io.getStdOut().writer());
        return 0;
    }

    std.log.info("All your codebase are belong to us.", .{});

    return 0;
}

const CliArgs = struct {
    // In release mode, run the game in fullscreen by default,
    // otherwise use windowed mode
    fullscreen: bool = if (std.builtin.mode != .Debug)
        true
    else
        false,

    port: u16 = @import("build_options").default_port,

    help: bool = false,

    pub const shorthands = .{
        .f = "fullscreen",
    };
};

fn printUsage(writer: anytype) !void {
    try writer.writeAll(
        \\
    );
}
