const std = @import("std");
const network = @import("network");
const args = @import("args");
const zwl = @import("zwl");

const Game = @import("Game.zig");

const Resources = @import("Resources.zig");

var gpa = std.heap.GeneralPurposeAllocator(.{}){};
const global_allocator = &gpa.allocator;

pub const WindowPlatform = zwl.Platform(.{
    .platforms_enabled = .{
        .x11 = (std.builtin.os.tag == .linux),
        .wayland = false,
        .windows = (std.builtin.os.tag == .windows),
    },
    .single_window = false,
    .render_software = true,
    .x11_use_xcb = false,
});

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

    // Do not init windowing before necessary. We don't need a window
    // for printing a help string.

    var platform = try WindowPlatform.init(global_allocator, .{});
    defer platform.deinit();

    var window = try platform.createWindow(.{
        .title = "Zig SHOWDOWN",
        .width = 1280,
        .height = 720,
        .resizeable = false,
        .track_damage = false,
        .visible = true,
        .decorations = true,
    });
    defer window.deinit();

    var resources = Resources.init(global_allocator);
    defer resources.deinit();

    var game = try Game.init(global_allocator, &resources);
    defer game.deinit();

    var update_timer = try std.time.Timer.start();
    var render_timer = try std.time.Timer.start();

    // kick-off vblank events:
    try render(&game, window, 0.0);

    main_loop: while (true) {
        {
            const update_delta = @intToFloat(f32, update_timer.lap()) / std.time.ns_per_s;
            try game.update(update_delta);
        }

        const event = try platform.waitForEvent();

        switch (event) {
            .WindowResized => |win| {
                const size = win.getSize();
                std.log.debug("*notices size {}x{}* OwO what's this", .{ size[0], size[1] });
            },

            // someone closed the window, just stop the game:
            .WindowDestroyed, .ApplicationTerminated => break :main_loop,

            .WindowVBlank => {
                const render_delta = @intToFloat(f32, render_timer.lap()) / std.time.ns_per_s;
                try render(&game, window, render_delta);
            },

            .WindowDamaged => {}, // ignore this
        }
    }

    return 0;
}

fn render(game: *Game, window: *WindowPlatform.Window, render_delta: f32) !void {
    const pixbuf = try window.mapPixels();

    try game.render(pixbuf, render_delta);

    try window.submitPixels(&[_]zwl.UpdateArea{
        zwl.UpdateArea{
            .x = 0,
            .y = 0,
            .w = pixbuf.width,
            .h = pixbuf.height,
        },
    });
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
        \\Someone should write this
    );
}

test "" {
    _ = @import("resource_pool.zig");
    _ = @import("resources/Model.zig");
}
