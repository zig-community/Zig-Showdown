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

const components = @import("gameplay/components.zig");

const Self = @This();
const Game = @import("../Game.zig");
const Resources = @import("../Resources.zig");
const Input = @import("../Input.zig");
const Renderer = @import("../Renderer.zig");
const Camera = @import("../Camera.zig");

const Entity = enum(u32) {
    _,

    fn hash(key: Entity) u32 {
        return @enumToInt(key);
    }
    fn eql(a: Entity, b: Entity) bool {
        return a == b;
    }
};

fn OptionalComponentSet(comptime C: type) type {
    return std.ArrayHashMap(Entity, C, Entity.hash, Entity.eql, false);
}

fn MandatoryComponentSet(comptime C: type) type {
    return std.ArrayList(C);
}

allocator: *std.mem.Allocator,
resources: *Resources,

level_model_id: Resources.ModelPool.ResourceName,
healthpack_id: Resources.ModelPool.ResourceName,

cam: Camera = .{
    .position = zlm.vec3(0.0, 0.5, 0.0),
    .euler = zlm.vec3(0, 0, 0),
},

/// stores the current generation for a given entity index
entity_generations: std.ArrayList(u16),
/// stores freed indices in entity_generations
free_entities: std.ArrayList(u16),

transforms: MandatoryComponentSet(components.Transform),
point_lights: OptionalComponentSet(components.PointLight),
static_geometries: OptionalComponentSet(components.StaticGeometry),
health_packs: OptionalComponentSet(components.HealthPack),
local_players: OptionalComponentSet(components.LocalPlayer),
network_players: OptionalComponentSet(components.NetworkPlayer),

pub fn init(allocator: *std.mem.Allocator, resources: *Resources) !Self {
    var self = Self{
        .allocator = allocator,
        .resources = resources,

        .level_model_id = try resources.models.getName("/assets/maps/demo.mdl"),
        .healthpack_id = try resources.models.getName("/assets/models/healthpack.mdl"),

        .entity_generations = std.ArrayList(u16).init(allocator),
        .free_entities = std.ArrayList(u16).init(allocator),
        .transforms = MandatoryComponentSet(components.Transform).init(allocator),
        .point_lights = OptionalComponentSet(components.PointLight).init(allocator),
        .static_geometries = OptionalComponentSet(components.StaticGeometry).init(allocator),
        .health_packs = OptionalComponentSet(components.HealthPack).init(allocator),
        .local_players = OptionalComponentSet(components.LocalPlayer).init(allocator),
        .network_players = OptionalComponentSet(components.NetworkPlayer).init(allocator),
    };

    return self;
}

pub fn deinit(self: *Self) void {
    self.entity_generations.deinit();
    self.free_entities.deinit();
    self.transforms.deinit();
    self.point_lights.deinit();
    self.static_geometries.deinit();
    self.health_packs.deinit();
    self.local_players.deinit();
    self.network_players.deinit();
    self.* = undefined;
}

const EntityData = packed struct {
    index: u16,
    generation: u16,
};

/// Creates a new, unique entity handle
fn createEntity(self: *Self) !Entity {
    if (self.free_entities.popOrNull()) |index| {
        return @bitCast(Entity, EntityData{
            .index = index,
            .generation = self.entity_generations.items[index],
        });
    }
    const index = @intCast(u16, self.entity_generations.items.len);

    try self.entity_generations.append(0);

    return @bitCast(Entity, EntityData{
        .index = index,
        .generation = 0,
    });
}

/// Destroys a previously created entity handle.
fn destroyEntity(self: *Self, ent: Entity) void {
    const data = @bitCast(EntityData, ent);

    // check if the entity was already deleted
    if (self.entity_generations.items[data.index] != data.generation)
        return;

    self.entity_generations.items[data.index] += 1;
    self.free_entities.append(data.index) catch |err| {
        // this operation is not critical when it fails, but
        // we should log it either.
        log.emerg("{} in Gameplay.destroyEntity", .{err});
    };
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

    {
        const pos = zlm.vec3(0, 0.2, 0);
        const rot = 0.3 * total_time;

        var transform = zlm.Mat4.createAngleAxis(zlm.Vec3.unitY, rot);
        transform = transform.mul(zlm.Mat4.createTranslation(pos));

        try pass.drawModel(healthpack_model, transform);
    }

    renderer.clear(render_target, Renderer.Color.fromRgb(0.2, 0.4, 0.6));
    try renderer.submit(render_target, pass);
}
