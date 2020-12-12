const std = @import("std");
const log = std.log.scoped(.audio);

const soundio = @import("soundio");

const Self = @This();

pub const Sound = @import("resources/Sound.zig");

allocator: *std.mem.Allocator,
interface: *soundio.SoundIo,
outstream: *soundio.OutStream,
device: *soundio.Device,

event_pool: EventPool,
event_queue: EventQueue,

current_time: usize = 0,

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

    interface.app_name = "Zig Showdown";

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
    outstream.name = "Game Audio";
    outstream.software_latency = 1.0 / 30.0; // realtime application

    const self = try allocator.create(Self);
    errdefer allocator.destroy(self);

    self.* = Self{
        .allocator = allocator,
        .interface = interface,
        .outstream = outstream,
        .device = device,

        .event_pool = EventPool.init(allocator),
        .event_queue = EventQueue.init(),
    };
    errdefer self.event_pool.deinit();

    outstream.userdata = self;

    try trySound(outstream.open());

    try trySound(outstream.layout_error);

    return self;
}

/// Starts the audio playback
pub fn start(self: *Self) !void {
    try trySound(self.outstream.start());
}

/// Returns the time since the start of the audio playback
pub fn getTime(self: Self) f32 {
    return @intToFloat(f32, @atomicLoad(usize, &self.current_time, .Acquire)) / @intToFloat(f32, self.outstream.sample_rate);
}

pub fn update(self: *Self) !void {
    self.interface.flushEvents();
}

pub fn deinit(self: *Self) void {
    self.outstream.destroy();
    self.device.unref();
    self.interface.destroy();
    self.event_pool.deinit();
    self.allocator.destroy(self);
}

pub const PlaybackOptions = struct {
    // volume of the sound between 0.0 and 1.0
    volume: f32 = 1.0,

    /// panning between left (-1.0) and right (1.0) speaker.
    pan: f32 = 0.0,

    /// Defines the start time of the sound in seconds from *now*
    start_time: ?f32 = null,

    // TODO: Implement repeating sounds
    // /// Play the sound for `count` times. If `count` is `null`, it will be
    // /// repeated endlessly
    // count: ?usize = 1,
};

pub fn playSound(self: *Self, sound: Sound, options: PlaybackOptions) !void {
    const pleft = std.math.clamp(1.0 - options.pan, 0.0, 1.0); // pan=0 → pleft=1, pan=1 → pleft=0
    const pright = std.math.clamp(1.0 + options.pan, 0.0, 1.0); // pan=0 → pright=1, pan=-1 → pleft=0

    const current_time = @atomicLoad(usize, &self.current_time, .Acquire);

    const event = try self.event_pool.createEvent();
    event.* = SoundEvent{
        .sound = sound,
        .left_vol = pleft * options.volume,
        .right_vol = pright * options.volume,
        .start_time = if (options.start_time) |start_time|
            @panic("TODO: Implement start time calculation")
        else
            current_time,
        .count = 0,
    };

    self.event_queue.enqueue(event);
}

