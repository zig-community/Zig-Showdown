pub const SoundIoError = extern enum(c_int) {
    None,
    NoMem,
    InitAudioBackend,
    SystemResources,
    OpeningDevice,
    NoSuchDevice,
    Invalid,
    BackendUnavailable,
    Streaming,
    IncompatibleDevice,
    NoSuchClient,
    IncompatibleBackend,
    BackendDisconnected,
    Interrupted,
    Underflow,
    EncodingString,
    _,
};

pub const SoundIoChannelId = extern enum(c_int) {
    Invalid,
    FrontLeft,
    FrontRight,
    FrontCenter,
    Lfe,
    BackLeft,
    BackRight,
    FrontLeftCenter,
    FrontRightCenter,
    BackCenter,
    SideLeft,
    SideRight,
    TopCenter,
    TopFrontLeft,
    TopFrontCenter,
    TopFrontRight,
    TopBackLeft,
    TopBackCenter,
    TopBackRight,
    BackLeftCenter,
    BackRightCenter,
    FrontLeftWide,
    FrontRightWide,
    FrontLeftHigh,
    FrontCenterHigh,
    FrontRightHigh,
    TopFrontLeftCenter,
    TopFrontRightCenter,
    TopSideLeft,
    TopSideRight,
    LeftLfe,
    RightLfe,
    Lfe2,
    BottomCenter,
    BottomLeftCenter,
    BottomRightCenter,
    MsMid,
    MsSide,
    AmbisonicW,
    AmbisonicX,
    AmbisonicY,
    AmbisonicZ,
    XyX,
    XyY,
    HeadphonesLeft,
    HeadphonesRight,
    ClickTrack,
    ForeignLanguage,
    HearingImpaired,
    Narration,
    Haptic,
    DialogCentricMix,
    Aux,
    Aux0,
    Aux1,
    Aux2,
    Aux3,
    Aux4,
    Aux5,
    Aux6,
    Aux7,
    Aux8,
    Aux9,
    Aux10,
    Aux11,
    Aux12,
    Aux13,
    Aux14,
    Aux15,
    _,
};
pub const SoundIoChannelLayoutId = extern enum(c_int) {
    Mono,
    Stereo,
    @"2Point1",
    @"3Point0",
    @"3Point0Back",
    @"3Point1",
    @"4Point0",
    Quad,
    QuadSide,
    @"4Point1",
    @"5Point0Back",
    @"5Point0Side",
    @"5Point1",
    @"5Point1Back",
    @"6Point0Side",
    @"6Point0Front",
    Hexagonal,
    @"6Point1",
    @"6Point1Back",
    @"6Point1Front",
    @"7Point0",
    @"7Point0Front",
    @"7Point1",
    @"7Point1Wide",
    @"7Point1WideBack",
    Octagonal,
    _,
};
pub const SoundIoBackend = extern enum(c_int) {
    None,
    Jack,
    PulseAudio,
    Alsa,
    CoreAudio,
    Wasapi,
    Dummy,
    _,
};
pub const SoundIoDeviceAim = extern enum(c_int) {
    Input,
    Output,
    _,
};
pub const SoundIoFormat = extern enum(c_int) {
    Invalid,
    S8,
    U8,
    S16LE,
    S16BE,
    U16LE,
    U16BE,
    S24LE,
    S24BE,
    U24LE,
    U24BE,
    S32LE,
    S32BE,
    U32LE,
    U32BE,
    Float32LE,
    Float32BE,
    Float64LE,
    Float64BE,
    _,
};
pub const SoundIoChannelLayout = extern struct {
    name: [*:0]const u8,
    channel_count: c_int,
    channels: [24]SoundIoChannelId,
};
pub const SoundIoSampleRateRange = extern struct {
    min: c_int,
    max: c_int,
};
pub const SoundIoChannelArea = extern struct {
    ptr: [*]u8,
    step: c_int,
};
pub const SoundIo = extern struct {
    userdata: ?*c_void,
    on_devices_change: ?fn (*SoundIo) callconv(.C) void,
    on_backend_disconnect: ?fn (*SoundIo, c_int) callconv(.C) void,
    on_events_signal: ?fn (*SoundIo) callconv(.C) void,
    current_backend: SoundIoBackend,
    app_name: [*:0]const u8,
    emit_rtprio_warning: ?fn () callconv(.C) void,
    jack_info_callback: ?fn ([*c]const u8) callconv(.C) void,
    jack_error_callback: ?fn ([*c]const u8) callconv(.C) void,
};
pub const SoundIoDevice = extern struct {
    soundio: *SoundIo,
    id: [*:0]u8,
    name: [*:0]u8,
    aim: SoundIoDeviceAim,
    layouts: [*]SoundIoChannelLayout,
    layout_count: c_int,
    current_layout: SoundIoChannelLayout,
    formats: [*]SoundIoFormat,
    format_count: c_int,
    current_format: SoundIoFormat,
    sample_rates: [*]SoundIoSampleRateRange,
    sample_rate_count: c_int,
    sample_rate_current: c_int,
    software_latency_min: f64,
    software_latency_max: f64,
    software_latency_current: f64,
    is_raw: bool,
    ref_count: c_int,
    probe_error: c_int,
};
pub const SoundIoOutStream = extern struct {
    device: *SoundIoDevice,
    format: SoundIoFormat,
    sample_rate: c_int,
    layout: SoundIoChannelLayout,
    software_latency: f64,
    volume: f32,
    userdata: ?*c_void,
    write_callback: ?fn (*SoundIoOutStream, c_int, c_int) callconv(.C) void,
    underflow_callback: ?fn (*SoundIoOutStream) callconv(.C) void,
    error_callback: ?fn (*SoundIoOutStream, c_int) callconv(.C) void,
    name: [*:0]const u8,
    non_terminal_hint: bool,
    bytes_per_frame: c_int,
    bytes_per_sample: c_int,
    layout_error: c_int,
};
pub const SoundIoInStream = extern struct {
    device: *SoundIoDevice,
    format: SoundIoFormat,
    sample_rate: c_int,
    layout: SoundIoChannelLayout,
    software_latency: f64,
    userdata: ?*c_void,
    read_callback: ?fn (*SoundIoInStream, c_int, c_int) callconv(.C) void,
    overflow_callback: ?fn (*SoundIoInStream) callconv(.C) void,
    error_callback: ?fn (*SoundIoInStream, c_int) callconv(.C) void,
    name: [*:0]const u8,
    non_terminal_hint: bool,
    bytes_per_frame: c_int,
    bytes_per_sample: c_int,
    layout_error: c_int,
};
pub extern fn soundio_version_string() [*:0]const u8;
pub extern fn soundio_version_major() c_int;
pub extern fn soundio_version_minor() c_int;
pub extern fn soundio_version_patch() c_int;
pub extern fn soundio_create() ?*SoundIo;
pub extern fn soundio_destroy(soundio: *SoundIo) void;
pub extern fn soundio_connect(soundio: *SoundIo) c_int;
pub extern fn soundio_connect_backend(soundio: *SoundIo, backend: SoundIoBackend) c_int;
pub extern fn soundio_disconnect(soundio: *SoundIo) void;
pub extern fn soundio_strerror(@"error": c_int) [*:0]const u8;
pub extern fn soundio_backend_name(backend: SoundIoBackend) [*:0]const u8;
pub extern fn soundio_backend_count(soundio: *SoundIo) c_int;
pub extern fn soundio_get_backend(soundio: *SoundIo, index: c_int) SoundIoBackend;
pub extern fn soundio_have_backend(backend: SoundIoBackend) bool;
pub extern fn soundio_flush_events(soundio: *SoundIo) void;
pub extern fn soundio_wait_events(soundio: *SoundIo) void;
pub extern fn soundio_wakeup(soundio: *SoundIo) void;
pub extern fn soundio_force_device_scan(soundio: *SoundIo) void;
pub extern fn soundio_channel_layout_equal(a: *const SoundIoChannelLayout, b: *const SoundIoChannelLayout) bool;
pub extern fn soundio_get_channel_name(id: SoundIoChannelId) [*:0]const u8;
pub extern fn soundio_parse_channel_id(str: [*:0]const u8, str_len: c_int) SoundIoChannelId;
pub extern fn soundio_channel_layout_builtin_count() c_int;
pub extern fn soundio_channel_layout_get_builtin(index: c_int) ?*const SoundIoChannelLayout;
pub extern fn soundio_channel_layout_get_default(channel_count: c_int) ?*const SoundIoChannelLayout;
pub extern fn soundio_channel_layout_find_channel(layout: *const SoundIoChannelLayout, channel: SoundIoChannelId) c_int;
pub extern fn soundio_channel_layout_detect_builtin(layout: *SoundIoChannelLayout) bool;
pub extern fn soundio_best_matching_channel_layout(preferred_layouts: [*]const SoundIoChannelLayout, preferred_layout_count: c_int, available_layouts: [*]const SoundIoChannelLayout, available_layout_count: c_int) ?*const SoundIoChannelLayout;
pub extern fn soundio_sort_channel_layouts(layouts: [*]SoundIoChannelLayout, layout_count: c_int) void;
pub extern fn soundio_get_bytes_per_sample(format: SoundIoFormat) c_int;
pub fn soundio_get_bytes_per_frame(arg_format: SoundIoFormat, arg_channel_count: c_int) callconv(.C) c_int {
    var format = arg_format;
    var channel_count = arg_channel_count;
    return (soundio_get_bytes_per_sample(format) * channel_count);
}
pub fn soundio_get_bytes_per_second(arg_format: SoundIoFormat, arg_channel_count: c_int, arg_sample_rate: c_int) callconv(.C) c_int {
    var format = arg_format;
    var channel_count = arg_channel_count;
    var sample_rate = arg_sample_rate;
    return (soundio_get_bytes_per_frame(format, channel_count) * sample_rate);
}
pub extern fn soundio_format_string(format: SoundIoFormat) [*:0]const u8;
pub extern fn soundio_input_device_count(soundio: *SoundIo) c_int;
pub extern fn soundio_output_device_count(soundio: *SoundIo) c_int;
pub extern fn soundio_get_input_device(soundio: *SoundIo, index: c_int) ?*SoundIoDevice;
pub extern fn soundio_get_output_device(soundio: *SoundIo, index: c_int) ?*SoundIoDevice;
pub extern fn soundio_default_input_device_index(soundio: *SoundIo) c_int;
pub extern fn soundio_default_output_device_index(soundio: *SoundIo) c_int;
pub extern fn soundio_device_ref(device: *SoundIoDevice) void;
pub extern fn soundio_device_unref(device: *SoundIoDevice) void;
pub extern fn soundio_device_equal(a: *const SoundIoDevice, b: *const SoundIoDevice) bool;
pub extern fn soundio_device_sort_channel_layouts(device: *SoundIoDevice) void;
pub extern fn soundio_device_supports_format(device: *SoundIoDevice, format: SoundIoFormat) bool;
pub extern fn soundio_device_supports_layout(device: *SoundIoDevice, layout: *const SoundIoChannelLayout) bool;
pub extern fn soundio_device_supports_sample_rate(device: *SoundIoDevice, sample_rate: c_int) bool;
pub extern fn soundio_device_nearest_sample_rate(device: *SoundIoDevice, sample_rate: c_int) c_int;
pub extern fn soundio_outstream_create(device: *SoundIoDevice) ?*SoundIoOutStream;
pub extern fn soundio_outstream_destroy(outstream: *SoundIoOutStream) void;
pub extern fn soundio_outstream_open(outstream: *SoundIoOutStream) c_int;
pub extern fn soundio_outstream_start(outstream: *SoundIoOutStream) c_int;
pub extern fn soundio_outstream_begin_write(outstream: *SoundIoOutStream, areas: *[*]SoundIoChannelArea, frame_count: *c_int) c_int;
pub extern fn soundio_outstream_end_write(outstream: *SoundIoOutStream) c_int;
pub extern fn soundio_outstream_clear_buffer(outstream: *SoundIoOutStream) c_int;
pub extern fn soundio_outstream_pause(outstream: *SoundIoOutStream, pause: bool) c_int;
pub extern fn soundio_outstream_get_latency(outstream: *SoundIoOutStream, out_latency: *f64) c_int;
pub extern fn soundio_outstream_set_volume(outstream: *SoundIoOutStream, volume: f64) c_int;
pub extern fn soundio_instream_create(device: *SoundIoDevice) ?*SoundIoInStream;
pub extern fn soundio_instream_destroy(instream: *SoundIoInStream) void;
pub extern fn soundio_instream_open(instream: *SoundIoInStream) c_int;
pub extern fn soundio_instream_start(instream: *SoundIoInStream) c_int;
pub extern fn soundio_instream_begin_read(instream: *SoundIoInStream, areas: *[*]SoundIoChannelArea, frame_count: *c_int) c_int;
pub extern fn soundio_instream_end_read(instream: *SoundIoInStream) c_int;
pub extern fn soundio_instream_pause(instream: *SoundIoInStream, pause: bool) c_int;
pub extern fn soundio_instream_get_latency(instream: *SoundIoInStream, out_latency: *f64) c_int;
pub const SoundIoRingBuffer = opaque {};
pub extern fn soundio_ring_buffer_create(soundio: *SoundIo, requested_capacity: c_int) ?*SoundIoRingBuffer;
pub extern fn soundio_ring_buffer_destroy(ring_buffer: ?*SoundIoRingBuffer) void;
pub extern fn soundio_ring_buffer_capacity(ring_buffer: ?*SoundIoRingBuffer) c_int;
pub extern fn soundio_ring_buffer_write_ptr(ring_buffer: ?*SoundIoRingBuffer) ?[*]u8;
pub extern fn soundio_ring_buffer_advance_write_ptr(ring_buffer: ?*SoundIoRingBuffer, count: c_int) void;
pub extern fn soundio_ring_buffer_read_ptr(ring_buffer: ?*SoundIoRingBuffer) ?[*]u8;
pub extern fn soundio_ring_buffer_advance_read_ptr(ring_buffer: ?*SoundIoRingBuffer, count: c_int) void;
pub extern fn soundio_ring_buffer_fill_count(ring_buffer: ?*SoundIoRingBuffer) c_int;
pub extern fn soundio_ring_buffer_free_count(ring_buffer: ?*SoundIoRingBuffer) c_int;
pub extern fn soundio_ring_buffer_clear(ring_buffer: ?*SoundIoRingBuffer) void;

