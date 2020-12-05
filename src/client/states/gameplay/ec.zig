const std = @import("std");

pub const Entity = enum(u32) {
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

const EntityData = packed struct {
    index: u16,
    generation: u16,
};

const EntityGenerationData = struct {
    generation: u16,
    is_alive: bool,
};

pub const Component = struct {
    type: type,
    mandatory: bool,
};

pub fn Mandatory(comptime T: type) Component {
    return Component{ .type = T, .mandatory = true };
}

pub fn Optional(comptime T: type) Component {
    return Component{ .type = T, .mandatory = false };
}

/// Creates a new entity component management system.
/// This does not provide any logic to update components, but only
/// manages entity and component creation/deletion as well as the memory.
/// `component_config` is a anonymous list literal with either `Mandatory(T)` or
/// `Optional(T)` component lists.
pub fn ECS(comptime component_config: anytype) type {
    comptime var component_types: [component_config.len]type = undefined;
    inline for (component_config) |item, i| {
        component_types[i] = if (item.mandatory)
            MandatoryComponentSet(item.type)
        else
            OptionalComponentSet(item.type);
    }
    const ComponentsTuple = std.meta.Tuple(&component_types);

    return struct {
        const Self = @This();

        /// stores the current generation for a given entity index
        entity_data: std.ArrayList(EntityGenerationData),
        /// stores freed indices in entity_data
        free_entities: std.ArrayList(u16),

        /// stores either array lists or maps per component
        components: ComponentsTuple,

        pub fn init(allocator: *std.mem.Allocator) !Self {
            var self = Self{
                .entity_data = std.ArrayList(EntityGenerationData).init(allocator),
                .free_entities = std.ArrayList(u16).init(allocator),

                .components = undefined,
            };

            inline for (component_config) |cfg, i| {
                self.components[i] = if (cfg.mandatory)
                    MandatoryComponentSet(cfg.type).init(allocator)
                else
                    OptionalComponentSet(cfg.type).init(allocator);
            }

            return self;
        }

        pub fn deinit(self: *Self) void {
            inline for (component_config) |_, i| {
                self.components[i].deinit();
            }
            self.entity_data.deinit();
            self.free_entities.deinit();
            self.* = undefined;
        }

        /// Creates a new, unique entity handle
        pub fn createEntity(self: *Self) !Entity {
            if (self.free_entities.popOrNull()) |index| {
                self.entity_data.items[index].is_alive = true;
                return @intToEnum(Entity, @bitCast(u32, EntityData{
                    .index = index,
                    .generation = self.entity_data.items[index].generation,
                }));
            }
            const index = @intCast(u16, self.entity_data.items.len);

            // Make sure we have enough slots in the free list
            // so destroying the entity will never ever go OOM
            try self.free_entities.ensureCapacity(index + 1);

            // Create the new entity only after the free_entities list
            // is resized so we do not have to roll back that action
            try self.entity_data.append(EntityGenerationData{
                .generation = 0,
                .is_alive = true,
            });
            errdefer _ = self.entity_data.pop(); // remove the entity in case of error

            inline for (component_config) |cfg, i| {
                if (cfg.mandatory) {
                    // Default-initialize all mandatory components
                    try self.components[i].append(cfg.type{});
                }
            }

            return @intToEnum(Entity, @bitCast(u32, EntityData{
                .index = index,
                .generation = 0,
            }));
        }

        /// Destroys a previously created entity handle.
        pub fn destroyEntity(self: *Self, ent: Entity) void {
            const data = @bitCast(EntityData, ent);

            // check if the entity was already deleted
            if (!self.isAlive(ent))
                return;

            std.debug.assert(self.entity_data.items[data.index].is_alive);

            self.entity_data.items[data.index].generation += 1;
            self.entity_data.items[data.index].is_alive = false;

            inline for (component_config) |cfg, i| {
                if (cfg.mandatory) {
                    // undefine the component
                    self.components[i].items[data.index] = undefined;
                }
            }

            // we have ensured the capacity in createEntity() already
            self.free_entities.appendAssumeCapacity(data.index);
        }

        /// returns true if the entity is still alive.
        pub fn isAlive(self: Self, ent: Entity) bool {
            const data = @bitCast(EntityData, ent);

            if (data.index >= self.entity_data.items.len)
                return false;

            const stored_info = self.entity_data.items[data.index];

            return stored_info.is_alive and stored_info.generation == data.generation;
        }
    };
}

const TestComponent1 = struct {
    value: i32 = 0,
};

const TestComponent2 = struct {
    x: usize,
};

const TestECS = ECS(&[_]Component{
    Mandatory(TestComponent1),
    Optional(TestComponent2),
});

test "Entity Component System" {
    var ecs = try TestECS.init(std.testing.allocator);
    defer ecs.deinit();

    var e1 = try ecs.createEntity();
    var e2 = try ecs.createEntity();

    std.testing.expect(ecs.isAlive(e1));
    std.testing.expect(ecs.isAlive(e2));

    ecs.destroyEntity(e2);

    std.testing.expect(ecs.isAlive(e1));
    std.testing.expect(!ecs.isAlive(e2));
}
