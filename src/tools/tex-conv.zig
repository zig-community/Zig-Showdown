//! This tool converts Wavefront OBJ to the projects own model format
const std = @import("std");
const args = @import("args");
const zigimg = @import("zigimg");

var gpa = std.heap.GeneralPurposeAllocator(.{}){};
const allocator = &gpa.allocator;

pub fn main() !u8 {
    defer _ = gpa.deinit();

    var cli = try args.parseForCurrentProcess(struct {
        // nothing…
    }, allocator);
    defer cli.deinit();

    if (cli.positionals.len != 1)
        return 1;

    var out_file = try allocator.dupe(u8, cli.positionals[0]);
    out_file[out_file.len - 4 ..][0..4].* = ".tex".*;
    defer allocator.free(out_file);

    var src_data = try std.fs.cwd().readFileAlloc(allocator, cli.positionals[0], 1 << 30);
    defer allocator.free(src_data);

    // load data:
    const image = try zigimg.Image.fromMemory(allocator, src_data[0..]);
    defer image.deinit();

    var tex_file = try std.fs.cwd().createFile(out_file, .{});
    defer tex_file.close();

    var stream = tex_file.outStream();

    // design goal for the file format:
    // - in-memory representation is the file content
    // - make it easily memory-mappable

    // CHANGES IN HERE MUST BE REFLECTED IN
    // src/client/resources/Texture.zig

    try stream.writeAll("\x99\x5b\x12\x99"); // 0x00: header/identification
    try stream.writeIntLittle(u32, 0x01); // 0x04: version

    try stream.writeIntLittle(u16, @intCast(u16, image.width)); // 0x08: width
    try stream.writeIntLittle(u16, @intCast(u16, image.height)); // 0x0A: width

    try stream.writeIntLittle(u32, 0x00); // 0x0C: padding

    // 0x10: data, ([R,G,B,A]*width)*height
    var color_it = image.iterator();
    while (color_it.next()) |current_color| {
        const integer_color = current_color.toIntegerColor8();

        const value: u32 = integer_color.R | (@intCast(u32, integer_color.G) << 8) | (@intCast(u32, integer_color.B) << 16) | (@intCast(u32, integer_color.A) << 24);
        try stream.writeIntLittle(u32, value);
    }

    return 0;
}
