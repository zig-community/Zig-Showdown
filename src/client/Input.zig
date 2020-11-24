const std = @import("std");

const Self = @This();

pub const Button = enum(usize) {
    left_mouse = 0,
    up = 1,
    down = 2,
    left = 3,
    right = 4,
    jump = 5,
    accept = 6,
    back = 7,
};

pub const Axis = enum(usize) {
    look_horizontal = 0,
    look_vertical = 1,
    move_horizontal = 2,
    move_vertical = 3,
};

pub const MouseTranslation = struct {
    dx: isize,
    dy: isize,

    pub fn any(self: @This()) bool {
        return (self.dx != 0) or (self.dy != 0);
    }
};

const button_count = blk: {
    var num = 0;
    for (std.meta.fields(Button)) |fld| {
        num = std.math.max(num, @enumToInt(@field(Button, fld.name)) + 1);
    }
    break :blk num;
};

button_was_pressed: [button_count]bool,
button_was_released: [button_count]bool,
button_is_down: [button_count]bool,

any_button_was_pressed: bool,
any_button_was_released: bool,

mouse_x: isize,
mouse_y: isize,

previous_mouse_x: isize,
previous_mouse_y: isize,

pub fn init() Self {
    const zeroes = [1]bool{false} ** button_count;
    return Self{
        .button_was_pressed = zeroes,
        .button_was_released = zeroes,
        .button_is_down = zeroes,

        .any_button_was_pressed = false,
        .any_button_was_released = false,

        .mouse_x = 0,
        .mouse_y = 0,

        .previous_mouse_x = 0,
        .previous_mouse_y = 0,
    };
}

/// Returns `true` when `btn` was hit in the current frame.
pub fn isHit(self: Self, btn: Button) bool {
    return self.button_was_pressed[@enumToInt(btn)];
}

/// Returns `true` when any button was hit in the current frame.
pub fn isAnyHit(self: Self) bool {
    return self.any_button_was_pressed;
}

/// Returns `true` when `btn` was released in the current frame.
pub fn isReleased(self: Self, btn: Button) bool {
    return self.button_was_released[@enumToInt(btn)];
}

/// Returns `true` when any button was released in the current frame.
pub fn isAnyReleased(self: Self) bool {
    return self.any_button_was_released;
}

/// Returns `true` when `btn` is currently held down.
pub fn isPressed(self: Self, btn: Button) bool {
    return self.button_is_down[@enumToInt(btn)];
}

pub fn mouseDelta(self: Self) MouseTranslation {
    return MouseTranslation{
        .dx = self.mouse_x - self.previous_mouse_x,
        .dy = self.mouse_y - self.previous_mouse_y,
    };
}

/// Returns the input value [-1.0; 1.0] for each axis.
pub fn axis(self: Self, ax: Axis) f32 {
    // TODO: Improve this and add controller support
    return switch (ax) {
        // Currently returns speed between 0 and 100 pixels per frame
        .look_horizontal => std.math.clamp(0.01 * @intToFloat(f32, self.mouseDelta().dx), -1.0, 1.0),
        .look_vertical => std.math.clamp(0.01 * @intToFloat(f32, self.mouseDelta().dy), -1.0, 1.0),

        .move_horizontal => (if (self.isPressed(.right)) @as(f32, 1) else 0) - (if (self.isPressed(.left)) @as(f32, 1) else 0),
        .move_vertical => (if (self.isPressed(.up)) @as(f32, 1) else 0) - (if (self.isPressed(.down)) @as(f32, 1) else 0),
    };
}

/// Rearms all button events
pub fn resetEvents(self: *Self) void {
    for (self.button_was_pressed) |*b| b.* = false;
    for (self.button_was_released) |*b| b.* = false;

    self.previous_mouse_x = self.mouse_x;
    self.previous_mouse_y = self.mouse_y;

    self.any_button_was_pressed = false;
    self.any_button_was_released = false;
}

/// Updates a button state and triggers the corresponding events
pub fn updateButton(self: *Self, btn: Button, state: bool) void {
    const index = @enumToInt(btn);
    self.button_is_down[index] = state;
    self.button_was_pressed[index] = self.button_was_pressed[index] or state;
    self.button_was_released[index] = self.button_was_released[index] or !state;

    self.any_button_was_pressed = self.any_button_was_pressed or state;
    self.any_button_was_released = self.any_button_was_released or !state;
}
