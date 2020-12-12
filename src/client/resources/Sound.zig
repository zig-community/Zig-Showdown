const std = @import("std");
const resource_pool = @import("../resource_pool.zig");
const Audio = @import("../Audio.zig");

const Self = @This();

samples: []const f32,

pub fn loadSoundFromMemory(audio: *Audio, allocator: *std.mem.Allocator, raw_data: resource_pool.BufferView, hint: []const u8) resource_pool.Error!Self {
    if (raw_data.len < 16)
        return error.InvalidData;
    // TODO: resample audio files to the sample rate of audio.outbuffer.sample_rate

    if (!std.mem.eql(u8, raw_data[0..4], "\xdf\x63\x6e\x28"))
        return error.InvalidData;
    const version = std.mem.readIntLittle(u32, raw_data[4..8]);
    if (version != 1)
        return error.InvalidData;

    const sample_count = std.mem.readIntLittle(u32, raw_data[8..12]);

    if ((raw_data.len - 0x10) < @sizeOf(f32) * sample_count)
        return error.InvalidData;

    return Self{
        .samples = std.mem.bytesAsSlice(f32, raw_data[16..][0 .. @sizeOf(f32) * sample_count]),
    };
}
pub fn freeSound(audio: *Audio, allocator: *std.mem.Allocator, self: *Self) void {
    // nop
}
