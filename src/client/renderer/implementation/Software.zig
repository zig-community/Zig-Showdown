//! The software renderer is the reference backend
//! for rendering Zig SHOWDOWN.
//!
//! Most types are empty or NO-OPs, but documented on how they
//! are supposed to work and what their purpose is.

const std = @import("std");
const zwl = @import("zwl");
const WindowPlatform = @import("root").WindowPlatform;

const Color = @import("../Color.zig");

const Self = @This();

const Resources = @import("../../Resources.zig");
const Renderer = @import("../../Renderer.zig");

window: *WindowPlatform.Window,
pixbuf: ?zwl.PixelBuffer,

/// Initializes a new rendering backend instance for the given window.
pub fn init(allocator: *std.mem.Allocator, window: *WindowPlatform.Window) !Self {

    // this is required to kick-off ZWLs software rendering loop
    const pbuf = try window.mapPixels();
    try window.submitPixels(&[_]zwl.UpdateArea{
        zwl.UpdateArea{
            .x = 0,
            .y = 0,
            .w = pbuf.width,
            .h = pbuf.height,
        },
    });

    return Self{
        .window = window,
        .pixbuf = null,
    };
}

/// Destroys a previously created rendering instance.
pub fn deinit(self: *Self) void {}

/// Starts to render a new frame. This is meant as a notification
/// event to prepare a newly rendered frame.
/// Each call must be followed by draw calls and finally by a call to
/// `endFrame()`.
pub fn beginFrame(self: *Self) !void {
    std.debug.assert(self.pixbuf == null);
    self.pixbuf = try self.window.mapPixels();

    std.mem.set(u32, self.pixbuf.?.span(), 0xFFFF00FF);
}

/// Finishes the frame and pushes the resulting image to the screen.
pub fn endFrame(self: *Self) !void {
    std.debug.assert(self.pixbuf != null);
    try self.window.submitPixels(&[_]zwl.UpdateArea{
        zwl.UpdateArea{
            .x = 0,
            .y = 0,
            .w = self.pixbuf.?.width,
            .h = self.pixbuf.?.height,
        },
    });
    self.pixbuf = null;
}

pub fn clear(self: *Self, rt: Renderer.RenderTarget, color: Color) void {
    std.debug.assert(self.pixbuf != null);
    const pixel_value = zwl.Pixel{
        .r = color.r,
        .g = color.g,
        .b = color.b,
        .a = color.a,
    };
    const pixbuf = if (rt.backing_texture) |tex|
        zwl.PixelBuffer{
            .data = @ptrCast([*]u32, tex.pixels.ptr),
            .width = @intCast(u16, tex.width),
            .height = @intCast(u16, tex.height),
        }
    else
        self.pixbuf.?;

    std.mem.set(u32, pixbuf.span(), @bitCast(u32, pixel_value));
}
