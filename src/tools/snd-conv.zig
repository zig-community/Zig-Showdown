//! This tool converts wave files into the projects own sound format
const std = @import("std");
const args = @import("args");

// read more:
// http://www-mmsp.ece.mcgill.ca/Documents/AudioFormats/WAVE/Docs/riffmci.pdf

var gpa = std.heap.GeneralPurposeAllocator(.{}){};
const allocator = &gpa.allocator;

const WaveFormat = struct {
    format_tag: u16,
    num_channels: u16,
    samples_per_sec: u32,
    avg_bytes_per_sec: u32,
    block_align: u16,
    bits_per_sample: ?u16,
};

pub fn main() !u8 {
    defer _ = gpa.deinit();

    var cli = try args.parseForCurrentProcess(struct {
        // nothing…
    }, allocator);
    defer cli.deinit();

    if (cli.positionals.len < 2)
        return 1;

    var out_file = cli.positionals[1];

    var src_data = try std.fs.cwd().readFileAlloc(allocator, cli.positionals[0], 1 << 30);
    defer allocator.free(src_data);

    // TODO: Load wave data here

    if (!std.mem.eql(u8, src_data[0..4], "RIFF"))
        return error.InvalidFormat;
    const file_size = std.mem.readIntLittle(u32, src_data[4..8]);
    if (!std.mem.eql(u8, src_data[8..12], "WAVE"))
        return error.InvalidFormat;

    var maybe_fmt: ?WaveFormat = null;
    var maybe_pcm_data: ?[]const u8 = null;

    {
        var offset: usize = 12;
        while (offset < src_data.len) {
            const sig = src_data[offset..][0..4];
            const chunk_size = std.mem.readIntLittle(u32, src_data[offset..][4..8]);

            offset += 8;
            defer offset += chunk_size;

            const buffer = src_data[offset..][0..chunk_size];

            var in_stream = std.io.fixedBufferStream(buffer).reader();

            if (std.mem.eql(u8, sig, "fmt ")) {
                // read format
                var fmt = WaveFormat{
                    .format_tag = undefined,
                    .num_channels = undefined,
                    .samples_per_sec = undefined,
                    .avg_bytes_per_sec = undefined,
                    .block_align = undefined,
                    .bits_per_sample = null,
                };

                fmt.format_tag = try in_stream.readIntLittle(u16);
                fmt.num_channels = try in_stream.readIntLittle(u16);
                fmt.samples_per_sec = try in_stream.readIntLittle(u32);
                fmt.avg_bytes_per_sec = try in_stream.readIntLittle(u32);
                fmt.block_align = try in_stream.readIntLittle(u16);

                switch (fmt.format_tag) {
                    1 => { // PCM
                        fmt.bits_per_sample = try in_stream.readIntLittle(u16);
                    },
                    else => return error.UnsupportedFormat,
                }
                maybe_fmt = fmt;
            } else if (std.mem.eql(u8, sig, "data")) {
                if (maybe_pcm_data != null)
                    return error.InvalidFormat;
                maybe_pcm_data = buffer;
            } else {
                std.log.warn("unknown WAVE chunk: '{}'", .{sig});
            }
        }
    }

    const fmt = maybe_fmt orelse return error.MissingData;
    const input_pcm_data = maybe_pcm_data orelse return error.MissingData;

    if (!std.math.isPowerOfTwo(fmt.bits_per_sample.?))
        return error.UnsupportedFormat;

    const block_align = fmt.block_align;
    // const block_align = fmt.num_channels * ((fmt.bits_per_sample.? + 7) / 8);

    const num_samples = input_pcm_data.len / block_align;
    const sample_size = @divExact(fmt.bits_per_sample.?, 8);

    const out_pcm_data = try allocator.alloc(f32, num_samples);
    defer allocator.free(out_pcm_data);

    for (out_pcm_data) |*out, i| {
        var sum: f32 = 0.0;

        var chan: usize = 0;
        var offset = block_align * i;
        while (chan < fmt.num_channels) : (chan += 1) {
            const binary_sample = input_pcm_data[offset..];
            offset += sample_size;

            const sample: f32 = switch (fmt.bits_per_sample.?) {
                8 => 2.0 * @intToFloat(f32, std.mem.readIntLittle(u8, binary_sample[0..1])) / 255.0 - 1.0,
                16 => @intToFloat(f32, std.mem.readIntLittle(i16, binary_sample[0..2])) / std.math.maxInt(i16),
                32 => @intToFloat(f32, std.mem.readIntLittle(i32, binary_sample[0..4])) / std.math.maxInt(i32),

                else => @panic("TODO: Implement more PCM formats"),
            };

            sum += std.math.clamp(sample, -1.0, 1.0);
        }

        out.* = sum;
    }

    var snd_file = try std.fs.cwd().createFile(out_file, .{});
    defer snd_file.close();

    var stream = snd_file.outStream();

    // CHANGES IN HERE MUST BE REFLECTED IN
    // src/client/resources/Sound.zig

    try stream.writeAll("\xdf\x63\x6e\x28"); // 0x00: header/identification
    try stream.writeIntLittle(u32, 0x01); // 0x04: version
    try stream.writeIntLittle(u32, @intCast(u32, out_pcm_data.len)); // 0x08: number of samples
    try stream.writeIntLittle(u32, 0x00); // 0x0C: padding

    try stream.writeAll(std.mem.sliceAsBytes(out_pcm_data)); // 0x10: Mono PCM data

    return 0;
}
