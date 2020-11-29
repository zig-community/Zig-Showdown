const std = @import("std");
const zwl = @import("zwl");
const gl = @import("gl");

const log = std.log.scoped(.OpenGL);

const WindowPlatform = @import("../../main.zig").WindowPlatform;
const Renderer = @import("../../Renderer.zig");
const Color = @import("../Color.zig");

const Self = @This();

window: *WindowPlatform.Window,

pub fn init(allocator: *std.mem.Allocator, window: *WindowPlatform.Window) !Self {
    try gl.load(window.platform, WindowPlatform.getOpenGlProcAddress);

    const required_extensions = [_][]const u8{
        "GL_ARB_direct_state_access",
    };
    var available_extensions = [1]bool{false} ** required_extensions.len;

    var extensions = std.mem.tokenize(std.mem.span(gl.getString(gl.GL_EXTENSIONS)), " ");
    while (extensions.next()) |extension| {
        for (required_extensions) |req, i| {
            if (std.mem.eql(u8, req, extension))
                available_extensions[i] = true;
        }
    }

    var all_available = true;
    for (required_extensions) |ext, i| {
        if (available_extensions[i] == false) {
            all_available = false;
            log.emerg("missing OpenGL extension: {}", .{ext});
        }
    }
    if (!all_available)
        return error.MissingOpenGlExtension;

    return Self{
        .window = window,
    };
}

pub fn deinit(self: *Self) void {
    self.* = undefined;
}

pub fn beginFrame(self: *Self) void {
    gl.clearColor(1, 0, 1, 1);
    gl.clear(gl.GL_COLOR_BUFFER_BIT);
}

pub fn endFrame(self: *Self) !void {
    try self.window.present();
}

pub fn clear(self: *Self, rt: Renderer.RenderTarget, color: Color) void {
    // stub
}

pub fn submitUiPass(self: *Self, render_target: Renderer.RenderTarget, pass: Renderer.UiPass) !void {
    // stub
}

pub fn submitScenePass(self: *Self, render_target: Renderer.RenderTarget, pass: Renderer.ScenePass) !void {
    // stub
}

pub fn submitTransition(self: *Self, render_target: Renderer.RenderTarget, transition: Renderer.Transition) !void {
    // stub
}
