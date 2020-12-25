const std = @import("std");
const vkgen = @import("../../deps/vulkan-zig/generator/index.zig");
const Step = std.build.Step;
const Builder = std.build.Builder;
const PathRenderer = @import("PathRenderer.zig");

const Self = @This();

step: Step,
shader_step: *vkgen.ShaderCompileStep,
builder: *Builder,
package: std.build.Pkg,
shaders: std.ArrayList(u8),

pub fn create(builder: *Builder, glslc_path: []const u8) !*Self {
    const self = try builder.allocator.create(Self);
    const full_out_path = try std.fs.path.join(builder.allocator, &[_][]const u8{
        builder.build_root,
        builder.cache_root,
        "shaders.zig",
    });

    self.* = .{
        .step = Step.init(.Custom, "vulkan-shaders", builder.allocator, make),
        .shader_step = vkgen.ShaderCompileStep.init(builder, &[_][]const u8{ glslc_path, "--target-env=vulkan1.2" }),
        .builder = builder,
        .package = .{
            .name = "showdown-vulkan-shaders",
            .path = full_out_path,
            .dependencies = null,
        },
        .shaders = std.ArrayList(u8).init(builder.allocator),
    };

    self.step.dependOn(&self.shader_step.step);
    return self;
}

pub fn addShader(self: *Self, name: []const u8, source: []const u8) void {
    const shader_out_path = self.shader_step.add(source);
    var writer = self.shaders.writer();
    const pr = PathRenderer{.path = shader_out_path};
    writer.print(
        \\pub const {} = @alignCast(64, @embedFile("{}"));
        \\
        , .{ name, pr }
    );
}

fn make(step: *Step) !void {
    const self = @fieldParentPtr(Self, "step", step);
    const cwd = std.fs.cwd();

    const dir = std.fs.path.dirname(self.package.path).?;
    try cwd.makePath(dir);
    try cwd.writeFile(self.package.path, self.shaders.items);
}
