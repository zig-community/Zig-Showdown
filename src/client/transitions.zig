const std = @import("std");
const zwl = @import("zwl");
const math = @import("math.zig");

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

/// Renders a transition between `src_from` and `src_to` with `progress` percent between `0.0` and `1.0` using
/// the given transition
pub fn render(src_from: zwl.PixelBuffer, src_to: zwl.PixelBuffer, dest: zwl.PixelBuffer, progress: f32, style: Style) void {
    std.debug.assert(src_from.width == src_to.width);
    std.debug.assert(src_from.width == dest.width);
    std.debug.assert(src_from.height == src_to.height);
    std.debug.assert(src_from.height == dest.height);

    switch (style) {
        .blink => if (progress < 0.3) {
            std.mem.copy(u32, dest.span(), src_from.span());
        } else if (progress > 0.7) {
            std.mem.copy(u32, dest.span(), src_to.span());
        } else {
            std.mem.set(u32, dest.span(), 0); // assume 0 is always black
        },

        .cross_fade => for (dest.span()) |*d, i| {
            d.* = lerpPixel(src_from.data[i], src_to.data[i], progress);
        },

        .in_and_out => if (progress <= 0.5) {
            for (dest.span()) |*d, i| {
                d.* = lerpPixel(src_from.data[i], 0, math.smoothstep(2.0 * progress));
            }
        } else {
            for (dest.span()) |*d, i| {
                d.* = lerpPixel(0, src_to.data[i], math.smoothstep(2.0 * (progress - 0.5)));
            }
        },

        .slice_bl_to_tr => {
            const limit = dest.width + dest.height;

            const threshold = @floatToInt(usize, math.smoothstep(progress) * @intToFloat(f32, limit));

            var y: usize = 0;
            while (y < dest.height) : (y += 1) {
                var x: usize = 0;
                while (x < dest.width) : (x += 1) {
                    const i = dest.width * y + x;
                    dest.data[i] = if (@intCast(isize, x) + @intCast(isize, dest.height - y) <= @intCast(isize, threshold))
                        src_to.data[i]
                    else
                        src_from.data[i];
                }
            }
        },

        .slice_tr_to_bl => {
            const limit = dest.width + dest.height;

            const threshold = @floatToInt(usize, math.smoothstep(progress) * @intToFloat(f32, limit));

            var y: usize = 0;
            while (y < dest.height) : (y += 1) {
                var x: usize = 0;
                while (x < dest.width) : (x += 1) {
                    const i = dest.width * y + x;
                    dest.data[i] = if (@intCast(isize, x) + @intCast(isize, dest.height - y) >= @intCast(isize, limit - threshold))
                        src_to.data[i]
                    else
                        src_from.data[i];
                }
            }
        },
    }
}

fn lerp8(a: u8, b: u8, f: f32) u8 {
    return @floatToInt(u8, @intToFloat(f32, a) * (1.0 - f) + @intToFloat(f32, b) * f);
}

fn lerpPixel(a: u32, b: u32, f: f32) u32 {
    const pa = @bitCast(zwl.Pixel, a);
    const pb = @bitCast(zwl.Pixel, b);
    return @bitCast(u32, zwl.Pixel{
        .r = lerp8(pa.r, pb.r, f),
        .g = lerp8(pa.g, pb.g, f),
        .b = lerp8(pa.b, pb.b, f),
        .a = lerp8(pa.a, pb.a, f),
    });
}
