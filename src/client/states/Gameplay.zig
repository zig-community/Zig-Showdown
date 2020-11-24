//! This state contains the core gameplay.
//! Tasks:
//! - Render the world
//! - Process input into movement
//! - Do game logic
//! - Update network
//! - optional: Announce the game via UDP broadcast to LAN

const std = @import("std");
const draw = @import("pixel_draw");

const Self = @This();
const Resources = @import("../Resources.zig");
const Input = @import("../Input.zig");
const Renderer = @import("../Renderer.zig");

allocator: *std.mem.Allocator,
resources: *Resources,

level_model_id: Resources.ModelPool.ResourceName,

cam: draw.Camera3D = .{
    .pos = .{
        .x = 0.0,
        .y = 0.5,
        .z = 0.0,
    },
},

pub fn init(allocator: *std.mem.Allocator, resources: *Resources) !Self {
    var self = Self{
        .allocator = allocator,
        .resources = resources,

        .level_model_id = undefined,
    };

    self.level_model_id = try self.resources.models.getName("/assets/maps/demo.mdl");

    return self;
}

pub fn deinit(self: *Self) void {
    self.* = undefined;
}

pub fn update(self: *Self, input: Input, total_time: f32, delta_time: f32) !void {
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
    self.cam.rotation.y += 0.1 * delta_time;
    self.cam.pos.z -= 0.5 * delta_time;
    if (self.cam.pos.z <= -7.0)
        self.cam.pos.z += 14.0;
}

pub fn render(self: *Self, renderer: *Renderer, render_target: Renderer.RenderTarget, total_time: f32, delta_time: f32) !void {
    var pass = Renderer.ScenePass.init(self.allocator);
    defer pass.deinit();

    const level_model = try self.resources.models.get(
        self.level_model_id,
        Resources.usage.level_render,
    );

    // TODO: Replace .cam with an actual mat4
    try pass.drawModel(level_model, self.cam);

    renderer.clear(render_target, Renderer.Color.fromRgb(0.2, 0.4, 0.6));
    try renderer.submit(render_target, pass);
}
