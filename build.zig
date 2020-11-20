const std = @import("std");

const pkgs = struct {
    const network = std.build.Pkg{
        .name = "network",
        .path = "./deps/zig-network/network.zig",
    };

    const args = std.build.Pkg{
        .name = "args",
        .path = "./deps/zig-args/args.zig",
    };

    const pixel_draw = std.build.Pkg{
        .name = "pixel_draw",
        .path = "./deps/pixel_draw/src/pixel_draw_module.zig",
    };

    const zwl = std.build.Pkg{
        .name = "zwl",
        .path = "./deps/zwl/src/zwl.zig",
    };

    const painterz = std.build.Pkg{
        .name = "painterz",
        .path = "./deps/painterz/painterz.zig",
    };
};

const State = enum {
    create_server,
    create_sp_game,
    credits,
    gameplay,
    join_game,
    main_menu,
    options,
    pause_menu,
    splash,
};

pub fn build(b: *std.build.Builder) void {
    const target = b.standardTargetOptions(.{});
    const mode = b.standardReleaseOptions();

    const default_port = b.option(u16, "default-port", "The port the game will use as its default port") orelse 3315;

    const initial_state = b.option(State, "initial-state", "The initial state of the game. This is only relevant for debugging.") orelse .splash;

    {
        const client = b.addExecutable("showdown", "src/client/main.zig");
        client.addPackage(pkgs.network);
        client.addPackage(pkgs.args);
        client.addPackage(pkgs.pixel_draw);
        client.addPackage(pkgs.zwl);
        client.addPackage(pkgs.painterz);
        client.setTarget(target);
        client.setBuildMode(mode);
        client.addBuildOption(State, "initial_state", initial_state);

        client.linkLibC();
        client.linkSystemLibrary("m");

        // // NOTE(Samuel): This is temporary
        // if (@import("builtin").os.tag != .windows) {
        //     client.linkSystemLibrary("c");
        //     client.linkSystemLibrary("X11");
        // }

        client.addBuildOption(u16, "default_port", default_port);
        client.install();

        const run_client_cmd = client.run();
        run_client_cmd.step.dependOn(b.getInstallStep());
        if (b.args) |args| {
            run_client_cmd.addArgs(args);
        }

        const run_client_step = b.step("run", "Run the app");
        run_client_step.dependOn(&run_client_cmd.step);
    }

    {
        const server = b.addExecutable("showdown-server", "src/server/main.zig");
        server.addPackage(pkgs.network);
        server.setTarget(target);
        server.setBuildMode(mode);
        server.addBuildOption(u16, "default_port", default_port);
        server.install();

        const run_server_cmd = server.run();
        run_server_cmd.step.dependOn(b.getInstallStep());
        if (b.args) |args| {
            run_server_cmd.addArgs(args);
        }

        const run_server_step = b.step("run-server", "Run the app");
        run_server_step.dependOn(&run_server_cmd.step);
    }
}
