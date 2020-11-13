const std = @import("std");
const vkgen = @import("./deps/vulkan-zig/generator/index.zig");

const pkgs = struct {
    const network = std.build.Pkg{
        .name = "network",
        .path = "./deps/zig-network/network.zig",
    };

    const args = std.build.Pkg{
        .name = "args",
        .path = "./deps/zig-args/args.zig",
    };
};

pub fn build(b: *std.build.Builder) !void {
    const target = b.standardTargetOptions(.{});
    const mode = b.standardReleaseOptions();

    const default_port = b.option(u16, "default-port", "The port the game will use as its default port") orelse 3315;
    const wayland = b.option(bool, "wayland", "Build the client for Wayland instead of X11 on Linux") orelse false;

    {
        const client = b.addExecutable("showdown", "src/client/main.zig");
        client.addPackage(pkgs.network);
        client.addPackage(pkgs.args);
        client.setTarget(target);
        client.setBuildMode(mode);

        const gen = vkgen.VkGenerateStep.init(b, "./deps/Vulkan-Headers/registry/vk.xml", "vk.zig");
        client.step.dependOn(&gen.step);
        client.addPackage(gen.package);

        switch (target.getOsTag()) {
            .windows => {
                client.linkSystemLibrary("vulkan-1");
            },
            .linux => {
                client.linkLibC();
                if( wayland ){
                    client.addBuildOption(bool, "wayland", true);
                    client.linkSystemLibrary("wayland-client");
                } else {
                    client.addBuildOption(bool, "wayland", false);
                    client.linkSystemLibrary("xcb");
                }
                client.linkSystemLibrary("vulkan");
            },
            else => return error.UnsupportedOS,
        }

        client.addBuildOption(u16, "default_port", default_port);
        client.install();

        const run_client_cmd = client.run();
        run_client_cmd.step.dependOn(b.getInstallStep());
        if (b.args) |args| {
            run_client_cmd.addArgs(args);
        }

        const run_client_step = b.step("run", "Run the client");
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

        const run_server_step = b.step("run-server", "Run the server");
        run_server_step.dependOn(&run_server_cmd.step);
    }
}
