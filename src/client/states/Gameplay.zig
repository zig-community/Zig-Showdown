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
const Game = @import("../Game.zig");
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
    if (input.isHit(.back)) {
        Game.fromComponent(self).switchToState(.main_menu);
    }

    self.cam.rotation.x = std.math.clamp(
        self.cam.rotation.x - input.axis(.look_vertical),
        -0.45 * std.math.pi,
        0.45 * std.math.pi,
    );
    self.cam.rotation.y += input.axis(.look_horizontal);

    var camera_forward = draw.eulerAnglesToDirVector(self.cam.rotation);
    camera_forward.y = 0;
    var camera_right = draw.eulerAnglesToDirVector(draw.vector_math.Vec3.c(self.cam.rotation.x, self.cam.rotation.y - 3.1415926535 * 0.5, self.cam.rotation.z));
    camera_right.y = 0;

    const input_x = input.axis(.move_horizontal);
    const input_z = -input.axis(.move_vertical);

    camera_forward = draw.vector_math.Vec3_mul_F(camera_forward, input_z);
    camera_right = draw.vector_math.Vec3_mul_F(camera_right, input_x);

    var camera_delta_p = draw.vector_math.Vec3_add(camera_forward, camera_right);
    camera_delta_p = draw.vector_math.Vec3_normalize(camera_delta_p);
    camera_delta_p = draw.vector_math.Vec3_mul_F(camera_delta_p, 1.0 * delta_time);

    self.cam.pos = draw.vector_math.Vec3_add(self.cam.pos, camera_delta_p);
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
