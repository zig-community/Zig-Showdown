const std = @import("std");

pub const Entity = enum(u32) { _ };

const EntityData = packed struct {
    const Index = u16;
    const Generation = u16;

    index: Index,
    generation: Generation,
};

comptime {
    std.debug.assert(@bitSizeOf(Entity) == @bitSizeOf(EntityData));
}

fn hash_index(key: EntityData.Index) u32 {
    return key;
}
fn eql_index(a: EntityData.Index, b: EntityData.Index) bool {
    return a == b;
}

fn OptionalComponentSet(comptime C: type) type {
    return std.ArrayHashMap(EntityData.Index, C, hash_index, eql_index, false);
}

fn MandatoryComponentSet(comptime C: type) type {
    return std.ArrayList(C);
}

const EntityGenerationData = struct {
    generation: EntityData.Generation,
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
        free_entities: std.ArrayList(EntityData.Index),

        /// stores either array lists or maps per component
        components: ComponentsTuple,

        pub fn init(allocator: *std.mem.Allocator) !Self {
            var self = Self{
                .entity_data = std.ArrayList(EntityGenerationData).init(allocator),
                .free_entities = std.ArrayList(EntityData.Index).init(allocator),

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
            const index = @intCast(EntityData.Index, self.entity_data.items.len);

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
            const index = self.getEntityIndex(ent) orelse return;

            std.debug.assert(self.entity_data.items[index].is_alive);

            self.entity_data.items[index].generation += 1;
            self.entity_data.items[index].is_alive = false;

            inline for (component_config) |cfg, i| {
                if (cfg.mandatory) {
                    // undefine the component
                    self.components[i].items[index] = undefined;
                } else {
                    // remove the component
                    _ = self.components[i].remove(index);
                }
            }

            // we have ensured the capacity in createEntity() already
            self.free_entities.appendAssumeCapacity(index);
        }

        /// returns true if the entity is still alive.
        pub fn isAlive(self: Self, ent: Entity) bool {
            return (self.getEntityIndex(ent) != null);
        }

        /// returns the index for `ent` or `null` if the entity
        /// does not exist
        fn getEntityIndex(self: Self, ent: Entity) ?EntityData.Index {
            const data = @bitCast(EntityData, ent);

            if (data.index >= self.entity_data.items.len)
                return null;

            const stored_info = self.entity_data.items[data.index];
            if (!stored_info.is_alive)
                return null;
            if (stored_info.generation != data.generation)
                return null;
            return data.index;
        }

        /// Returns a pointer to the component `C` of `ent` or `null` if that
        /// component or entity does not exist.
        pub fn getComponent(self: *Self, ent: Entity, comptime C: type) ?*C {
            const index = self.getEntityIndex(ent) orelse return null;

            inline for (component_config) |cfg, i| {
                if (cfg.type == C) {
                    if (cfg.mandatory) {
                        return &self.components[i].items[index];
                    } else {
                        return if (self.components[i].getEntry(index)) |entry|
                            &entry.value
                        else
                            null;
                    }
                }
            }
            @compileError(@typeName(C) ++ " is not a component managed by this type.");
        }

        pub fn addComponent(self: *Self, ent: Entity, value: anytype) !void {
            const gop = try self.getOrAddComponent(ent, @TypeOf(value));
            if (gop.found_existing)
                return error.AlreadyExists;
            gop.component.* = value;
        }

        pub fn getOrAddComponent(self: *Self, ent: Entity, comptime C: type) !GetOrAddResult(C) {
            const index = self.getEntityIndex(ent) orelse return error.EntityNotFound;

            inline for (component_config) |cfg, i| {
                if (cfg.type == C) {
                    if (cfg.mandatory) {
                        return GetOrAddResult(C){
                            .found_existing = true,
                            .component = &self.components[i].items[index],
                        };
                    } else {
                        const gop = try self.components[i].getOrPut(index);
                        return GetOrAddResult(C){
                            .found_existing = gop.found_existing,
                            .component = &gop.entry.value,
                        };
                    }
                }
            }
            @compileError(@typeName(C) ++ " is not a component managed by this type.");
        }

        pub fn removeComponent(self: *Self, ent: Entity, comptime C: type) void {
            const index = self.getEntityIndex(ent) orelse return;
            inline for (component_config) |cfg, i| {
                if (cfg.type == C) {
                    if (cfg.mandatory) {
                        @compileError("Cannot remove mandatory component " ++ @typeName(C) ++ "!");
                    } else {
                        _ = self.components[i].remove(index);
                    }
                    return;
                }
            }
            @compileError(@typeName(C) ++ " is not a component managed by this type.");
        }
    };
}

pub fn GetOrAddResult(comptime C: type) type {
    return struct {
        found_existing: bool,
        component: *C,
    };
}

const TestComponent1 = struct {
    value: i32 = 0,
};

const TestComponent2 = struct {
    value: i32,
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

    std.testing.expect(ecs.getComponent(e1, TestComponent1) != null);
    std.testing.expect(ecs.getComponent(e2, TestComponent1) != null);

    std.testing.expect(ecs.getComponent(e1, TestComponent2) == null);
    std.testing.expect(ecs.getComponent(e2, TestComponent2) == null);

    try ecs.addComponent(e1, TestComponent2{
        .value = 10,
    });

    std.testing.expect(ecs.getComponent(e1, TestComponent2) != null);
    std.testing.expect(ecs.getComponent(e2, TestComponent2) == null);

    std.testing.expectEqual(true, (try ecs.getOrAddComponent(e1, TestComponent2)).found_existing);
    std.testing.expectEqual(false, (try ecs.getOrAddComponent(e2, TestComponent2)).found_existing);

    ecs.removeComponent(e1, TestComponent2);

    std.testing.expect(ecs.getComponent(e1, TestComponent2) == null);
    std.testing.expect(ecs.getComponent(e2, TestComponent2) != null);

    ecs.destroyEntity(e2);

    std.testing.expect(ecs.isAlive(e1));
    std.testing.expect(!ecs.isAlive(e2));

    std.testing.expect(ecs.getComponent(e1, TestComponent1) != null);
    std.testing.expect(ecs.getComponent(e2, TestComponent1) == null);

    std.testing.expect(ecs.getComponent(e1, TestComponent2) == null);
    std.testing.expect(ecs.getComponent(e2, TestComponent2) == null);
}
