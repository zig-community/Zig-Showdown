const std = @import("std");
const zwl = @import("zwl");
const gl = @import("gl");
const zlm = @import("zlm");
const ui = @import("../../ui.zig");

const DSA = gl.GL_ARB_direct_state_access;

const log = std.log.scoped(.OpenGL);

const WindowPlatform = @import("../../main.zig").WindowPlatform;
const Renderer = @import("../../Renderer.zig");
const Color = @import("../Color.zig");
const Resources = @import("../../Resources.zig");

const Self = @This();

pub const Texture = gl.GLuint;

pub const Model = struct {
    vertex_buffer: gl.GLuint,
    index_buffer: gl.GLuint,
};

const UiVertex = extern struct {
    // align is required to insert the correct padding for the GPU
    // the GPU doesn't like non-16 aligned vertex data on some machines
    // (windows 10, intel 520)
    x: i16 align(16),
    y: i16,
    u: f16,
    v: f16,
    r: u8,
    g: u8,
    b: u8,
    a: u8,
};

const ModelShader = struct {
    program: gl.GLuint,

    uWorld: ?gl.GLint = null,
    uViewProjection: ?gl.GLint = null,
    uAlbedoTexture: ?gl.GLint = null,
};

const UiShader = struct {
    program: gl.GLuint,

    uScreenSize: ?gl.GLint = null,
    uTexture: ?gl.GLint = null,
};

const TransitionShader = struct {
    program: gl.GLuint,

    uScreenSize: ?gl.GLint = null,
    uFrom: ?gl.GLint = null,
    uTo: ?gl.GLint = null,
    uProgress: ?gl.GLint = null,
};

const VA_MDL_POSITION = 0;
const VA_MDL_NORMAL = 1;
const VA_MDL_UV = 2;

const VA_UI_POSITION = 0;
const VA_UI_TEXTURE = 1;
const VA_UI_TINT = 2;

const BIND_VERTICES = 0;

allocator: *std.mem.Allocator,
window: *WindowPlatform.Window,

frame_buffer: gl.GLuint,

model_vao: gl.GLuint,
model_shader: ModelShader,

ui_vao: gl.GLuint,
ui_shader: UiShader,

transition_vao: gl.GLuint,

transition_blink: TransitionShader,
transition_cross_fade: TransitionShader,
transition_in_and_out: TransitionShader,
transition_slice_bl_to_tr: TransitionShader,
transition_slice_tr_to_bl: TransitionShader,

depth_buffer: gl.GLuint,
white_texture: gl.GLuint,

