const std = @import("std");
const vkgen = @import("deps/vulkan-zig/generator/index.zig");

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

    const zlm = std.build.Pkg{
        .name = "zlm",
        .path = "./deps/zlm/zlm.zig",
    };

    const wavefront_obj = std.build.Pkg{
        .name = "wavefront-obj",
        .path = "./deps/wavefront-obj/wavefront-obj.zig",
        .dependencies = &[_]std.build.Pkg{
            zlm,
        },
    };

    const zzz = std.build.Pkg{
        .name = "zzz",
        .path = "./deps/zzz/src/main.zig",
    };

    const gl = std.build.Pkg{
        .name = "gl",
        .path = "./deps/opengl/gl_3v3_with_exts.zig",
    };

    const resources = std.build.Pkg{
        .name = "showdown-resources",
        .path = "./zig-cache/resources.zig", // Written by this file
    };
};

const vk_xml_path = "deps/Vulkan-Docs/xml/vk.xml";

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
    demo_pause,
};

const RenderBackend = enum {
    /// basic software rendering
    software,

    /// high-performance desktop rendering
    vulkan,

    /// OpenGL based rendering backend
    opengl,

    /// basic rendering backend for mobile devices and embedded stuff like Raspberry PI
    opengl_es,

    /// raytracing backend planned by Snektron
    vulkan_rt,
};

fn addClientPackages(exe: *std.build.LibExeObjStep, target: std.zig.CrossTarget, render_backend: RenderBackend, gen_vk: *vkgen.VkGenerateStep) void {
    exe.addPackage(pkgs.network);
    exe.addPackage(pkgs.args);
    exe.addPackage(pkgs.zwl);
    exe.addPackage(pkgs.zlm);
    exe.addPackage(pkgs.zzz);
    exe.addPackage(pkgs.resources);

    switch (render_backend) {
        .vulkan, .vulkan_rt => {
            exe.step.dependOn(&gen_vk.step);
            exe.addPackage(gen_vk.package);
            exe.linkLibC();
        },
        .software => {
            exe.addPackage(pkgs.pixel_draw);
            exe.addPackage(pkgs.painterz);
        },
        .opengl_es => {
            // TODO
            @panic("opengl_es is not implementated yet");
        },
        .opengl => {
            exe.addPackage(pkgs.gl);
            if (target.isWindows()) {
                exe.linkSystemLibrary("opengl32");
            } else {
                exe.linkLibC();
                exe.linkSystemLibrary("X11");
                exe.linkSystemLibrary("GL");
            }
        },
    }
}

