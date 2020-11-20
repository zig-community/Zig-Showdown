//! This state contains the core gameplay.
//! Tasks:
//! - Render the world
//! - Process input into movement
//! - Do game logic
//! - Update network
//! - optional: Announce the game via UDP broadcast to LAN

const std = @import("std");
const zwl = @import("zwl");
const draw = @import("pixel_draw");

const Self = @This();
const Resources = @import("../game_resources.zig");

allocator: *std.mem.Allocator,
resources: *Resources,

z_buffer: []f32,

// Potato demo code
quad_mesh: draw.Mesh,
cube_mesh: draw.Mesh,
font: draw.BitmapFont,

cam: draw.Camera3D = .{
    .pos = .{ .z = 2.0 },
},

var cube_v = [_]draw.vector_math.Vertex{
    draw.vector_math.Vertex.c(draw.vector_math.Vec3.c(-0.5, 0.5, 0.5), draw.vector_math.Vec2.c(0, 1)),
    draw.vector_math.Vertex.c(draw.vector_math.Vec3.c(0.5, 0.5, 0.5), draw.vector_math.Vec2.c(1, 1)),
    draw.vector_math.Vertex.c(draw.vector_math.Vec3.c(-0.5, -0.5, 0.5), draw.vector_math.Vec2.c(0, 0)),
    draw.vector_math.Vertex.c(draw.vector_math.Vec3.c(0.5, -0.5, 0.5), draw.vector_math.Vec2.c(1, 0)),

    draw.vector_math.Vertex.c(draw.vector_math.Vec3.c(-0.5, 0.5, -0.5), draw.vector_math.Vec2.c(1, 1)),
    draw.vector_math.Vertex.c(draw.vector_math.Vec3.c(0.5, 0.5, -0.5), draw.vector_math.Vec2.c(0, 1)),
    draw.vector_math.Vertex.c(draw.vector_math.Vec3.c(-0.5, -0.5, -0.5), draw.vector_math.Vec2.c(1, 0)),
    draw.vector_math.Vertex.c(draw.vector_math.Vec3.c(0.5, -0.5, -0.5), draw.vector_math.Vec2.c(0, 0)),
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

pub fn init(allocator: *std.mem.Allocator, resources: *Resources) !Self {
    var self = Self{
        .allocator = allocator,
        .resources = resources,

        .z_buffer = undefined,

        .quad_mesh = undefined,
        .cube_mesh = undefined,
        .font = undefined,
    };

    self.z_buffer = try allocator.alloc(f32, 0);
    errdefer allocator.free(self.z_buffer);

    self.font = .{
        .texture = try draw.textureFromTgaData(
            self.allocator,
            @embedFile("../../../assets/font.tga"),
        ),
        .font_size_x = 12,
        .font_size_y = 16,
        .character_spacing = 11,
    };

    const bad_floor = resources.textures.get(
        resources.textures.getName("/assets/bad_floor.tga") catch unreachable,
        Resources.usage.generic_render,
    ) catch unreachable;

    self.cube_mesh = draw.Mesh{
        .v = &cube_v,
        .i = &cube_i,
        .texture = undefined,
    };
    self.cube_mesh.texture = resources.textures.get(
        resources.textures.getName("/assets/potato.tga") catch unreachable,
        Resources.usage.generic_render,
    ) catch unreachable;

    self.quad_mesh = draw.createQuadMesh(
        self.allocator,
        21,
        21,
        10.5,
        10.5,
        bad_floor,
        .Tile,
    );

    for (self.quad_mesh.v) |*v| {
        v.pos = draw.vector_math.rotateVectorOnX(v.pos, 3.1415926535 * 0.5);
        v.pos.y -= 0.5;
    }

    return self;
}

pub fn deinit(self: *Self) void {
    self.allocator.free(self.font.texture.raw);
    self.allocator.free(self.z_buffer);
    self.* = undefined;
}

pub fn update(self: *Self, total_time: f32, delta_time: f32) !void {
    // if (draw.keyPressed(.up)) cam.rotation.x += delta * 2;
    // if (draw.keyPressed(.down)) cam.rotation.x -= delta * 2;
    // if (draw.keyPressed(.right)) cam.rotation.y += delta * 2;
    // if (draw.keyPressed(.left)) cam.rotation.y -= delta * 2;

    // var camera_forward = eulerAnglesToDirVector(cam.rotation);
    // camera_forward.y = 0;
    // var camera_right = eulerAnglesToDirVector(Vec3.c(cam.rotation.x, cam.rotation.y - 3.1415926535 * 0.5, cam.rotation.z));
    // camera_right.y = 0;

    // const input_z = draw.keyStrengh(.s) - draw.keyStrengh(.w);
    // const input_x = draw.keyStrengh(.d) - draw.keyStrengh(.a);

    // camera_forward = Vec3_mul_F(camera_forward, input_z);
    // camera_right = Vec3_mul_F(camera_right, input_x);

    // var camera_delta_p = Vec3_add(camera_forward, camera_right);
    // camera_delta_p = Vec3_normalize(camera_delta_p);
    // camera_delta_p = Vec3_mul_F(camera_delta_p, delta * 3);

    // cam.pos = Vec3_add(camera_delta_p, cam.pos);
    self.cam.rotation.y += delta_time;
}

pub fn render(self: *Self, render_target: zwl.PixelBuffer, total_time: f32, delta_time: f32) !void {
    var b = draw.Buffer{
        .width = render_target.width,
        .height = render_target.height,
        .screen = std.mem.sliceAsBytes(render_target.span()),
        .depth = undefined, // oh no
    };
    if (self.z_buffer.len != b.screen.len) {
        self.z_buffer = try self.allocator.realloc(self.z_buffer, b.screen.len);
    }
    b.depth = self.z_buffer;

    // Clear the z-buffer
    std.mem.set(f32, self.z_buffer, std.math.inf(f32));

    b.fillScreenWithRGBColor(50, 100, 150);

    // NOTE(Samuel): Mesh Transformation

    b.drawMesh(self.quad_mesh, .Texture, self.cam);
    b.drawMesh(self.cube_mesh, .Texture, self.cam);
}
