//! The software renderer is the reference backend
//! for rendering Zig SHOWDOWN.
//!
//! Most types are empty or NO-OPs, but documented on how they
//! are supposed to work and what their purpose is.

const std = @import("std");

const Resources = @import("../Resources.zig");

/// this is a internal representation of the Resources.Texture
/// type and may be used to store the renderer-specific data structure
/// like OpenGL texture id.
pub const Texture = void;

/// Create the renderer dependent texture type.
/// Texture data is provided via the passed in parameter.
pub fn createTexture(model: *Resources.Texture) !Texture {
    return {};
}

/// Destroy the renderer dependent texture type.
pub fn destroyTexture(model: *Texture) void {}

/// this is a internal representation of the Resources.Model
/// type and may be used to store the renderer-specific data structure
/// like OpenGL vertex and index buffer ids.
pub const Model = void;

/// Create the renderer dependent model type.
/// Model data is provided via the passed in parameter.
pub fn createModel(model: *Resources.Model) !Model {
    return {};
}

/// Destroy the renderer dependent model type.
pub fn destroyModel(model: *Model) void {}
