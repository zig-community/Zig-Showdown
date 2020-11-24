const std = @import("std");
const zwl = @import("zwl");

const Texture = @import("../resources/Texture.zig");

pub const Style = enum {
    /// no fading, just flip shortly to black and then to the next image
    blink,

    /// alpha-fade between two images,
    cross_fade,

    /// fade the first to black, then the second from black
    in_and_out,

    /// a diagonal animation that "slides" from bottom-left to top-right
    slice_bl_to_tr,

    /// a diagonal animation that "slides" from top-right to bottom-left
    slice_tr_to_bl,
};

from: Texture,
to: Texture,
progress: f32,
style: Style,
