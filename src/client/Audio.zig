const std = @import("std");
const log = std.log.scoped(.audio);

const soundio = @import("soundio");

const Self = @This();

allocator: *std.mem.Allocator,
interface: *soundio.SoundIo,
outstream: *soundio.OutStream,
device: *soundio.Device,

seconds_offset: f32 = 0.0,

fn writeCallback(outstream: *soundio.OutStream, frame_count_min: c_int, frame_count_max: c_int) callconv(.C) void {
    const self = @ptrCast(*Self, @alignCast(@alignOf(Self), outstream.userdata));
    const layout = &outstream.layout;
    const float_sample_rate = @intToFloat(f32, outstream.sample_rate);
    const seconds_per_frame = 1.0 / float_sample_rate;
    var frames_left = frame_count_max;

    while (frames_left > 0) {
        var frame_count = frames_left;

        var areas: [*]soundio.ChannelArea = undefined;
        trySound(outstream.beginWrite(&areas, &frame_count)) catch @panic("unexpected sound error");

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

        trySound(outstream.endWrite()) catch @panic("unexpected sound error");

        frames_left -= frame_count;
    }
}

fn trySound(err: c_int) !void {
    if (err == 0)
        return;

    log.err("{}", .{std.mem.span(soundio.soundio_strerror(err))});

    return switch (@intToEnum(soundio.Error, err)) {
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
    var interface = soundio.SoundIo.create() orelse return error.OutOfMemory;
    errdefer interface.destroy();

    try trySound(interface.connect());

    interface.flushEvents();

    var default_out_device_index = interface.defaultOutputDeviceIndex();
    if (default_out_device_index < 0)
        return error.NoSoundDevice;

    var device = interface.getOutputDevice(default_out_device_index) orelse return error.OutOfMemory;
    errdefer device.unref();

    log.info("Output device: {}", .{std.mem.span(device.*.name)});

    var outstream = soundio.OutStream.create(device) orelse return error.OutOfMemory;
    errdefer outstream.destroy();
    outstream.format = if (std.builtin.endian == .Little) soundio.Format.Float32LE else soundio.Format.Float32BE;
    outstream.write_callback = writeCallback;

    const self = try allocator.create(Self);
    errdefer allocator.destroy(self);

    self.* = Self{
        .allocator = allocator,
        .interface = interface,
        .outstream = outstream,
        .device = device,
    };

    outstream.userdata = self;

    try trySound(outstream.open());

    try trySound(outstream.layout_error);

    try trySound(outstream.start());

    return self;
}

pub fn update(self: *Self) !void {
    self.interface.waitEvents();
}

pub fn deinit(self: *Self) void {
    self.outstream.destroy();
    self.device.unref();
    self.interface.destroy();
    self.allocator.destroy(self);
}
