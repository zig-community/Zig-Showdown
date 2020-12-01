const std = @import("std");
const zwl = @import("zwl");
const gl = @import("gl");
const zlm = @import("zlm");

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

const ModelShader = struct {
    program: gl.GLuint,

    uWorld: ?gl.GLint = null,
    uViewProjection: ?gl.GLint = null,
    uAlbedoTexture: ?gl.GLint = null,
};

const VA_POSITION = 0;
const VA_NORMAL = 1;
const VA_UV = 2;

const BIND_VERTICES = 0;

window: *WindowPlatform.Window,

frame_buffer: gl.GLuint,

model_vao: gl.GLuint,
model_shader: ModelShader,

depth_buffer: gl.GLuint,

pub fn init(allocator: *std.mem.Allocator, window: *WindowPlatform.Window) !Self {
    try gl.load(window.platform, WindowPlatform.getOpenGlProcAddress);

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

    // // And in debug builds, enable synchronous output for stack traces:
    // if (std.builtin.mode == .Debug) {
    //     gl.enable(gl.GL_KHR_debug.DEBUG_OUTPUT_SYNCHRONOUS);
    // }

    const model_vao = blk: {
        var vao: gl.GLuint = 0;
        DSA.createVertexArrays(1, &vao);
        if (vao == 0)
            return error.OpenGlFailure;
        errdefer DSA.deleteVertexArrays(1, &vao);

        DSA.enableVertexArrayAttrib(vao, VA_POSITION);
        DSA.enableVertexArrayAttrib(vao, VA_NORMAL);
        DSA.enableVertexArrayAttrib(vao, VA_UV);

        DSA.vertexArrayAttribFormat(
            vao,
            VA_POSITION,
            3,
            gl.FLOAT,
            gl.FALSE,
            @byteOffsetOf(Resources.Model.Vertex, "x"),
        );
        DSA.vertexArrayAttribFormat(
            vao,
            VA_NORMAL,
            3,
            gl.BYTE,
            gl.TRUE,
            @byteOffsetOf(Resources.Model.Vertex, "nx"),
        );
        DSA.vertexArrayAttribFormat(
            vao,
            VA_UV,
            2,
            gl.FLOAT,
            gl.FALSE,
            @byteOffsetOf(Resources.Model.Vertex, "u"),
        );

        DSA.vertexArrayAttribBinding(vao, VA_POSITION, BIND_VERTICES);
        DSA.vertexArrayAttribBinding(vao, VA_NORMAL, BIND_VERTICES);
        DSA.vertexArrayAttribBinding(vao, VA_UV, BIND_VERTICES);

        break :blk vao;
    };
    errdefer gl.deleteVertexArrays(1, &model_vao);

    var model_shader = try compileShader(
        allocator,
        ModelShader,
        @embedFile("opengl/model.vert"),
        @embedFile("opengl/model.frag"),
    );
    errdefer gl.deleteProgram(model_shader.program);

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

    return Self{
        .window = window,
        .model_vao = model_vao,
        .model_shader = model_shader,
        .frame_buffer = rt_fb,
        .depth_buffer = depth_buffer,
    };
}

pub fn deinit(self: *Self) void {
    gl.deleteFramebuffers(1, &self.frame_buffer);
    gl.deleteRenderbuffers(1, &self.depth_buffer);
    gl.deleteProgram(self.model_shader.program);
    gl.deleteVertexArrays(1, &self.model_vao);
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
}

pub fn submitScenePass(self: *Self, render_target: Renderer.RenderTarget, pass: Renderer.ScenePass) !void {
    self.bindRenderTarget(render_target);

    gl.clearDepth(1.0);
    gl.clear(gl.DEPTH_BUFFER_BIT);

    gl.enable(gl.DEPTH_TEST);
    defer gl.disable(gl.DEPTH_TEST);

    gl.bindVertexArray(self.model_vao);

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
            },
        }
    }
}

pub fn submitTransition(self: *Self, render_target: Renderer.RenderTarget, transition: Renderer.Transition) !void {
    self.bindRenderTarget(render_target);
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
