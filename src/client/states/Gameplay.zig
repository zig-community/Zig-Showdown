//! This state contains the core gameplay.
//! Tasks:
//! - Render the world
//! - Process input into movement
//! - Do game logic
//! - Update network
//! - optional: Announce the game via UDP broadcast to LAN

const std = @import("std");
const zlm = @import("zlm");
const log = std.log.scoped(.gameplay);

const entity_component_system = @import("gameplay/ec.zig");
const components = @import("gameplay/components.zig");

const Self = @This();
const Game = @import("../Game.zig");
const Resources = @import("../Resources.zig");
const Input = @import("../Input.zig");
const Renderer = @import("../Renderer.zig");
const Camera = @import("../Camera.zig");

const EntityManager = entity_component_system.ECS(&[_]entity_component_system.Component{
    entity_component_system.Mandatory(components.Transform),
    entity_component_system.Optional(components.PointLight),
    entity_component_system.Optional(components.StaticGeometry),
    entity_component_system.Optional(components.HealthPack),
    entity_component_system.Optional(components.LocalPlayer),
    entity_component_system.Optional(components.NetworkPlayer),
});

allocator: *std.mem.Allocator,
resources: *Resources,

level_model_id: Resources.ModelPool.ResourceName,
healthpack_id: Resources.ModelPool.ResourceName,

cam: Camera = .{
    .position = zlm.vec3(0.0, 0.5, 0.0),
    .euler = zlm.vec3(0, 0, 0),
},

entities: EntityManager,

pub fn init(allocator: *std.mem.Allocator, resources: *Resources) !Self {
    var self = Self{
        .allocator = allocator,
        .resources = resources,

        .level_model_id = try resources.models.getName("/assets/maps/demo.mdl"),
        .healthpack_id = try resources.models.getName("/assets/models/healthpack.mdl"),

        .entities = undefined,
    };

    self.entities = try EntityManager.init(allocator);
    errdefer self.entities.deinit();

    {
        var i: usize = 0;
        while (i < 5) : (i += 1) {
            const ent = try self.entities.createEntity();

            const transform = self.entities.getComponent(ent, components.Transform) orelse unreachable;

            transform.position.y = 0.2;
            transform.position.z = @intToFloat(f32, i) - 2.5;

            try self.entities.addComponent(ent, components.StaticGeometry{
                .model = self.healthpack_id,
            });

            try self.entities.addComponent(ent, components.HealthPack{});
        }
    }

    return self;
}

pub fn deinit(self: *Self) void {
    self.entities.deinit();
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

    const healthpack_model = try self.resources.models.get(
        self.healthpack_id,
        Resources.usage.level_render,
    );

    try pass.drawModel(level_model, zlm.Mat4.identity);

    // Rotate all healthpacks
    {
        var iter = self.entities.getComponents(components.HealthPack);
        while (iter.next()) |ec| {
            const trafo = self.entities.getComponent(ec.entity, components.Transform) orelse unreachable;
            trafo.rotation.y += 0.3 * delta_time;
        }
    }

    // Draw all static geometries
    {
        var iter = self.entities.getComponents(components.StaticGeometry);
        while (iter.next()) |ec| {
            const trafo = self.entities.getComponent(ec.entity, components.Transform) orelse unreachable;
            trafo.rotation.y += 0.3 * delta_time;

            var transform = zlm.Mat4.createScale(trafo.scale.x, trafo.scale.y, trafo.scale.z);
            transform = transform.mul(zlm.Mat4.createAngleAxis(zlm.Vec3.unitX, trafo.rotation.x));
            transform = transform.mul(zlm.Mat4.createAngleAxis(zlm.Vec3.unitZ, trafo.rotation.z));
            transform = transform.mul(zlm.Mat4.createAngleAxis(zlm.Vec3.unitY, trafo.rotation.y));
            transform = transform.mul(zlm.Mat4.createTranslation(trafo.position));

            const model = try self.resources.models.get(ec.component.model, Resources.usage.level_render);

            try pass.drawModel(model, transform);
        }
    }

    renderer.clear(render_target, Renderer.Color.fromRgb(0.2, 0.4, 0.6));
    try renderer.submit(render_target, pass);
}
