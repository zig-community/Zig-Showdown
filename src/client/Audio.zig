const std = @import("std");
const log = std.log.scoped(.audio);

const c = @import("soundio");

const Self = @This();

allocator: *std.mem.Allocator,
soundio: *c.SoundIo,
outstream: *c.SoundIoOutStream,
device: *c.SoundIoDevice,

seconds_offset: f32 = 0.0,

fn writeCallback(outstream: *c.SoundIoOutStream, frame_count_min: c_int, frame_count_max: c_int) callconv(.C) void {
    const self = @ptrCast(*Self, @alignCast(@alignOf(Self), outstream.userdata));
    const layout = &outstream.layout;
    const float_sample_rate = @intToFloat(f32, outstream.sample_rate);
    const seconds_per_frame = 1.0 / float_sample_rate;
    var frames_left = frame_count_max;

    while (frames_left > 0) {
        var frame_count = frames_left;

        var areas: [*]c.SoundIoChannelArea = undefined;
        trySound(c.soundio_outstream_begin_write(outstream, &areas, &frame_count)) catch @panic("unexpected sound error");

        if (frame_count == 0)
            break;

        const pitch = 440.0;
        const radians_per_second = pitch * 2.0 * std.math.pi;
        var frame: c_int = 0;
        while (frame < frame_count) : (frame += 1) {
            const sample = std.math.sin((self.seconds_offset + @intToFloat(f32, frame) * seconds_per_frame) * radians_per_second);
            for (areas[0..@intCast(usize, layout.channel_count)]) |*chan| {
                @ptrCast(*align(1) f32, chan.ptr + @intCast(usize, chan.step * frame)).* = sample;
            }
        }
        self.seconds_offset = std.math.modf(self.seconds_offset + seconds_per_frame * @intToFloat(f32, frame_count)).fpart;

        trySound(c.soundio_outstream_end_write(outstream)) catch @panic("unexpected sound error");

        frames_left -= frame_count;
    }
}

fn trySound(err: c_int) !void {
    if (err == 0)
        return;

    log.err("{}", .{std.mem.span(c.soundio_strerror(err))});

    return switch (@intToEnum(c.SoundIoError, err)) {
        .None => unreachable,
        .NoMem => error.OutOfMemory,
        .InitAudioBackend => error.InitAudioBackend,
        .SystemResources => error.SystemResources,
        .OpeningDevice => error.OpeningDevice,
        .NoSuchDevice => error.NoSuchDevice,
        .Invalid => error.Invalid,
        .BackendUnavailable => error.BackendUnavailable,
        .Streaming => error.Streaming,
        .IncompatibleDevice => error.IncompatibleDevice,
        .NoSuchClient => error.NoSuchClient,
        .IncompatibleBackend => error.IncompatibleBackend,
        .BackendDisconnected => error.BackendDisconnected,
        .Interrupted => error.Interrupted,
        .Underflow => error.Underflow,
        .EncodingString => error.EncodingString,
        else => error.Unhandled,
    };
}

pub fn init(allocator: *std.mem.Allocator) !*Self {
    var soundio = c.soundio_create() orelse return error.OutOfMemory;
    errdefer c.soundio_destroy(soundio);

    try trySound(c.soundio_connect(soundio));

    c.soundio_flush_events(soundio);

    var default_out_device_index = c.soundio_default_output_device_index(soundio);
    if (default_out_device_index < 0)
        return error.NoSoundDevice;

    var device = c.soundio_get_output_device(soundio, default_out_device_index) orelse return error.OutOfMemory;
    errdefer c.soundio_device_unref(device);

    log.info("Output device: {}", .{std.mem.span(device.*.name)});

    var outstream = c.soundio_outstream_create(device) orelse return error.OutOfMemory;
    errdefer c.soundio_outstream_destroy(outstream);
    outstream.format = if (std.builtin.endian == .Little) c.SoundIoFormat.Float32LE else c.SoundIoFormat.Float32BE;
    outstream.write_callback = writeCallback;

    const self = try allocator.create(Self);
    errdefer allocator.destroy(self);

    self.* = Self{
        .allocator = allocator,
        .soundio = soundio,
        .outstream = outstream,
        .device = device,
    };

    outstream.userdata = self;

    try trySound(c.soundio_outstream_open(outstream));

    try trySound(outstream.layout_error);

    try trySound(c.soundio_outstream_start(outstream));

    return self;
}

pub fn update(self: *Self) !void {
    c.soundio_wait_events(self.soundio);
}

pub fn deinit(self: *Self) void {
    c.soundio_outstream_destroy(self.outstream);
    c.soundio_device_unref(self.device);
    c.soundio_destroy(self.soundio);
    self.allocator.destroy(self);
}
