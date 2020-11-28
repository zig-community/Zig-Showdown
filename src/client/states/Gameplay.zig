//! This state contains the core gameplay.
//! Tasks:
//! - Render the world
//! - Process input into movement
//! - Do game logic
//! - Update network
//! - optional: Announce the game via UDP broadcast to LAN

const std = @import("std");
const zlm = @import("zlm");

const Self = @This();
const Game = @import("../Game.zig");
const Resources = @import("../Resources.zig");
const Input = @import("../Input.zig");
const Renderer = @import("../Renderer.zig");
const Camera = @import("../Camera.zig");

allocator: *std.mem.Allocator,
resources: *Resources,

level_model_id: Resources.ModelPool.ResourceName,

cam: Camera = .{
    .position = zlm.vec3(0.0, 0.5, 0.0),
    .euler = zlm.vec3(0, 0, 0),
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

    self.cam.euler.x = std.math.clamp(
        self.cam.euler.x - input.axis(.look_vertical),
        -0.45 * std.math.pi,
        0.45 * std.math.pi,
    );
    self.cam.euler.y += input.axis(.look_horizontal);

    const camera_forward = self.cam.getForward();
    const camera_right = self.cam.getRight();

    const input_x = input.axis(.move_horizontal);
    const input_z = input.axis(.move_vertical);

    self.cam.position = self.cam.position.add(
        zlm.Vec3.add(
            camera_forward.scale(input_z),
            camera_right.scale(input_x),
        ).normalize().scale(1.0 * delta_time),
    );
}

pub fn render(self: *Self, renderer: *Renderer, render_target: Renderer.RenderTarget, total_time: f32, delta_time: f32) !void {
    var pass = Renderer.ScenePass.init(self.allocator);
    defer pass.deinit();

    // This is still horribly unelegant. Should be added to submit…
    pass.camera = self.cam;

    const level_model = try self.resources.models.get(
        self.level_model_id,
        Resources.usage.level_render,
    );

    // TODO: Replace .cam with an actual mat4
    try pass.drawModel(level_model, zlm.Mat4.identity);

    renderer.clear(render_target, Renderer.Color.fromRgb(0.2, 0.4, 0.6));
    try renderer.submit(render_target, pass);
}