fn writeCallback(outstream: *soundio.OutStream, _frame_count_min: c_int, _frame_count_max: c_int) callconv(.C) void {
    const frame_count_min = @intCast(usize, _frame_count_min);
    const frame_count_max = @intCast(usize, _frame_count_max);

    // this is called in a background thread, so we need some synchronization here!
    const self = @ptrCast(*Self, @alignCast(@alignOf(Self), outstream.userdata));
    const layout = &outstream.layout;

    var frames_left = frame_count_max;

    while (frames_left > 0) {
        var _frame_count: c_int = @intCast(c_int, frames_left);

        var areas: [*]soundio.ChannelArea = undefined;
        trySound(outstream.beginWrite(&areas, &_frame_count)) catch @panic("unexpected sound error");

        const frame_count = @intCast(usize, _frame_count);
        const channels = areas[0..@intCast(usize, layout.channel_count)];

        if (frame_count == 0)
            break;

        const end_time = self.current_time + frame_count;

        // Basic idea of sound rendering here:
        // Clear the buffer segment to silence,
        // then add each sound event on top of the silence,
        // then add a limiter and global audio effects
        {
            var frame: usize = 0;
            while (frame < frame_count) : (frame += 1) {
                for (channels) |*chan| {
                    @ptrCast(*align(1) f32, chan.ptr + @intCast(usize, chan.step) * frame).* = 0;
                }
            }
        }

        // Render all relevant audio parts here:
        // Loop over the events, and for each event, loop over the samples.
        // This is better for the cache than looping through all events for each sample

        {
            var events = self.event_queue.iterate();
            defer events.deinit();

            while (events.next()) |event| {

                // Check if the events in the queue will happen after the currently processed
                // samples. If so, we can stop the loop
                if (event.start_time >= end_time)
                    break;

                // we can skip frames if we have overlap
                const start_in_frame = if (event.start_time > self.current_time)
                    event.start_time - self.current_time
                else
                    0;

                const start_in_sound = if (self.current_time > event.start_time)
                    self.current_time - event.start_time
                else
                    0;

                // Sound did complete, remove it from the queue and return the event to the pool.
                if (start_in_sound >= event.sound.samples.len) {
                    self.event_pool.freeEvent(events.pop());
                    continue;
                }

                // Sound didn't not start yet, just continue
                if (start_in_frame > frame_count) {
                    continue;
                }

                const count = std.math.min(frame_count - start_in_frame, event.sound.samples.len - start_in_sound);

                // log.info("play sound t={d: <8} c={d: <8} o[s]={d: <8} o[f]={d: <8} d={d: <8} n={d: <8}", .{
                //     self.current_time,
                //     frame_count,
                //     start_in_sound,
                //     start_in_frame,
                //     event.sound.samples.len,
                //     count,
                // });

                var offset: usize = 0;
                while (offset < count) : (offset += 1) {
                    const sample = event.sound.samples[start_in_sound + offset];
                    for (channels) |*chan, i| {
                        const chan_sample = sample * switch (i % 2) {
                            0 => event.left_vol,
                            1 => event.right_vol,
                            else => unreachable,
                        };
                        @ptrCast(*align(1) f32, chan.ptr + @intCast(usize, chan.step) * (start_in_frame + offset)).* += chan_sample;
                    }
                }
            }
        }

        // Apply simple clamp limiting
        {
            var frame: usize = 0;
            while (frame < frame_count) : (frame += 1) {
                for (channels) |*chan| {
                    const sample = @ptrCast(*align(1) f32, chan.ptr + @intCast(usize, chan.step) * frame);
                    sample.* = std.math.clamp(sample.*, -1.0, 1.0);
                }
            }
        }

        trySound(outstream.endWrite()) catch @panic("unexpected sound error");

        frames_left -= frame_count;

        // Notify other threads that we changed current_time
        _ = @atomicRmw(usize, &self.current_time, .Add, frame_count, .SeqCst);
    }
}

const SoundEvent = struct {
    next: ?*SoundEvent = null,
    in_queue: bool = false,

    sound: Sound,
    left_vol: f32,
    right_vol: f32,
    start_time: usize,
    count: usize,
};

/// Priority queue for SoundEvent.
/// Each event is queued into the right slot so the events will be queued first-to-last.
const EventQueue = struct {
    head: ?*SoundEvent,
    mutex: std.Mutex,

    fn init() EventQueue {
        return EventQueue{
            .mutex = .{},
            .head = null,
        };
    }

    /// Inserts a forein-owned event into the queue. The event must not be in another queue already.
    fn enqueue(self: *EventQueue, event: *SoundEvent) void {
        std.debug.assert(!event.in_queue);

        var locked = self.mutex.acquire();
        defer locked.release();

        event.next = null;
        if (self.head) |head| {
            // if `event` is before the current head
            if (head.start_time > event.start_time) {
                event.next = head;
                self.head = event;
            } else {
                var it = head;
                while (true) {
                    if (it.next) |next| {
                        if (next.start_time > event.start_time) {
                            // insert between current location and the next
                            event.next = next;
                            it.next = event;
                            break;
                        } else {
                            // continue search
                            it = next;
                        }
                    } else {
                        // end of queue, just append and break
                        it.next = event;
                        break;
                    }
                }
            }
        } else {
            self.head = event;
        }
    }

    /// returns an iterator that allows popping items from the queue.
    /// Important: The iterator locks the queue and must be `deinit`ed!
    fn iterate(self: *EventQueue) EventQueueIterator {
        return EventQueueIterator{
            .queue = self,
            .held = self.mutex.acquire(),
        };
    }
};

