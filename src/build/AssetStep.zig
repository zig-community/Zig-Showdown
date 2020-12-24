const std = @import("std");
const path = std.fs.path;
const Step = std.build.Step;
const Builder = std.build.Builder;
const LibExeObjStep = std.build.LibExeObjStep;

const Self = @This();

step: Step,
builder: *Builder,
embed: bool,
package: std.build.Pkg,
resources_file_contents: std.ArrayList(u8),

pub fn create(builder: *Builder, embed: bool) !*Self {
    const self = try builder.allocator.create(Self);

    const resources_path = try path.join(builder.allocator, &[_][]const u8{
        builder.build_root,
        builder.cache_root,
        "resources.zig",
    });

    self.* = .{
        .step = Step.init(.Custom, "resources", builder.allocator, make),
        .builder = builder,
        .embed = embed,
        .package = .{
            .name = "showdown-resources",
            .path = resources_path,
        },
        .resources_file_contents = std.ArrayList(u8).init(builder.allocator),
    };

    try self.resources_file_contents.writer().print(
        \\// This is auto-generated code
        \\
        \\pub const embedded = {};
        \\
        \\pub const files = .{{
        \\
        , .{ embed }
    );

    return self;
}

pub fn addResource(self: *Self, converter: *LibExeObjStep, src: []const u8, name: []const u8) !void {
    const output_file = try path.join(self.builder.allocator, &[_][]const u8{
        self.builder.build_root,
        self.builder.cache_root,
        "resources",
        name,
    });

    try std.fs.cwd().makePath(std.fs.path.dirname(output_file).?);

    const run = converter.run();
    run.addArg(src);
    run.addArg(output_file);
    run.addArg(name);

    var writer = self.resources_file_contents.writer();
    if (self.embed) {
        try writer.print(
            \\    .@"{}" = @alignCast(64, @embedFile("{}")),
            \\
            , .{ name, output_file }
        );
    } else {
        try writer.print(
            \\    .@"{}" = {{}},
            \\
            , .{ name }
        );
    }

    self.step.dependOn(&run.step);
}

fn make(step: *Step) !void {
    const self = @fieldParentPtr(Self, "step", step);
    try self.resources_file_contents.writer().writeAll("};\n");
    const cwd = std.fs.cwd();
    try cwd.makePath(std.fs.path.dirname(self.package.path).?);
    try cwd.writeFile(self.package.path, self.resources_file_contents.items);
}
