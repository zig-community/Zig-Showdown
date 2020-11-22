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
const Resources = @import("../Resources.zig");

allocator: *std.mem.Allocator,
resources: *Resources,

z_buffer: []f32,

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

        .z_buffer = undefined,

        .level_model_id = undefined,
    };

    self.z_buffer = try allocator.alloc(f32, 0);
    errdefer allocator.free(self.z_buffer);

    self.level_model_id = try self.resources.models.getName("/assets/maps/demo.mdl");

    return self;
}

pub fn deinit(self: *Self) void {
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

    const level_model = try self.resources.models.get(
        self.level_model_id,
        Resources.usage.level_render,
    );

    for (level_model.meshes) |mesh, ind| {
        const texture_id = try self.resources.textures.getName(mesh.texture()); // this is not optimal, but okayish
        const texture = try self.resources.textures.get(texture_id, Resources.usage.generic_render);

        // ugly workaround to draw meshes with pixel_draw:
        // converts between immutable data and mutable data
        var index: usize = 3 * mesh.offset;
        while (index < 3 * (mesh.offset + mesh.length)) : (index += 3) {
            var vertices: [3]draw.Vertex = undefined;
            for (vertices) |*dv, i| {
                const sv = level_model.vertices[level_model.indices[index + i]];
                dv.* = draw.Vertex{
                    .pos = .{
                        .x = sv.x,
                        .y = sv.y,
                        .z = sv.z,
                    },
                    .uv = .{
                        .x = sv.u,
                        .y = sv.v,
                    },
                };
            }
            var indices = [3]u32{ 0, 1, 2 };

            var temp_mesh = draw.Mesh{
                .v = &vertices,
                .i = &indices,
                .texture = texture.toPixelDraw(),
            };

            b.drawMesh(temp_mesh, .Texture, self.cam);
        }
    }
}