pub fn init(allocator: *std.mem.Allocator, window: *WindowPlatform.Window) !Self {
    try gl.load(window.platform, WindowPlatform.getOpenGlProcAddress);

    log.info("OpenGL Version:  {}", .{std.mem.span(gl.getString(gl.VERSION))});
    log.info("OpenGL Vendor:   {}", .{std.mem.span(gl.getString(gl.VENDOR))});
    log.info("OpenGL Renderer: {}", .{std.mem.span(gl.getString(gl.RENDERER))});

    const required_extensions = [_][]const u8{
        "GL_ARB_direct_state_access",
        "GL_KHR_debug",
    };
    var available_extensions = [1]bool{false} ** required_extensions.len;

    var num_extensions: gl.GLint = 0;
    gl.getIntegerv(gl.NUM_EXTENSIONS, &num_extensions);

    {
        var i = num_extensions;
        while (i > 0) {
            i -= 1;

            var extension = std.mem.span(gl.getStringi(gl.EXTENSIONS, @intCast(gl.GLuint, i)) orelse return error.OpenGlFailure);
            for (required_extensions) |req, j| {
                if (std.mem.eql(u8, req, extension))
                    available_extensions[j] = true;
            }
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

    // And in debug builds, enable synchronous output for stack traces:
    if (std.builtin.mode == .Debug) {
        gl.enable(gl.GL_KHR_debug.DEBUG_OUTPUT_SYNCHRONOUS);
    }

    const model_vao = blk: {
        var vao: gl.GLuint = 0;
        DSA.createVertexArrays(1, &vao);
        if (vao == 0)
            return error.OpenGlFailure;
        errdefer DSA.deleteVertexArrays(1, &vao);

        DSA.enableVertexArrayAttrib(vao, VA_MDL_POSITION);
        DSA.enableVertexArrayAttrib(vao, VA_MDL_NORMAL);
        DSA.enableVertexArrayAttrib(vao, VA_MDL_UV);

        DSA.vertexArrayAttribFormat(
            vao,
            VA_MDL_POSITION,
            3,
            gl.FLOAT,
            gl.FALSE,
            @byteOffsetOf(Resources.Model.Vertex, "x"),
        );
        DSA.vertexArrayAttribFormat(
            vao,
            VA_MDL_NORMAL,
            3,
            gl.BYTE,
            gl.TRUE,
            @byteOffsetOf(Resources.Model.Vertex, "nx"),
        );
        DSA.vertexArrayAttribFormat(
            vao,
            VA_MDL_UV,
            2,
            gl.FLOAT,
            gl.FALSE,
            @byteOffsetOf(Resources.Model.Vertex, "u"),
        );

        DSA.vertexArrayAttribBinding(vao, VA_MDL_POSITION, BIND_VERTICES);
        DSA.vertexArrayAttribBinding(vao, VA_MDL_NORMAL, BIND_VERTICES);
        DSA.vertexArrayAttribBinding(vao, VA_MDL_UV, BIND_VERTICES);

        break :blk vao;
    };
    errdefer gl.deleteVertexArrays(1, &model_vao);

    const ui_vao = blk: {
        var vao: gl.GLuint = 0;
        DSA.createVertexArrays(1, &vao);
        if (vao == 0)
            return error.OpenGlFailure;
        errdefer DSA.deleteVertexArrays(1, &vao);

        DSA.enableVertexArrayAttrib(vao, VA_UI_POSITION);
        DSA.enableVertexArrayAttrib(vao, VA_UI_TEXTURE);
        DSA.enableVertexArrayAttrib(vao, VA_UI_TINT);

        DSA.vertexArrayAttribIFormat(
            vao,
            VA_UI_POSITION,
            2,
            gl.UNSIGNED_SHORT,
            @byteOffsetOf(UiVertex, "x"),
        );
        DSA.vertexArrayAttribFormat(
            vao,
            VA_UI_TEXTURE,
            2,
            gl.HALF_FLOAT,
            gl.FALSE,
            @byteOffsetOf(UiVertex, "u"),
        );
        DSA.vertexArrayAttribFormat(
            vao,
            VA_UI_TINT,
            4,
            gl.UNSIGNED_BYTE,
            gl.TRUE,
            @byteOffsetOf(UiVertex, "r"),
        );

        DSA.vertexArrayAttribBinding(vao, VA_UI_POSITION, BIND_VERTICES);
        DSA.vertexArrayAttribBinding(vao, VA_UI_TEXTURE, BIND_VERTICES);
        DSA.vertexArrayAttribBinding(vao, VA_UI_TINT, BIND_VERTICES);

        break :blk vao;
    };
    errdefer gl.deleteVertexArrays(1, &ui_vao);

    var model_shader = try compileShader(
        allocator,
        ModelShader,
        @embedFile("opengl/model.vert"),
        @embedFile("opengl/model.frag"),
    );
    errdefer gl.deleteProgram(model_shader.program);

    var ui_shader = try compileShader(
        allocator,
        UiShader,
        @embedFile("opengl/ui.vert"),
        @embedFile("opengl/ui.frag"),
    );
    errdefer gl.deleteProgram(ui_shader.program);

    var depth_buffer: gl.GLuint = 0;
    DSA.createRenderbuffers(1, &depth_buffer);
    if (depth_buffer == 0)
        return error.OpenGlFailure;
    errdefer gl.deleteRenderbuffers(1, &depth_buffer);

    DSA.namedRenderbufferStorage(
        depth_buffer,
        gl.DEPTH24_STENCIL8,
        window.getSize()[0],
        window.getSize()[1],
    );

    var rt_fb = blk: {
        var fb: gl.GLuint = undefined;
        DSA.createFramebuffers(1, &fb);
        if (fb == 0)
            return error.OpenGlFailure;

        errdefer gl.deleteFramebuffers(1, &fb);

        DSA.namedFramebufferRenderbuffer(
            fb,
            gl.DEPTH_STENCIL_ATTACHMENT,
            gl.RENDERBUFFER,
            depth_buffer,
        );

        break :blk fb;
    };
    errdefer gl.deleteFramebuffers(1, &rt_fb);

    var white_texture: gl.GLuint = 0;
    DSA.createTextures(gl.TEXTURE_2D, 1, &white_texture);
    if (white_texture == 0)
        return error.OpenGlFailure;
    errdefer gl.deleteTextures(1, &white_texture);

    const white_texel: u32 = 0xFFFFFFFF;
    gl.GL_ARB_direct_state_access.textureStorage2D(white_texture, 1, gl.RGBA8, 1, 1);
    gl.GL_ARB_direct_state_access.textureSubImage2D(white_texture, 0, 0, 0, 1, 1, gl.RGBA, gl.UNSIGNED_BYTE, &white_texel);

    // this vertex array is just there to hold *zero* information
    // and requires no input data layout whatsoever
    var transition_vao: gl.GLuint = 0;
    DSA.createVertexArrays(1, &transition_vao);
    if (transition_vao == 0)
        return error.OpenGlFailure;
    errdefer gl.deleteVertexArrays(1, &transition_vao);

    var transition_blink = try compileShader(
        allocator,
        TransitionShader,
        @embedFile("opengl/transition.vert"),
        @embedFile("opengl/transition-blink.frag"),
    );
    var transition_cross_fade = try compileShader(
        allocator,
        TransitionShader,
        @embedFile("opengl/transition.vert"),
        @embedFile("opengl/transition-cross_fade.frag"),
    );
    var transition_in_and_out = try compileShader(
        allocator,
        TransitionShader,
        @embedFile("opengl/transition.vert"),
        @embedFile("opengl/transition-in_and_out.frag"),
    );
    var transition_slice_bl_to_tr = try compileShader(
        allocator,
        TransitionShader,
        @embedFile("opengl/transition.vert"),
        @embedFile("opengl/transition-slice_bl_to_tr.frag"),
    );
    var transition_slice_tr_to_bl = try compileShader(
        allocator,
        TransitionShader,
        @embedFile("opengl/transition.vert"),
        @embedFile("opengl/transition-slice_tr_to_bl.frag"),
    );

    return Self{
        .window = window,
        .allocator = allocator,

        .ui_vao = ui_vao,
        .ui_shader = ui_shader,

        .model_vao = model_vao,
        .model_shader = model_shader,

        .transition_vao = transition_vao,

        .transition_blink = transition_blink,
        .transition_cross_fade = transition_cross_fade,
        .transition_in_and_out = transition_in_and_out,
        .transition_slice_bl_to_tr = transition_slice_bl_to_tr,
        .transition_slice_tr_to_bl = transition_slice_tr_to_bl,

        .frame_buffer = rt_fb,
        .depth_buffer = depth_buffer,
        .white_texture = white_texture,
    };
}

pub fn deinit(self: *Self) void {
    gl.deleteFramebuffers(1, &self.frame_buffer);
    gl.deleteRenderbuffers(1, &self.depth_buffer);
    gl.deleteTextures(1, &self.white_texture);
    gl.deleteProgram(self.model_shader.program);
    gl.deleteProgram(self.ui_shader.program);
    gl.deleteProgram(self.transition_blink.program);
    gl.deleteProgram(self.transition_cross_fade.program);
    gl.deleteProgram(self.transition_in_and_out.program);
    gl.deleteProgram(self.transition_slice_bl_to_tr.program);
    gl.deleteProgram(self.transition_slice_tr_to_bl.program);
    gl.deleteVertexArrays(1, &self.model_vao);
    gl.deleteVertexArrays(1, &self.ui_vao);
    gl.deleteVertexArrays(1, &self.transition_vao);
    self.* = undefined;
}

pub fn beginFrame(self: *Self) void {
    gl.clearColor(1, 0, 1, 1);
    gl.clear(gl.COLOR_BUFFER_BIT);
}

pub fn endFrame(self: *Self) !void {
    try self.window.present();
}

pub fn clear(self: *Self, render_target: Renderer.RenderTarget, color: Color) void {
    self.bindRenderTarget(render_target);
    gl.clearColor(
        @intToFloat(f32, color.r) / 255.0,
        @intToFloat(f32, color.g) / 255.0,
        @intToFloat(f32, color.b) / 255.0,
        @intToFloat(f32, color.a) / 255.0,
    );
    gl.clear(gl.COLOR_BUFFER_BIT);
}

fn bindRenderTarget(self: *Self, render_target: Renderer.RenderTarget) void {
    if (render_target.backing_texture) |texture| {
        DSA.namedFramebufferTexture(
            self.frame_buffer,
            gl.COLOR_ATTACHMENT0,
            texture.renderer_detail,
            0,
        );

        const status = DSA.checkNamedFramebufferStatus(self.frame_buffer, gl.FRAMEBUFFER);
        if (status != gl.FRAMEBUFFER_COMPLETE) {
            const msg = switch (status) {
                gl.FRAMEBUFFER_UNDEFINED => "undefined",
                gl.FRAMEBUFFER_INCOMPLETE_ATTACHMENT => "incomplete attachment",
                gl.FRAMEBUFFER_INCOMPLETE_MISSING_ATTACHMENT => "incomplete missing attachment",
                gl.FRAMEBUFFER_INCOMPLETE_DRAW_BUFFER => "incomplete draw buffer",
                gl.FRAMEBUFFER_INCOMPLETE_READ_BUFFER => "incomplete read buffer",
                gl.FRAMEBUFFER_UNSUPPORTED => "unsupported",
                gl.FRAMEBUFFER_INCOMPLETE_MULTISAMPLE => "incomplete multisample",
                gl.FRAMEBUFFER_INCOMPLETE_LAYER_TARGETS => "incomplete layer targets",
                else => "unknown",
            };
            log.emerg("Incomplete framebuffer: {}\n", .{msg});
        }
        gl.bindFramebuffer(gl.FRAMEBUFFER, self.frame_buffer);
    } else {
        gl.bindFramebuffer(gl.FRAMEBUFFER, 0);
    }
}

pub fn submitUiPass(self: *Self, render_target: Renderer.RenderTarget, pass: Renderer.UiPass) !void {
    self.bindRenderTarget(render_target);
    gl.bindVertexArray(self.ui_vao);

    gl.enable(gl.BLEND);
    defer gl.disable(gl.BLEND);

    gl.blendFunc(gl.SRC_ALPHA, gl.ONE_MINUS_SRC_ALPHA);
    gl.blendEquation(gl.FUNC_ADD);

    var target_size = render_target.size();

    var temp_arena = std.heap.ArenaAllocator.init(self.allocator);
    defer temp_arena.deinit();

    const Segment = struct {
        primitive_type: gl.GLenum,
        start: usize,
        count: usize,
        texture: ?gl.GLuint,
    };

    const SegmentBuilder = struct {
        vertices: std.ArrayList(UiVertex),
        segments: std.ArrayList(Segment),
        current_texture: ?*Resources.Texture = null,

        fn segmentSize(comptime prim: gl.GLenum) usize {
            return switch (prim) {
                gl.LINES => 2,
                gl.TRIANGLES => 3,
                else => @compileError("Unsupported primitive type"),
            };
        }

        fn texEql(a: ?gl.GLuint, b: ?gl.GLuint) bool {
            if ((a == null) and (b == null))
                return true;
            if (a == null or b == null)
                return false;
            return a.? == b.?;
        }

        fn append(
            list: *@This(),
            comptime primitive_type: gl.GLenum,
            texture: ?gl.GLuint,
            vertices: [segmentSize(primitive_type)]UiVertex,
        ) !void {
            var current_segment = &list.segments.items[list.segments.items.len - 1];

            if (current_segment.count > 0 and !texEql(current_segment.texture, texture)) {
                current_segment = try list.segments.addOne();
                current_segment.* = Segment{
                    .primitive_type = primitive_type,
                    .start = list.vertices.items.len,
                    .count = 0,
                    .texture = texture,
                };
            } else if (current_segment.count == 0) {
                current_segment.primitive_type = primitive_type;
                current_segment.texture = texture;
            }

            for (vertices) |v| {
                try list.vertices.append(v);
            }

            current_segment.count += vertices.len;
        }

        fn blitImage(
            builder: *@This(),
            image: Resources.Texture,
            dest_rectangle: ui.Rectangle,
            src_rectangle: ?ui.Rectangle,
            tint: ?Color,
        ) !void {
            const x0 = @intCast(i16, dest_rectangle.x);
            const y0 = @intCast(i16, dest_rectangle.y);
            const x1 = @intCast(i16, dest_rectangle.x + @intCast(isize, dest_rectangle.width) - 1);
            const y1 = @intCast(i16, dest_rectangle.y + @intCast(isize, dest_rectangle.height) - 1);

            const src_rect: ui.Rectangle = if (src_rectangle) |r| r else ui.Rectangle{
                .x = 0,
                .y = 0,
                .width = image.width,
                .height = image.height,
            };

            const u_0 = @floatCast(f16, @intToFloat(f32, src_rect.x) / @intToFloat(f32, image.width - 1));
            const v_0 = @floatCast(f16, @intToFloat(f32, src_rect.y) / @intToFloat(f32, image.height - 1));
            const u_1 = @floatCast(f16, @intToFloat(f32, src_rect.x + @intCast(isize, src_rect.width) - 1) / @intToFloat(f32, image.width - 1));
            const v_1 = @floatCast(f16, @intToFloat(f32, src_rect.y + @intCast(isize, src_rect.height) - 1) / @intToFloat(f32, image.height - 1));

            const c = tint orelse Color{ .r = 0xFF, .g = 0xFF, .b = 0xFF, .a = 0xFF };

            const v00 = UiVertex{
                .x = x0,
                .y = y0,
                .u = u_0,
                .v = v_0,
                .r = c.r,
                .g = c.g,
                .b = c.b,
                .a = c.a,
            };
            const v10 = UiVertex{
                .x = x1,
                .y = y0,
                .u = u_1,
                .v = v_0,
                .r = c.r,
                .g = c.g,
                .b = c.b,
                .a = c.a,
            };

            const v01 = UiVertex{
                .x = x0,
                .y = y1,
                .u = u_0,
                .v = v_1,
                .r = c.r,
                .g = c.g,
                .b = c.b,
                .a = c.a,
            };
            const v11 = UiVertex{
                .x = x1,
                .y = y1,
                .u = u_1,
                .v = v_1,
                .r = c.r,
                .g = c.g,
                .b = c.b,
                .a = c.a,
            };

            try builder.append(gl.TRIANGLES, image.renderer_detail, [3]UiVertex{ v00, v01, v10 });
            try builder.append(gl.TRIANGLES, image.renderer_detail, [3]UiVertex{ v01, v10, v11 });
        }
    };

    var builder = SegmentBuilder{
        .vertices = std.ArrayList(UiVertex).init(&temp_arena.allocator),
        .segments = std.ArrayList(Segment).init(&temp_arena.allocator),
    };
    try builder.segments.append(Segment{
        .start = 0,
        .count = 0,
        .texture = null,
        .primitive_type = gl.NONE,
    });

    // no need to deinit() both lists as temp_arena will free the memory

    for (pass.drawcalls.items) |dc| {
        switch (dc) {
            .rectangle => |rectangle| {
                // @panic("TODO: not implemented yet!");
            },
            .line => |line| {
                try builder.append(gl.LINES, null, [2]UiVertex{
                    UiVertex{
                        .x = @intCast(i16, line.x0),
                        .y = @intCast(i16, line.y0),
                        .r = line.color.r,
                        .g = line.color.g,
                        .b = line.color.b,
                        .a = line.color.a,
                        .u = 0.5,
                        .v = 0.5,
                    },
                    UiVertex{
                        .x = @intCast(i16, line.x1),
                        .y = @intCast(i16, line.y1),
                        .r = line.color.r,
                        .g = line.color.g,
                        .b = line.color.b,
                        .a = line.color.a,
                        .u = 0.5,
                        .v = 0.5,
                    },
                });
            },
            .polygon => |polygon| {
                const base = UiVertex{
                    .x = @intCast(i16, polygon.points[0].x),
                    .y = @intCast(i16, polygon.points[0].y),
                    .r = polygon.color.r,
                    .g = polygon.color.g,
                    .b = polygon.color.b,
                    .a = polygon.color.a,
                    .u = 0.5,
                    .v = 0.5,
                };

                var previous = polygon.points[1];
                for (polygon.points[2..]) |current, index| {
                    defer previous = current;
                    try builder.append(gl.TRIANGLES, null, [3]UiVertex{
                        base,
                        UiVertex{
                            .x = @intCast(i16, previous.x),
                            .y = @intCast(i16, previous.y),
                            .r = polygon.color.r,
                            .g = polygon.color.g,
                            .b = polygon.color.b,
                            .a = polygon.color.a,
                            .u = 0.5,
                            .v = 0.5,
                        },
                        UiVertex{
                            .x = @intCast(i16, current.x),
                            .y = @intCast(i16, current.y),
                            .r = polygon.color.r,
                            .g = polygon.color.g,
                            .b = polygon.color.b,
                            .a = polygon.color.a,
                            .u = 0.5,
                            .v = 0.5,
                        },
                    });
                }
            },
            .image => |image| {
                try builder.blitImage(
                    image.image,
                    image.dest_rectangle,
                    image.src_rectangle,
                    null,
                );
            },
            .text => |text| {
                for (text.string) |c, i| {
                    try builder.blitImage(
                        text.font.texture,
                        ui.Rectangle{
                            .x = text.x + @intCast(isize, text.font.glyph_size.width * i),
                            .y = text.y,
                            .width = text.font.glyph_size.width,
                            .height = text.font.glyph_size.height,
                        },
                        ui.Rectangle{
                            .x = @intCast(isize, text.font.glyph_size.width * (c % 16)),
                            .y = @intCast(isize, text.font.glyph_size.height * (c / 16)),
                            .width = text.font.glyph_size.width,
                            .height = text.font.glyph_size.height,
                        },
                        text.color,
                    );
                }
            },
        }
    }

    if (builder.vertices.items.len > 0) {
        gl.useProgram(self.ui_shader.program);

        if (self.ui_shader.uScreenSize) |i|
            gl.uniform2i(
                i,
                @intCast(gl.GLint, target_size.width),
                @intCast(gl.GLint, target_size.height),
            );

        if (self.ui_shader.uTexture) |i|
            gl.uniform1i(i, 0);

        var buffer: gl.GLuint = 0;
        DSA.createBuffers(1, &buffer);
        if (buffer == 0)
            return error.OpenGlFailure;
        defer gl.deleteBuffers(1, &buffer);

        gl.GL_ARB_direct_state_access.namedBufferStorage(
            buffer,
            @intCast(isize, @sizeOf(UiVertex) * builder.vertices.items.len),
            builder.vertices.items.ptr,
            0,
        );

        DSA.vertexArrayVertexBuffer(self.ui_vao, BIND_VERTICES, buffer, 0, @sizeOf(UiVertex));
        defer DSA.vertexArrayVertexBuffer(self.ui_vao, BIND_VERTICES, 0, 0, @sizeOf(UiVertex));

        for (builder.segments.items) |segment| {
            DSA.bindTextureUnit(0, segment.texture orelse self.white_texture);
            gl.drawArrays(
                segment.primitive_type,
                @intCast(gl.GLint, segment.start),
                @intCast(gl.GLsizei, segment.count),
            );
        }
        DSA.bindTextureUnit(0, 0);
    }
}

pub fn submitScenePass(self: *Self, render_target: Renderer.RenderTarget, pass: Renderer.ScenePass) !void {
    self.bindRenderTarget(render_target);
    gl.bindVertexArray(self.model_vao);

    gl.clearDepth(1.0);
    gl.clear(gl.DEPTH_BUFFER_BIT);

    gl.enable(gl.DEPTH_TEST);
    defer gl.disable(gl.DEPTH_TEST);

    var target_size = render_target.size();

    var aspect = @intToFloat(f32, target_size.width) / @intToFloat(f32, target_size.height);

    var view_transform: zlm.Mat4 = zlm.Mat4.mul(
        zlm.Mat4.mul(
            zlm.Mat4.createLook(
                pass.camera.position,
                pass.camera.getForward(),
                zlm.vec3(0, 1, 0),
            ),
            zlm.Mat4.createPerspective(
                zlm.toRadians(60.0),
                aspect,
                0.1,
                10_000.0,
            ),
        ),
        zlm.Mat4.createScale(-1, 1, 1),
    );

    const resources = Renderer.fromImplementation(self).getResources();

    for (pass.drawcalls.items) |raw_drawcall| {
        switch (raw_drawcall) {
            .model => |drawcall| { // model, transform
                gl.useProgram(self.model_shader.program);

                if (self.model_shader.uAlbedoTexture) |i|
                    gl.uniform1i(i, 0);

                if (self.model_shader.uWorld) |i|
                    gl.uniformMatrix4fv(i, 1, gl.FALSE, @ptrCast([*]const f32, &drawcall.transform));

                if (self.model_shader.uViewProjection) |i|
                    gl.uniformMatrix4fv(i, 1, gl.FALSE, @ptrCast([*]const f32, &view_transform));

                DSA.vertexArrayElementBuffer(self.model_vao, drawcall.model.renderer_detail.index_buffer);
                DSA.vertexArrayVertexBuffer(self.model_vao, BIND_VERTICES, drawcall.model.renderer_detail.vertex_buffer, 0, @sizeOf(Resources.Model.Vertex));

                for (drawcall.model.meshes) |mesh| {
                    const texture = try resources.textures.get(
                        try resources.textures.getName(mesh.texture()),
                        Resources.usage.level_render,
                    );

                    DSA.bindTextureUnit(0, texture.renderer_detail);

                    gl.drawElements(
                        gl.TRIANGLES,
                        @intCast(gl.GLsizei, 3 * mesh.length),
                        switch (@sizeOf(Resources.Model.Index)) {
                            1 => gl.UNSIGNED_BYTE,
                            2 => gl.UNSIGNED_SHORT,
                            4 => gl.UNSIGNED_INT,
                            else => @compileError("Invalid index type. Please use u8, u16 or u32"),
                        },
                        @intToPtr([*]allowzero u8, @sizeOf(Resources.Model.Index) * 3 * mesh.offset), // calculate the correct offset for the model
                    );
                }
                DSA.bindTextureUnit(0, 0);
            },
        }
    }
}

pub fn submitTransition(self: *Self, render_target: Renderer.RenderTarget, transition: Renderer.Transition) !void {
    self.bindRenderTarget(render_target);

    const target_size = render_target.size();

    gl.bindVertexArray(self.transition_vao);

    var shader = switch (transition.style) {
        .blink => self.transition_blink,
        .cross_fade => self.transition_cross_fade,
        .in_and_out => self.transition_in_and_out,
        .slice_bl_to_tr => self.transition_slice_bl_to_tr,
        .slice_tr_to_bl => self.transition_slice_tr_to_bl,
    };

    gl.useProgram(shader.program);

    if (shader.uScreenSize) |i|
        gl.uniform2i(
            i,
            @intCast(gl.GLint, target_size.width),
            @intCast(gl.GLint, target_size.height),
        );

    if (shader.uFrom) |i| gl.uniform1i(i, 0);
    if (shader.uTo) |i| gl.uniform1i(i, 1);
    if (shader.uProgress) |i| gl.uniform1f(i, std.math.clamp(transition.progress, 0.0, 1.0));

    DSA.bindTextureUnit(0, transition.from.renderer_detail);
    DSA.bindTextureUnit(1, transition.to.renderer_detail);

    defer DSA.bindTextureUnit(0, 0); // don't forget to unbind the texture
    defer DSA.bindTextureUnit(1, 0); // don't forget to unbind the texture

    gl.drawArrays(gl.TRIANGLE_STRIP, 0, 4);
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
        gl.RGBA,
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

    gl.GL_ARB_direct_state_access.namedBufferStorage(
        ids[0],
        @intCast(isize, @sizeOf(Resources.Model.Vertex) * model.vertices.len),
        model.vertices.ptr,
        0,
    );

    gl.GL_ARB_direct_state_access.namedBufferStorage(
        ids[1],
        @intCast(isize, @sizeOf(Resources.Model.Index) * model.indices.len),
        model.indices.ptr,
        0,
    );

    return Model{
        .vertex_buffer = ids[0],
        .index_buffer = ids[1],
    };
}

pub fn destroyModel(self: *Self, model: *Model) void {
    var ids = [2]gl.GLuint{ model.vertex_buffer, model.index_buffer };
    gl.deleteBuffers(2, &ids);
}

fn debugCallback(source: gl.GLenum, msg_type: gl.GLenum, id: gl.GLuint, severity: gl.GLenum, length: gl.GLsizei, opt_message: ?[*:0]const u8, userParam: ?*c_void) callconv(.C) void {
    // std.debug.print("{} {} {} {} {} {*} {}:\n", .{
    //     source, msg_type, id, severity, length, message, userParam,
    // });
    if (opt_message) |message| {
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

        if (std.builtin.mode == .Debug) {
            switch (severity) {
                gl.GL_KHR_debug.DEBUG_SEVERITY_HIGH,
                gl.GL_KHR_debug.DEBUG_SEVERITY_MEDIUM,
                gl.GL_KHR_debug.DEBUG_SEVERITY_LOW,
                => {
                    std.debug.dumpCurrentStackTrace(null);
                    @panic("Critical OpenGL error detected. Stopping");
                },
                else => {},
            }
        }
    } else {
        const msg = "OpenGL debug message without content";
        const args = .{};
        switch (severity) {
            gl.GL_KHR_debug.DEBUG_SEVERITY_HIGH => log.emerg(msg, args),
            gl.GL_KHR_debug.DEBUG_SEVERITY_MEDIUM => log.warn(msg, args),
            gl.GL_KHR_debug.DEBUG_SEVERITY_LOW => log.info(msg, args),
            gl.GL_KHR_debug.DEBUG_SEVERITY_NOTIFICATION => log.notice(msg, args),
            else => log.debug("(severity: 0x{X:0>4}) " ++ msg, .{severity} ++ args),
        }
    }
}

fn compileShader(allocator: *std.mem.Allocator, comptime Shader: type, vertex_source: [:0]const u8, fragment_source: [:0]const u8) !Shader {
    var shader: Shader = Shader{
        .program = undefined,
    };

    var vertex_shader = try compilerShaderPart(allocator, gl.VERTEX_SHADER, vertex_source);
    defer gl.deleteShader(vertex_shader);

    var fragment_shader = try compilerShaderPart(allocator, gl.FRAGMENT_SHADER, fragment_source);
    defer gl.deleteShader(fragment_shader);

    shader.program = gl.createProgram();
    if (shader.program == 0)
        return error.OpenGlFailure;
    errdefer gl.deleteProgram(shader.program);

    gl.attachShader(shader.program, vertex_shader);
    defer gl.detachShader(shader.program, vertex_shader);

    gl.attachShader(shader.program, fragment_shader);
    defer gl.detachShader(shader.program, fragment_shader);

    gl.linkProgram(shader.program);

    var link_status: gl.GLint = undefined;
    gl.getProgramiv(shader.program, gl.LINK_STATUS, &link_status);

    if (link_status != gl.TRUE) {
        var info_log_length: gl.GLint = undefined;
        gl.getProgramiv(shader.program, gl.INFO_LOG_LENGTH, &info_log_length);

        const info_log = try allocator.alloc(u8, @intCast(usize, info_log_length));
        defer allocator.free(info_log);

        gl.getProgramInfoLog(shader.program, @intCast(c_int, info_log.len), null, info_log.ptr);

        log.info("failed to compile shader:\n{}", .{info_log});

        return error.InvalidShader;
    }

    var uniform_count: gl.GLint = undefined;
    gl.getProgramiv(shader.program, gl.ACTIVE_UNIFORMS, &uniform_count);

    var i: gl.GLuint = 0;
    while (i < uniform_count) : (i += 1) {
        var name_buffer: [512]u8 = undefined; // 512 chars are enough for everyone!

        var actual_len: gl.GLsizei = 0;
        var uniform_size: gl.GLint = 0;
        var uniform_type: gl.GLenum = 0;
        gl.getActiveUniform(
            shader.program,
            i,
            name_buffer.len,
            &actual_len,
            &uniform_size,
            &uniform_type,
            &name_buffer,
        );
        const uniform_name = name_buffer[0..@intCast(usize, actual_len)];

        inline for (std.meta.fields(Shader)) |fld| {
            if (comptime !std.mem.eql(u8, fld.name, "program")) {
                if (std.mem.eql(u8, fld.name, uniform_name)) {
                    @field(shader, fld.name) = @intCast(gl.GLint, i);
                }
            }
        }
    }

    return shader;
}

fn compilerShaderPart(allocator: *std.mem.Allocator, shader_type: gl.GLenum, source: [:0]const u8) !gl.GLuint {
    var shader = gl.createShader(shader_type);
    if (shader == 0)
        return error.OpenGlFailure;
    errdefer gl.deleteShader(shader);

    var sources = [_][*c]const u8{source.ptr};
    var lengths = [_]gl.GLint{@intCast(gl.GLint, source.len)};

    gl.shaderSource(shader, 1, &sources, &lengths);

    gl.compileShader(shader);

    var compile_status: gl.GLint = undefined;
    gl.getShaderiv(shader, gl.COMPILE_STATUS, &compile_status);

    if (compile_status != gl.TRUE) {
        var info_log_length: gl.GLint = undefined;
        gl.getShaderiv(shader, gl.INFO_LOG_LENGTH, &info_log_length);

        const info_log = try allocator.alloc(u8, @intCast(usize, info_log_length));
        defer allocator.free(info_log);

        gl.getShaderInfoLog(shader, @intCast(c_int, info_log.len), null, info_log.ptr);

        log.info("failed to compile shader:\n{}", .{info_log});

        return error.InvalidShader;
    }

    return shader;
}
