const std = @import("std");
const network = @import("network");
const args = @import("args");
const draw = @import("pixel_draw");
const zwl = @import("zwl");

const Game = @import("game.zig").Game;

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

const resources = struct {
    usingnamespace @import("resources.zig");

    const usage_generic_render = 0x01;

    var textures: ResourceManager(draw.Texture, loadTexture, freeTexture) = undefined;
};

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
        .track_damage = true,
        .visible = true,
    });
    defer window.deinit();

    resources.textures = @TypeOf(resources.textures).init(global_allocator);
    defer resources.textures.deinit();

    var game = try Game.init(global_allocator);
    defer game.deinit();

    main_loop: while (true) {
        const event = try platform.waitForEvent();

        switch (event) {
            .WindowResized => |win| {
                const size = win.getSize();
                std.log.debug("*notices size {}x{}* OwO what's this", .{ size[0], size[1] });
            },

            // someone closed the window, just stop the game:
            .WindowDestroyed, .ApplicationTerminated => break :main_loop,

            .WindowDamaged => |damage| {
                std.log.debug("Taking damage: {}x{} @ {}x{}", .{ damage.w, damage.h, damage.x, damage.y });

                const pixbuf = try window.mapPixels();
                game.render(pixbuf);
                try window.submitPixels();
            },
        }
    }

    // try draw.init(global_allocator, 800, 600, start, update);
    // end();

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

// Potato demo code
var quad_mesh: draw.Mesh = undefined;
var font: draw.BitmapFont = undefined;

fn loadTexture(allocator: *std.mem.Allocator, buffer: []const u8, hint: []const u8) resources.Error!draw.Texture {
    return draw.textureFromTgaData(allocator, buffer) catch |err| switch (err) {
        error.OutOfMemory => return error.OutOfMemory,
        else => return error.InvalidData,
    };
}
fn freeTexture(allocator: *std.mem.Allocator, self: *draw.Texture) void {
    allocator.free(self.raw);
    self.* = undefined;
}

fn start() void {
    font = .{
        .texture = draw.textureFromTgaData(global_allocator, @embedFile("../../assets/font.tga")) catch unreachable,
        .font_size_x = 12,
        .font_size_y = 16,
        .character_spacing = 11,
    };

    const bad_floor = resources.textures.get(
        resources.textures.getName("/assets/bad_floor.tga") catch unreachable,
        resources.usage_generic_render,
    ) catch unreachable;

    cube_mesh.texture = resources.textures.get(
        resources.textures.getName("/assets/potato.tga") catch unreachable,
        resources.usage_generic_render,
    ) catch unreachable;

    quad_mesh = draw.createQuadMesh(global_allocator, 21, 21, 10.5, 10.5, bad_floor, .Tile);

    for (quad_mesh.v) |*v| {
        v.pos = rotateVectorOnX(v.pos, 3.1415926535 * 0.5);
        v.pos.y -= 0.5;
    }
}

fn end() void {
    global_allocator.free(font.texture.raw);

    global_allocator.free(quad_mesh.v);
    global_allocator.free(quad_mesh.i);
}

var print_buff: [512]u8 = undefined;

var cube_v = [_]Vertex{
    Vertex.c(Vec3.c(-0.5, 0.5, 0.5), Color.c(0, 0, 0, 1), Vec2.c(0, 1)),
    Vertex.c(Vec3.c(0.5, 0.5, 0.5), Color.c(0, 0, 1, 1), Vec2.c(1, 1)),
    Vertex.c(Vec3.c(-0.5, -0.5, 0.5), Color.c(0, 1, 0, 1), Vec2.c(0, 0)),
    Vertex.c(Vec3.c(0.5, -0.5, 0.5), Color.c(0, 1, 1, 1), Vec2.c(1, 0)),

    Vertex.c(Vec3.c(-0.5, 0.5, -0.5), Color.c(1, 0, 0, 1), Vec2.c(1, 1)),
    Vertex.c(Vec3.c(0.5, 0.5, -0.5), Color.c(1, 0, 1, 1), Vec2.c(0, 1)),
    Vertex.c(Vec3.c(-0.5, -0.5, -0.5), Color.c(1, 1, 0, 1), Vec2.c(1, 0)),
    Vertex.c(Vec3.c(0.5, -0.5, -0.5), Color.c(1, 1, 1, 1), Vec2.c(0, 0)),
};

var cube_i = [_]u32{
    0, 2, 3,
    0, 3, 1,
    1, 3, 7,
    1, 7, 5,
    4, 0, 1,
    4, 1, 5,
    4, 6, 2,
    4, 2, 0,
    6, 3, 2,
    6, 7, 3,
    5, 7, 6,
    5, 6, 4,
};

var cube_mesh = draw.Mesh{
    .v = &cube_v,
    .i = &cube_i,
    .texture = undefined,
};

usingnamespace draw.vector_math;

fn update(delta: f32) void {
    draw.fillScreenWithRGBColor(50, 100, 150);

    // NOTE(Samuel): Mesh Transformation

    if (draw.keyPressed(.up)) cam.rotation.x += delta * 2;
    if (draw.keyPressed(.down)) cam.rotation.x -= delta * 2;
    if (draw.keyPressed(.right)) cam.rotation.y += delta * 2;
    if (draw.keyPressed(.left)) cam.rotation.y -= delta * 2;

    var camera_forward = eulerAnglesToDirVector(cam.rotation);
    camera_forward.y = 0;
    var camera_right = eulerAnglesToDirVector(Vec3.c(cam.rotation.x, cam.rotation.y - 3.1415926535 * 0.5, cam.rotation.z));
    camera_right.y = 0;

    const input_z = draw.keyStrengh(.s) - draw.keyStrengh(.w);
    const input_x = draw.keyStrengh(.d) - draw.keyStrengh(.a);

    camera_forward = Vec3_mul_F(camera_forward, input_z);
    camera_right = Vec3_mul_F(camera_right, input_x);

    var camera_delta_p = Vec3_add(camera_forward, camera_right);
    camera_delta_p = Vec3_normalize(camera_delta_p);
    camera_delta_p = Vec3_mul_F(camera_delta_p, delta * 3);

    cam.pos = Vec3_add(camera_delta_p, cam.pos);

    draw.drawMesh(quad_mesh, .Texture, cam);
    draw.drawMesh(cube_mesh, .Texture, cam);

    { // Show fps
        const fpst = std.fmt.bufPrint(&print_buff, "{d:0.4}/{d:0.4}", .{ 1 / delta, delta }) catch unreachable;
        draw.drawBitmapFont(fpst, 20, 20, 1, 1, font);
    }
}

var cam: draw.Camera3D = .{ .pos = .{ .z = 2.0 } };
