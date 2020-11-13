const std = @import("std");
const args = @import("args");
const Platform = @import("platform.zig").Platform;
const Engine = @import("engine.zig").Engine;

var gpa = std.heap.GeneralPurposeAllocator(.{}){};
const global_allocator = &gpa.allocator;

pub fn main() anyerror!u8 {
    defer _ = gpa.deinit();

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

    var platform = try Platform.init();
    defer platform.deinit();

    var engine = try Engine.init();
    defer engine.deinit();

    return 0;
}

const CliArgs = struct {
    mode: u8 = 0,
    resolution: []const u8 = "800x600",
    host: []const u8 = "localhost",
    port: u16 = @import("build_options").default_port,
    help: bool = false,
    pub const shorthands = .{
        .m = "mode",
        .r = "resolution",
        .h = "host",
        .p = "port",
    };
};

fn printUsage(writer: anytype) !void {
    const usage =
        \\Usage: showdown [options]...
        \\Options:
        \\ -m, --mode <mode>        Set the initial window mode. Allowed modes are windowed, windowed_fullscreen, fullscreen, or exclusive_fullscreen
        \\ -r, --resolution <WxH>   Set the initial resolution of the window
        \\ -h, --host <host>        Specify the name of the server to connect to
        \\ -p, --port <port>        Specify the port of the server to connect to
        \\ --help                   Display this help and exit
        \\
    ;
    try writer.writeAll(usage);
}