pub fn build(b: *std.build.Builder) !void {
    // workaround for windows not having visual studio installed
    // (makes .gnu the default target)
    const native_target = if (std.builtin.os.tag != .windows)
        std.zig.CrossTarget{}
    else
        std.zig.CrossTarget{ .abi = .gnu };

    const target = b.standardTargetOptions(.{
        .default_target = native_target,
    });
    const mode = b.standardReleaseOptions();

    const default_port = b.option(
        u16,
        "default-port",
        "The port the game will use as its default port",
    ) orelse 3315;
    const initial_state = b.option(
        State,
        "initial-state",
        "The initial state of the game. This is only relevant for debugging.",
    ) orelse .splash;
    const enable_frame_counter = b.option(
        bool,
        "enable-fps-counter",
        "Enables the FPS counter as an overlay.",
    ) orelse (mode == .Debug);
    const render_backend = b.option(
        RenderBackend,
        "renderer",
        "Selects the rendering backend which the game should use to render",
    ) orelse .software;
    const embed_resources = b.option(
        bool,
        "embed-resources",
        "When set, the resources will be embedded into the binary.",
    ) orelse false;

    if (target.isLinux() and !target.isGnuLibC() and (render_backend == .vulkan or render_backend == .opengl or render_backend == .opengl_es)) {
        @panic("OpenGL, Vulkan and OpenGL ES require linking against glibc, musl is not supported!");
    }

    const gen_vk = vkgen.VkGenerateStep.init(b, vk_xml_path, "vk.zig");

    {
        const obj_conv = b.addExecutable("obj-conv", "src/tools/obj-conv.zig");
        obj_conv.addPackage(pkgs.args);
        obj_conv.addPackage(pkgs.zlm);
        obj_conv.addPackage(pkgs.wavefront_obj);
        obj_conv.setTarget(native_target);
        obj_conv.setBuildMode(.ReleaseSafe); // this should run at least optimized

        const tex_conv = b.addExecutable("tex-conv", "src/tools/tex-conv.zig");
        tex_conv.addCSourceFile("src/tools/stb_image.c", &[_][]const u8{});
        tex_conv.addIncludeDir("deps/stb");
        tex_conv.addPackage(pkgs.args);
        tex_conv.setTarget(native_target);
        tex_conv.setBuildMode(.ReleaseSafe); // this should run at least optimized
        tex_conv.linkLibC();

        const tools_step = b.step("tools", "Compiles all tools required in the build process");
        tools_step.dependOn(&obj_conv.step);
        tools_step.dependOn(&tex_conv.step);

        const assets_step = b.step("assets", "Compiles all assets to their final format");

        // precompile all asset files:

        var resources_list = std.ArrayList(u8).init(b.allocator);
        {
            var writer = resources_list.writer();

            try writer.writeAll("// This is auto-generated code\n\n");

            try writer.print("pub const embedded = {};\n\n", .{embed_resources});

            try writer.writeAll("pub const files = .{\n");

            var walker = try std.fs.walkPath(b.allocator, "assets");
            defer walker.deinit();

            while (try walker.next()) |entry| {
                var extension: ?[]const u8 = null;

                if (std.mem.endsWith(u8, entry.path, ".obj")) {
                    const convert_file = obj_conv.run();
                    convert_file.addArg(entry.path);
                    assets_step.dependOn(&convert_file.step);
                    extension = "mdl";
                } else if (std.mem.endsWith(u8, entry.path, ".png") or std.mem.endsWith(u8, entry.path, ".tga") or std.mem.endsWith(u8, entry.path, ".bmp")) {
                    const convert_file = tex_conv.run();
                    convert_file.addArg(entry.path);
                    assets_step.dependOn(&convert_file.step);
                    extension = "tex";
                } else {
                    continue;
                }

                const file_without_ext = if (entry.path.len > 4)
                    if (std.builtin.os.tag == .windows) blk: {
                        const p = try b.allocator.dupe(u8, entry.path[0 .. entry.path.len - 4]);
                        for (p) |*c| {
                            if (c.* == '\\')
                                c.* = '/';
                        }
                        break :blk p;
                    } else entry.path[0 .. entry.path.len - 4]
                else
                    "";

                if (embed_resources) {
                    // files are in zig-cache/../assets
                    try writer.print("    .@\"/{}.{}\" = @embedFile(\"../{}.{}\"),\n", .{
                        file_without_ext, extension.?,
                        file_without_ext, extension.?,
                    });
                } else {
                    try writer.print("    .@\"/{}.{}\" = {{}},\n", .{ file_without_ext, extension.? });
                }
            }

            try writer.writeAll("};\n");
        }

        try std.fs.cwd().writeFile("zig-cache/resources.zig", resources_list.items);
    }

    {
        const client = b.addExecutable("showdown", "src/client/main.zig");
        addClientPackages(client, target, render_backend, gen_vk);

        client.addBuildOption(State, "initial_state", initial_state);
        client.addBuildOption(bool, "enable_frame_counter", enable_frame_counter);
        client.addBuildOption(u16, "default_port", default_port);
        client.addBuildOption(RenderBackend, "render_backend", render_backend);

        client.setTarget(target);
        client.setBuildMode(mode);

        if (mode != .Debug) {
            // TODO: Workaround for
            client.linkLibC();
            client.linkSystemLibrary("m");
        }

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

    {
        const test_client = b.addTest("src/client/main.zig");
        addClientPackages(test_client, target, render_backend, gen_vk);

        test_client.addBuildOption(State, "initial_state", initial_state);
        test_client.addBuildOption(bool, "enable_frame_counter", enable_frame_counter);
        test_client.addBuildOption(u16, "default_port", default_port);
        test_client.addBuildOption(RenderBackend, "render_backend", render_backend);

        test_client.setTarget(target);
        test_client.setBuildMode(mode);

        if (mode != .Debug) {
            // TODO: Workaround for
            test_client.linkLibC();
            test_client.linkSystemLibrary("m");
        }

        const test_server = b.addTest("src/server/main.zig");
        test_server.setTarget(target);
        test_server.setBuildMode(mode);

        const test_step = b.step("test", "Runs the test suite for both client and server implementation");
        test_step.dependOn(&test_client.step);
        test_step.dependOn(&test_server.step);
    }
}
