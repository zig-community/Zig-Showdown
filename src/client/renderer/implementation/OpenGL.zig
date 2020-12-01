const std = @import("std");
const zwl = @import("zwl");
const gl = @import("gl");

const log = std.log.scoped(.OpenGL);

const WindowPlatform = @import("../../main.zig").WindowPlatform;
const Renderer = @import("../../Renderer.zig");
const Color = @import("../Color.zig");
const Resources = @import("../../Resources.zig");

const Self = @This();

window: *WindowPlatform.Window,

pub const Texture = gl.GLuint;

pub const Model = struct {
    vertex_buffer: gl.GLuint,
    index_buffer: gl.GLuint,
};

pub fn init(allocator: *std.mem.Allocator, window: *WindowPlatform.Window) !Self {
    try gl.load(window.platform, WindowPlatform.getOpenGlProcAddress);

    const required_extensions = [_][]const u8{
        "GL_ARB_direct_state_access",
        "GL_KHR_debug",
    };
    var available_extensions = [1]bool{false} ** required_extensions.len;

    var extensions = std.mem.tokenize(std.mem.span(gl.getString(gl.EXTENSIONS)), " ");
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

    try gl.GL_ARB_direct_state_access.load(window.platform, WindowPlatform.getOpenGlProcAddress);
    try gl.GL_KHR_debug.load(window.platform, WindowPlatform.getOpenGlProcAddress);

    // Always enable debug output:
    gl.enable(gl.GL_KHR_debug.DEBUG_OUTPUT);
    gl.GL_KHR_debug.debugMessageCallback(debugCallback, null);

    // // And in debug builds, enable synchronous output for stack traces:
    // if (std.builtin.mode == .Debug) {
    //     gl.enable(gl.GL_KHR_debug.DEBUG_OUTPUT_SYNCHRONOUS);
    // }

    return Self{
        .window = window,
    };
}

pub fn deinit(self: *Self) void {
    self.* = undefined;
}

pub fn beginFrame(self: *Self) void {
    gl.clearColor(0, 0, 0, 1);
    gl.clear(gl.COLOR_BUFFER_BIT);
}

pub fn endFrame(self: *Self) !void {
    try self.window.present();
}

pub fn clear(self: *Self, rt: Renderer.RenderTarget, color: Color) void {
    gl.clearColor(
        @intToFloat(f32, color.b) / 255.0,
        @intToFloat(f32, color.g) / 255.0,
        @intToFloat(f32, color.b) / 255.0,
        @intToFloat(f32, color.a) / 255.0,
    );
    gl.clear(gl.COLOR_BUFFER_BIT);
}

pub fn submitUiPass(self: *Self, render_target: Renderer.RenderTarget, pass: Renderer.UiPass) !void {
    // stub
}

pub fn submitScenePass(self: *Self, render_target: Renderer.RenderTarget, pass: Renderer.ScenePass) !void {
    gl.clearDepth(1.0);
    gl.clear(gl.DEPTH_BUFFER_BIT);
    gl.enable(gl.DEPTH_TEST);
    defer gl.disable(gl.DEPTH_TEST);
}

pub fn submitTransition(self: *Self, render_target: Renderer.RenderTarget, transition: Renderer.Transition) !void {
    // stub
}

pub fn createTexture(self: *Self, texture: *Resources.Texture) !Texture {
    var ids = [1]gl.GLuint{0};
    gl.GL_ARB_direct_state_access.createTextures(gl.TEXTURE_2D, 1, &ids);
    if (ids[0] == 0)
        return error.OpenGlFailure;

    // Don't create mipmaps for now
    gl.GL_ARB_direct_state_access.textureStorage2D(
        ids[0],
        1,
        gl.RGBA8,
        @intCast(c_int, texture.width),
        @intCast(c_int, texture.height),
    );

    gl.GL_ARB_direct_state_access.textureSubImage2D(
        ids[0],
        0, // level
        0,
        0, // x,y
        @intCast(c_int, texture.width),
        @intCast(c_int, texture.height), // size,
        gl.BGRA,
        gl.UNSIGNED_BYTE,
        texture.pixels.ptr,
    );

    gl.GL_ARB_direct_state_access.textureParameteri(
        ids[0],
        gl.TEXTURE_MAG_FILTER,
        gl.LINEAR,
    );
    gl.GL_ARB_direct_state_access.textureParameteri(
        ids[0],
        gl.TEXTURE_MIN_FILTER,
        gl.LINEAR,
    );
    gl.GL_ARB_direct_state_access.textureParameteri(
        ids[0],
        gl.TEXTURE_WRAP_S,
        gl.REPEAT,
    );
    gl.GL_ARB_direct_state_access.textureParameteri(
        ids[0],
        gl.TEXTURE_WRAP_T,
        gl.REPEAT,
    );

    return ids[0];
}

pub fn destroyTexture(self: *Self, texture: *Texture) void {
    gl.deleteTextures(1, texture);
}

pub fn createModel(self: *Self, model: *Resources.Model) !Model {
    var ids = [2]gl.GLuint{ 0, 0 };
    gl.GL_ARB_direct_state_access.createBuffers(2, &ids);
    errdefer gl.deleteBuffers(2, &ids);
    if (ids[0] == 0 or ids[1] == 0)
        return error.OpenGlFailure;

    // TODO: Fill buffers with contents

    return Model{
        .vertex_buffer = ids[0],
        .index_buffer = ids[1],
    };
}

pub fn destroyModel(self: *Self, model: *Model) void {
    var ids = [2]gl.GLuint{ model.vertex_buffer, model.index_buffer };
    gl.deleteBuffers(2, &ids);
}

fn debugCallback(source: gl.GLenum, msg_type: gl.GLenum, id: gl.GLuint, severity: gl.GLenum, length: gl.GLsizei, message: [*:0]const u8, userParam: ?*c_void) callconv(.C) void {
    // std.debug.print("{} {} {} {} {} {*} {}:\n", .{
    //     source, msg_type, id, severity, length, message, userParam,
    // });
    const msg = "{}";
    const args = .{
        message[0..@intCast(usize, length)],
    };

    switch (severity) {
        gl.GL_KHR_debug.DEBUG_SEVERITY_HIGH => log.emerg(msg, args),
        gl.GL_KHR_debug.DEBUG_SEVERITY_MEDIUM => log.warn(msg, args),
        gl.GL_KHR_debug.DEBUG_SEVERITY_LOW => log.info(msg, args),
        gl.GL_KHR_debug.DEBUG_SEVERITY_NOTIFICATION => log.notice(msg, args),
        else => log.debug("(severity: 0x{X:0>4}) " ++ msg, .{severity} ++ args),
    }

    // if (std.builtin.mode == .Debug) {
    //     switch (severity) {
    //         gl.GL_KHR_debug.DEBUG_SEVERITY_HIGH,
    //         gl.GL_KHR_debug.DEBUG_SEVERITY_MEDIUM,
    //         gl.GL_KHR_debug.DEBUG_SEVERITY_LOW,
    //         => {
    //             std.debug.dumpCurrentStackTrace(null);
    //             @panic("Critical OpenGL error detected. Stopping");
    //         },
    //         else => {},
    //     }
    // }
}