pub const SoundIoFormatS16NE = SoundIoFormatS16LE;
pub const SoundIoFormatU16NE = SoundIoFormatU16LE;
pub const SoundIoFormatS24NE = SoundIoFormatS24LE;
pub const SoundIoFormatU24NE = SoundIoFormatU24LE;
pub const SoundIoFormatS32NE = SoundIoFormatS32LE;
pub const SoundIoFormatU32NE = SoundIoFormatU32LE;
pub const SoundIoFormatFloat32NE = SoundIoFormatFloat32LE;
pub const SoundIoFormatFloat64NE = SoundIoFormatFloat64LE;
pub const SoundIoFormatS16FE = SoundIoFormatS16BE;
pub const SoundIoFormatU16FE = SoundIoFormatU16BE;
pub const SoundIoFormatS24FE = SoundIoFormatS24BE;
pub const SoundIoFormatU24FE = SoundIoFormatU24BE;
pub const SoundIoFormatS32FE = SoundIoFormatS32BE;
pub const SoundIoFormatU32FE = SoundIoFormatU32BE;
pub const SoundIoFormatFloat32FE = SoundIoFormatFloat32BE;
pub const SoundIoFormatFloat64FE = SoundIoFormatFloat64BE;
pub const MAX_CHANNELS = 24;