const EventQueueIterator = struct {
    queue: *EventQueue,
    held: std.Mutex.Held,

    previous: ?*SoundEvent = null,
    current: ?*SoundEvent = null,

    pub fn deinit(self: *EventQueueIterator) void {
        self.held.release();
        self.* = undefined;
    }

    /// returns the next item in the queue or `null` if the end of the queue is reached
    pub fn next(self: *EventQueueIterator) ?*SoundEvent {
        self.previous = self.current; // store the previous item so we can pop() them later

        if (self.current) |current| {
            self.current = current.next;
        } else {
            self.current = self.queue.head;
        }

        return self.current;
    }

    /// Removes a event from the queue. This must be called after a call to next() that returned a non-null value.
    pub fn pop(self: *EventQueueIterator) *SoundEvent {
        std.debug.assert(self.current != null);

        const current = self.current.?;

        if (self.previous) |previous| {
            // just skip over the element in the linked list
            previous.next = current.next;
        } else {
            // move the head forward
            self.queue.head = current.next;
        }

        // we removed the current element, so we have to go back one
        self.current = self.previous;

        current.in_queue = false;
        current.next = null;
        return current;
    }
};

const EventPool = struct {
    arena: std.heap.ArenaAllocator,
    free_list: ?*SoundEvent,
    mutex: std.Mutex,

    fn init(allocator: *std.mem.Allocator) EventPool {
        return EventPool{
            .arena = std.heap.ArenaAllocator.init(allocator),
            .free_list = null,
            .mutex = .{},
        };
    }

    fn deinit(self: *EventPool) void {
        self.arena.deinit();
        self.* = undefined;
    }

    fn createEvent(self: *EventPool) !*SoundEvent {
        {
            var held = self.mutex.acquire();
            defer held.release();
            // Pop the front element if any
            if (self.free_list) |event| {
                self.free_list = event.next;
                event.next = null;
                return event;
            }
        }
        // we didn't have a cached element in the stash, so we create a new one:
        const event = try self.arena.allocator.create(SoundEvent);
        event.in_queue = false;
        event.next = null;
        return event;
    }

    /// Returns a event into the event pool and frees it.
    fn freeEvent(self: *EventPool, event: *SoundEvent) void {
        var held = self.mutex.acquire();
        defer held.release();

        // Destroy the event data
        event.* = undefined;

        // Reinsert the event into our freelist
        event.in_queue = false;
        event.next = self.free_list;
        self.free_list = event;
    }
};

test "EventPool" {
    var pool = EventPool.init(std.testing.allocator);
    defer pool.deinit();

    const e1 = try pool.createEvent();
    const e2 = try pool.createEvent();

    std.testing.expect(e1 != e2);

    // Return in  reverse order, so we can pull them from the free-list again in e1, e2 order
    pool.freeEvent(e2);
    pool.freeEvent(e1);

    const e3 = try pool.createEvent();
    const e4 = try pool.createEvent();

    std.testing.expect(e1 == e3);
    std.testing.expect(e2 == e4);

    pool.freeEvent(e3);

    const e5 = try pool.createEvent();
    const e6 = try pool.createEvent();

    std.testing.expect(e5 == e3);
    std.testing.expect(e6 != e3);
}

test "EventQueue" {
    var queue = EventQueue.init();

    var events = [1]SoundEvent{SoundEvent{
        .start_time = 0,
        .count = 0, // we use count to store the index

        // not needed for the test
        .sound = undefined,
        .left_vol = undefined,
        .right_vol = undefined,
    }} ** 10;
    for (events) |*e, i| {
        e.start_time = 10 * i;
        e.count = i;
    }

    // Insert in "natural" order
    queue.enqueue(&events[3]);
    queue.enqueue(&events[4]);
    queue.enqueue(&events[5]);

    // Insert in "reverse" order
    queue.enqueue(&events[2]);
    queue.enqueue(&events[1]);
    queue.enqueue(&events[0]);

    var iter = queue.iterate();
    defer iter.deinit();

    // iterate the queue and drop all elements with uneven index
    {
        var index: usize = 0;
        while (iter.next()) |item| : (index += 1) {
            std.testing.expectEqual(index, item.count);

            // remove uneven elements while iterating
            if (index % 2 == 1)
                std.testing.expectEqual(item, iter.pop());
        }
        std.testing.expectEqual(@as(usize, 6), index);
    }

    // check if we removed all uneven elements from the queue
    {
        var index: usize = 0;
        while (iter.next()) |item| : (index += 1) {
            std.testing.expectEqual(2 * index, item.count);
        }
        std.testing.expectEqual(@as(usize, 3), index);
    }
}

pub const Timer = struct {
    previous: f32,

    pub fn start(audio: Self) Timer {
        return Timer{
            .previous = audio.getTime(),
        };
    }

    pub fn lap(self: *Timer, audio: Self) f32 {
        const t = audio.getTime();
        defer self.previous = t;
        return t - self.previous;
    }
};
