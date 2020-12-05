const std = @import("std");
const zlm = @import("zlm");

const Resources = @import("../../Resources.zig");

/// mandatory component: position of each entity
pub const Transform = struct {
    position: zlm.Vec3 = zlm.vec3(0, 0, 0),
    rotation: zlm.Vec3 = zlm.vec3(0, 0, 0), // euler angles are bad, but good enough for this game :)
    scale: zlm.Vec3 = zlm.vec3(1, 1, 1),
};

/// optional component:
/// the entity is a light source in the form of a point light
pub const PointLight = struct {
    color: zlm.Vec3,
    range: f32,
};

/// optional component: Renders the model at the location of the entity.
pub const StaticGeometry = struct {
    model: Resources.ModelPool.ResourceName,
};

/// optional component:
pub const HealthPack = struct {
    health_points: u32 = 15
};

/// optional component:
pub const LocalPlayer = struct {};

/// optional component:
pub const NetworkPlayer = struct {};
