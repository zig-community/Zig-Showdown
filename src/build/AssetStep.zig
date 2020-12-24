const std = @import("std");
const path = std.fs.path;
const Step = std.build.Step;
const Builder = std.build.Builder;
const LibExeObjStep = std.build.LibExeObjStep;
const PathRenderer = @import("PathRenderer.zig");

const Self = @This();

pub const Converters = struct {
    obj_conv: *LibExeObjStep,
    tex_conv: *LibExeObjStep,
    snd_conv: *LibExeObjStep,
};

step: Step,
builder: *Builder,
embed: bool,
converters: Converters,
package: std.build.Pkg,
resources_file_contents: std.ArrayList(u8),

pub fn create(builder: *Builder, embed: bool, converters: Converters) !*Self {
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
        .converters = converters,
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

    self.step.dependOn(&self.converters.obj_conv.step);
    self.step.dependOn(&self.converters.tex_conv.step);
    self.step.dependOn(&self.converters.snd_conv.step);

    return self;
}

pub fn addResources(self: *Self, root: []const u8) !void {
    var walker = try std.fs.walkPath(self.builder.allocator, root);
    defer walker.deinit();

    while (try walker.next()) |entry| {
        const ext = path.extension(entry.path);

        var new_ext: []const u8 = undefined;
        var converter: *std.build.LibExeObjStep = undefined;

        if (std.mem.eql(u8, ext, ".obj")) {
            converter = self.converters.obj_conv;
            new_ext = "mdl";
        } else if (std.mem.eql(u8, ext, ".png")
                or std.mem.eql(u8, ext, ".tga")
                or std.mem.eql(u8, ext, ".bmp")) {
            converter = self.converters.tex_conv;
            new_ext = "tex";
        } else if (std.mem.eql(u8, ext, ".wav")) {
            converter = self.converters.snd_conv;
            new_ext = "snd";
        } else {
            continue;
        }

        const relative_asset_path = entry.path[root.len + 1 ..];
        const relative_without_ext = relative_asset_path[0 .. relative_asset_path.len - ext.len];

        const output = try path.join(self.builder.allocator, &[_][]const u8{
            self.builder.build_root,
            self.builder.cache_root,
            "bin",
            "assets",
            try std.mem.concat(self.builder.allocator, u8, &[_][]const u8{
                relative_without_ext,
                ".",
                new_ext,
            }),
        });

        try std.fs.cwd().makePath(std.fs.path.dirname(output).?);

        const name_without_ext = if (std.builtin.os.tag == .windows) blk: {
                const new_path = try self.builder.allocator.dupe(u8, path);
                for (new_path) |*c| {
                    if (c.* == path.sep_windows)
                        c.* = path.sep_posix;
                }
                break :blk new_path;
            } else relative_without_ext;

        const name = try std.mem.concat(self.builder.allocator, u8, &[_][]const u8{
            "/",
            name_without_ext,
            ".",
            new_ext,
        });

        const run = converter.run();
        run.addArg(entry.path);
        run.addArg(output);
        run.addArg(name);

        var writer = self.resources_file_contents.writer();
        if (self.embed) {
            const pr = PathRenderer{.path = output};
            try writer.print(
                \\    .@"{}" = @alignCast(64, @embedFile("{}")),
                \\
                , .{ name, pr }
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
}

fn make(step: *Step) !void {
    const self = @fieldParentPtr(Self, "step", step);
    try self.resources_file_contents.writer().writeAll("};\n");
    const cwd = std.fs.cwd();
    try cwd.makePath(std.fs.path.dirname(self.package.path).?);
    try cwd.writeFile(self.package.path, self.resources_file_contents.items);
}
