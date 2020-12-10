pub extern fn soundio_version_string() [*:0]const u8;
pub extern fn soundio_version_major() c_int;
pub extern fn soundio_version_minor() c_int;
pub extern fn soundio_version_patch() c_int;
pub extern fn soundio_strerror(@"error": c_int) [*:0]const u8;

pub const Error = extern enum(c_int) {
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

pub const ChannelId = extern enum(c_int) {
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

    pub const getName = soundio_get_channel_name;
    pub const parse = soundio_parse_channel_id;
};

pub extern fn soundio_get_channel_name(id: ChannelId) [*:0]const u8;
pub extern fn soundio_parse_channel_id(str: [*:0]const u8, str_len: c_int) ChannelId;

pub const ChannelLayoutId = extern enum(c_int) {
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

    pub const getBuiltinCount = soundio_channel_layout_builtin_count;
};
pub extern fn soundio_channel_layout_builtin_count() c_int;

pub const Backend = extern enum(c_int) {
    None,
    Jack,
    PulseAudio,
    Alsa,
    CoreAudio,
    Wasapi,
    Dummy,
    _,

    pub const exists = soundio_have_backend;
    pub const getName = soundio_backend_name;
};
pub extern fn soundio_have_backend(backend: Backend) bool;
pub extern fn soundio_backend_name(backend: Backend) [*:0]const u8;

pub const DeviceAim = extern enum(c_int) {
    Input,
    Output,
    _,
};
pub const Format = extern enum(c_int) {
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

    pub const getBytesPerSample = soundio_get_bytes_per_sample;
    pub const getBytesPerFrame = soundio_get_bytes_per_frame;
    pub const getBytesPerSecond = soundio_get_bytes_per_second;
    pub const toString = soundio_format_string;
};

pub extern fn soundio_get_bytes_per_sample(format: Format) c_int;
pub fn soundio_get_bytes_per_frame(arg_format: Format, arg_channel_count: c_int) callconv(.C) c_int {
    var format = arg_format;
    var channel_count = arg_channel_count;
    return (soundio_get_bytes_per_sample(format) * channel_count);
}
pub fn soundio_get_bytes_per_second(arg_format: Format, arg_channel_count: c_int, arg_sample_rate: c_int) callconv(.C) c_int {
    var format = arg_format;
    var channel_count = arg_channel_count;
    var sample_rate = arg_sample_rate;
    return (soundio_get_bytes_per_frame(format, channel_count) * sample_rate);
}
pub extern fn soundio_format_string(format: Format) [*:0]const u8;

pub const ChannelLayout = extern struct {
    name: ?[*:0]const u8,
    channel_count: c_int,
    channels: [24]ChannelId,

    pub const equal = soundio_channel_layout_equal;
    pub const getBuiltin = soundio_channel_layout_get_builtin;
    pub const getDefault = soundio_channel_layout_get_default;
    pub const findChannel = soundio_channel_layout_find_channel;
    pub const detectBuiltin = soundio_channel_layout_detect_builtin;
    pub const findBestMatching = soundio_best_matching_channel_layout;
    pub const sort = soundio_sort_channel_layouts;
};

pub extern fn soundio_channel_layout_equal(a: *const ChannelLayout, b: *const ChannelLayout) bool;
pub extern fn soundio_channel_layout_get_builtin(index: c_int) ?*const ChannelLayout;
pub extern fn soundio_channel_layout_get_default(channel_count: c_int) ?*const ChannelLayout;
pub extern fn soundio_channel_layout_find_channel(layout: *const ChannelLayout, channel: ChannelId) c_int;
pub extern fn soundio_channel_layout_detect_builtin(layout: *ChannelLayout) bool;
pub extern fn soundio_best_matching_channel_layout(preferred_layouts: [*]const ChannelLayout, preferred_layout_count: c_int, available_layouts: [*]const ChannelLayout, available_layout_count: c_int) ?*const ChannelLayout;
pub extern fn soundio_sort_channel_layouts(layouts: [*]ChannelLayout, layout_count: c_int) void;

pub const SampleRateRange = extern struct {
    min: c_int,
    max: c_int,
};
pub const ChannelArea = extern struct {
    ptr: [*]u8,
    step: c_int,
};
pub const SoundIo = extern struct {
    userdata: ?*c_void,
    on_devices_change: ?fn (*SoundIo) callconv(.C) void,
    on_backend_disconnect: ?fn (*SoundIo, c_int) callconv(.C) void,
    on_events_signal: ?fn (*SoundIo) callconv(.C) void,
    current_backend: Backend,
    app_name: ?[*:0]const u8,
    emit_rtprio_warning: ?fn () callconv(.C) void,
    jack_info_callback: ?fn ([*c]const u8) callconv(.C) void,
    jack_error_callback: ?fn ([*c]const u8) callconv(.C) void,

    pub const create = soundio_create;
    pub const destroy = soundio_destroy;
    pub const connect = soundio_connect;
    pub const connectBackend = soundio_connect_backend;
    pub const disconnect = soundio_disconnect;
    pub const backendCount = soundio_backend_count;
    pub const getBackend = soundio_get_backend;
    pub const haveBackend = soundio_have_backend;
    pub const flushEvents = soundio_flush_events;
    pub const waitEvents = soundio_wait_events;
    pub const wakeup = soundio_wakeup;
    pub const forceDeviceScan = soundio_force_device_scan;

    pub const inputDeviceCount = soundio_input_device_count;
    pub const outputDeviceCount = soundio_output_device_count;
    pub const getInputDevice = soundio_get_input_device;
    pub const getOutputDevice = soundio_get_output_device;
    pub const defaultInputDeviceIndex = soundio_default_input_device_index;
    pub const defaultOutputDeviceIndex = soundio_default_output_device_index;
};

pub extern fn soundio_create() ?*SoundIo;
pub extern fn soundio_destroy(soundio: *SoundIo) void;
pub extern fn soundio_connect(soundio: *SoundIo) c_int;
pub extern fn soundio_connect_backend(soundio: *SoundIo, backend: Backend) c_int;
pub extern fn soundio_disconnect(soundio: *SoundIo) void;
pub extern fn soundio_backend_count(soundio: *SoundIo) c_int;
pub extern fn soundio_get_backend(soundio: *SoundIo, index: c_int) Backend;
pub extern fn soundio_flush_events(soundio: *SoundIo) void;
pub extern fn soundio_wait_events(soundio: *SoundIo) void;
pub extern fn soundio_wakeup(soundio: *SoundIo) void;
pub extern fn soundio_force_device_scan(soundio: *SoundIo) void;

pub extern fn soundio_input_device_count(soundio: *SoundIo) c_int;
pub extern fn soundio_output_device_count(soundio: *SoundIo) c_int;
pub extern fn soundio_get_input_device(soundio: *SoundIo, index: c_int) ?*Device;
pub extern fn soundio_get_output_device(soundio: *SoundIo, index: c_int) ?*Device;
pub extern fn soundio_default_input_device_index(soundio: *SoundIo) c_int;
pub extern fn soundio_default_output_device_index(soundio: *SoundIo) c_int;

pub const Device = extern struct {
    soundio: *SoundIo,
    id: [*:0]u8,
    name: ?[*:0]u8,
    aim: DeviceAim,
    layouts: [*]ChannelLayout,
    layout_count: c_int,
    current_layout: ChannelLayout,
    formats: [*]Format,
    format_count: c_int,
    current_format: Format,
    sample_rates: [*]SampleRateRange,
    sample_rate_count: c_int,
    sample_rate_current: c_int,
    software_latency_min: f64,
    software_latency_max: f64,
    software_latency_current: f64,
    is_raw: bool,
    ref_count: c_int,
    probe_error: c_int,

    pub const ref = soundio_device_ref;
    pub const unref = soundio_device_unref;
    pub const equal = soundio_device_equal;
    pub const sortChannelLayouts = soundio_device_sort_channel_layouts;
    pub const supportsFormat = soundio_device_supports_format;
    pub const supportsLayout = soundio_device_supports_layout;
    pub const supportsSampleRate = soundio_device_supports_sample_rate;
    pub const nearestSampleRate = soundio_device_nearest_sample_rate;
};

pub extern fn soundio_device_ref(device: *Device) void;
pub extern fn soundio_device_unref(device: *Device) void;
pub extern fn soundio_device_equal(a: *const Device, b: *const Device) bool;
pub extern fn soundio_device_sort_channel_layouts(device: *Device) void;
pub extern fn soundio_device_supports_format(device: *Device, format: Format) bool;

pub extern fn soundio_device_supports_layout(device: *Device, layout: *const ChannelLayout) bool;
pub extern fn soundio_device_supports_sample_rate(device: *Device, sample_rate: c_int) bool;
pub extern fn soundio_device_nearest_sample_rate(device: *Device, sample_rate: c_int) c_int;

pub const OutStream = extern struct {
    device: *Device,
    format: Format,
    sample_rate: c_int,
    layout: ChannelLayout,
    software_latency: f64,
    volume: f32,
    userdata: ?*c_void,
    write_callback: ?fn (*OutStream, c_int, c_int) callconv(.C) void,
    underflow_callback: ?fn (*OutStream) callconv(.C) void,
    error_callback: ?fn (*OutStream, c_int) callconv(.C) void,
    name: ?[*:0]const u8,
    non_terminal_hint: bool,
    bytes_per_frame: c_int,
    bytes_per_sample: c_int,
    layout_error: c_int,

    pub const create = soundio_outstream_create;
    pub const destroy = soundio_outstream_destroy;
    pub const open = soundio_outstream_open;
    pub const start = soundio_outstream_start;
    pub const beginWrite = soundio_outstream_begin_write;
    pub const endWrite = soundio_outstream_end_write;
    pub const clearBuffer = soundio_outstream_clear_buffer;
    pub const pause = soundio_outstream_pause;
    pub const getLatency = soundio_outstream_get_latency;
    pub const setVolume = soundio_outstream_set_volume;
};
pub extern fn soundio_outstream_create(device: *Device) ?*OutStream;
pub extern fn soundio_outstream_destroy(outstream: *OutStream) void;
pub extern fn soundio_outstream_open(outstream: *OutStream) c_int;
pub extern fn soundio_outstream_start(outstream: *OutStream) c_int;
pub extern fn soundio_outstream_begin_write(outstream: *OutStream, areas: *[*]ChannelArea, frame_count: *c_int) c_int;
pub extern fn soundio_outstream_end_write(outstream: *OutStream) c_int;
pub extern fn soundio_outstream_clear_buffer(outstream: *OutStream) c_int;
pub extern fn soundio_outstream_pause(outstream: *OutStream, pause: bool) c_int;
pub extern fn soundio_outstream_get_latency(outstream: *OutStream, out_latency: *f64) c_int;
pub extern fn soundio_outstream_set_volume(outstream: *OutStream, volume: f64) c_int;

pub const InStream = extern struct {
    device: *Device,
    format: Format,
    sample_rate: c_int,
    layout: ChannelLayout,
    software_latency: f64,
    userdata: ?*c_void,
    read_callback: ?fn (*InStream, c_int, c_int) callconv(.C) void,
    overflow_callback: ?fn (*InStream) callconv(.C) void,
    error_callback: ?fn (*InStream, c_int) callconv(.C) void,
    name: ?[*:0]const u8,
    non_terminal_hint: bool,
    bytes_per_frame: c_int,
    bytes_per_sample: c_int,
    layout_error: c_int,

    pub const create = soundio_instream_create;
    pub const destroy = soundio_instream_destroy;
    pub const open = soundio_instream_open;
    pub const start = soundio_instream_start;
    pub const beginRead = soundio_instream_begin_read;
    pub const endRead = soundio_instream_end_read;
    pub const pause = soundio_instream_pause;
    pub const getLatency = soundio_instream_get_latency;
};
pub extern fn soundio_instream_create(device: *Device) ?*InStream;
pub extern fn soundio_instream_destroy(instream: *InStream) void;
pub extern fn soundio_instream_open(instream: *InStream) c_int;
pub extern fn soundio_instream_start(instream: *InStream) c_int;
pub extern fn soundio_instream_begin_read(instream: *InStream, areas: *[*]ChannelArea, frame_count: *c_int) c_int;
pub extern fn soundio_instream_end_read(instream: *InStream) c_int;
pub extern fn soundio_instream_pause(instream: *InStream, pause: bool) c_int;
pub extern fn soundio_instream_get_latency(instream: *InStream, out_latency: *f64) c_int;

pub const RingBuffer = opaque {
    pub const create = soundio_ring_buffer_create;
    pub const destroy = soundio_ring_buffer_destroy;
    pub const capacity = soundio_ring_buffer_capacity;
    pub const writePtr = soundio_ring_buffer_write_ptr;
    pub const advanceWritePtr = soundio_ring_buffer_advance_write_ptr;
    pub const readPtr = soundio_ring_buffer_read_ptr;
    pub const advanceReadPtr = soundio_ring_buffer_advance_read_ptr;
    pub const fillCount = soundio_ring_buffer_fill_count;
    pub const freeCount = soundio_ring_buffer_free_count;
    pub const clear = soundio_ring_buffer_clear;
};
pub extern fn soundio_ring_buffer_create(soundio: *SoundIo, requested_capacity: c_int) ?*RingBuffer;
pub extern fn soundio_ring_buffer_destroy(ring_buffer: ?*RingBuffer) void;
pub extern fn soundio_ring_buffer_capacity(ring_buffer: ?*RingBuffer) c_int;
pub extern fn soundio_ring_buffer_write_ptr(ring_buffer: ?*RingBuffer) ?[*]u8;
pub extern fn soundio_ring_buffer_advance_write_ptr(ring_buffer: ?*RingBuffer, count: c_int) void;
pub extern fn soundio_ring_buffer_read_ptr(ring_buffer: ?*RingBuffer) ?[*]u8;
pub extern fn soundio_ring_buffer_advance_read_ptr(ring_buffer: ?*RingBuffer, count: c_int) void;
pub extern fn soundio_ring_buffer_fill_count(ring_buffer: ?*RingBuffer) c_int;
pub extern fn soundio_ring_buffer_free_count(ring_buffer: ?*RingBuffer) c_int;
pub extern fn soundio_ring_buffer_clear(ring_buffer: ?*RingBuffer) void;

// TODO: Reinclude them
// pub const FormatS16NE = FormatS16LE;
// pub const FormatU16NE = FormatU16LE;
// pub const FormatS24NE = FormatS24LE;
// pub const FormatU24NE = FormatU24LE;
// pub const FormatS32NE = FormatS32LE;
// pub const FormatU32NE = FormatU32LE;
// pub const FormatFloat32NE = FormatFloat32LE;
// pub const FormatFloat64NE = FormatFloat64LE;
// pub const FormatS16FE = FormatS16BE;
// pub const FormatU16FE = FormatU16BE;
// pub const FormatS24FE = FormatS24BE;
// pub const FormatU24FE = FormatU24BE;
// pub const FormatS32FE = FormatS32BE;
// pub const FormatU32FE = FormatU32BE;
// pub const FormatFloat32FE = FormatFloat32BE;
// pub const FormatFloat64FE = FormatFloat64BE;
pub const MAX_CHANNELS = 24;
