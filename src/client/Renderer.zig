const std = @import("std");
const zwl = @import("zwl");
const build_options = @import("build_options");

const WindowPlatform = @import("root").WindowPlatform;
const Resources = @import("Resources.zig");

const Self = @This();

const Implementation = switch (build_options.render_backend) {
    .software => @import("renderer/implementation/Software.zig"),
    else => @compileError("The render backend " ++ @tagName(build_options.render_backend) ++ " is not implemented yet!"),
};

pub const Color = @import("renderer/Color.zig");
pub const ScenePass = @import("renderer/ScenePass.zig");
pub const UiPass = @import("renderer/UiPass.zig");
pub const RenderTarget = @import("renderer/RenderTarget.zig");

pub const Size = struct {
    width: usize,
    height: usize,
};

allocator: *std.mem.Allocator,
window: *WindowPlatform.Window,
implementation: Implementation,
resources: ?*Resources,

/// Initializes a new rendering backend instance for the given window.
pub fn init(allocator: *std.mem.Allocator, window: *WindowPlatform.Window) !Self {
    return Self{
        .allocator = allocator,
        .window = window,
        .resources = null,
        .implementation = try Implementation.init(allocator, window),
    };
}

/// Destroys a previously created rendering instance.
pub fn deinit(self: *Self) void {
    self.implementation.deinit();
    self.* = undefined;
}

/// Returns the size of the screen.
pub fn screenSize(self: Self) Size {
    const size = self.window.getSize();
    return Size{
        .width = size[0],
        .height = size[1],
    };
}

/// Starts to render a new frame. This is meant as a notification
/// event to prepare a newly rendered frame.
/// Each call must be followed by draw calls and finally by a call to
/// `endFrame()`.
pub fn beginFrame(self: *Self) !void {
    return self.implementation.beginFrame();
}

/// Clears the given RenderTarget to the color.
pub fn clear(self: *Self, rt: RenderTarget, color: Color) void {
    return self.implementation.clear(rt, color);
}

/// Creates a new UiPass.
pub fn createUiPass(self: *Self) UiPass {
    return UiPass.init(self.allocator);
}

/// Creates a new ScenePass.
pub fn createScenePass(self: *Self) ScenePass {
    return ScenePass.init(self.allocator);
}

pub fn submit(self: *Self, render_target: RenderTarget, pass: anytype) !void {
    const T = @TypeOf(pass);
    switch (T) {
        UiPass => try self.implementation.submitUiPass(render_target, pass),
        ScenePass => try self.implementation.submitScenePass(render_target, pass),

        else => @compileError("Renderer.submit can not process " ++ @typeName(T) ++ "!"),
    }
}

/// Finishes the frame and pushes the resulting image to the screen.
pub fn endFrame(self: *Self) !void {
    return self.implementation.endFrame();
}

pub fn screen(self: *Self) RenderTarget {
    return RenderTarget{
        .renderer = self,
        .backing_texture = null,
    };
}

/// Creates a new in-memory texture.
pub fn createRenderTarget(self: *Self, size: ?Size) !RenderTarget {
    return RenderTarget{
        .renderer = self,
        .backing_texture = try Resources.Texture.create(
            self,
            self.allocator,
            if (size) |s| s.width else 1280, // TODO: THIS IS NOT GOOD
            if (size) |s| s.height else 720, // TODO: THIS IS NOT GOOD
        ),
    };
}

pub const details = struct {
    /// this is a internal representation of the Resources.Texture
    /// type and may be used to store the renderer-specific data structure
    /// like OpenGL texture id.
    pub const Texture = if (@hasDecl(Implementation, "Texture")) Implementation.Texture else void;

    /// this is a internal representation of the Resources.Model
    /// type and may be used to store the renderer-specific data structure
    /// like OpenGL vertex and index buffer ids.
    pub const Model = if (@hasDecl(Implementation, "Model")) Implementation.Model else void;

    /// Create the renderer dependent texture type.
    /// Texture data is provided via the passed in parameter.
    pub fn createTexture(self: *Self, texture: *Resources.Texture) !Texture {
        if (Texture != void)
            return self.implementation.createTexture(texture);
    }

    /// Destroy the renderer dependent texture type.
    pub fn destroyTexture(self: *Self, texture: *Texture) void {
        if (Texture != void)
            return self.implementation.destroyTexture(texture);
    }

    /// Create the renderer dependent model type.
    /// Model data is provided via the passed in parameter.
    pub fn createModel(self: *Self, model: *Resources.Model) !Model {
        if (Model != void)
            return self.implementation.createModel(model);
    }

    /// Destroy the renderer dependent model type.
    pub fn destroyModel(self: *Self, model: *Model) void {
        if (Model != void)
            self.implementation.destroyModel(model);
    }
};
