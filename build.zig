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
        .path = "./deps/pixel_draw/src/pixel_draw.zig",
    };
};

pub fn build(b: *std.build.Builder) void {
    const target = b.standardTargetOptions(.{});
    const mode = b.standardReleaseOptions();

    const default_port = b.option(u16, "default-port", "The port the game will use as its default port") orelse 3315;

    {
        const client = b.addExecutable("showdown", "src/client/main.zig");
        client.addPackage(pkgs.network);
        client.addPackage(pkgs.args);
        client.addPackage(pkgs.pixel_draw);
        client.setTarget(target);
        client.setBuildMode(mode);

        // NOTE(Samuel): This is temporary
        if (@import("builtin").os.tag == .linux) {
            client.linkSystemLibrary("c");
            client.linkSystemLibrary("X11");
        }

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
