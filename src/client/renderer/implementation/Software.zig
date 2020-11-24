//! The software renderer is the reference backend
//! for rendering Zig SHOWDOWN.
//!
//! Most types are empty or NO-OPs, but documented on how they
//! are supposed to work and what their purpose is.

const std = @import("std");
const zwl = @import("zwl");
const painterz = @import("painterz");
const draw = @import("pixel_draw");
const math = @import("../../math.zig");

const WindowPlatform = @import("root").WindowPlatform;

const Color = @import("../Color.zig");

const Self = @This();

const Resources = @import("../../Resources.zig");
const Renderer = @import("../../Renderer.zig");

fn toNativeColor(c: Color) zwl.Pixel {
    return zwl.Pixel{
        .r = c.r,
        .g = c.g,
        .b = c.b,
        .a = c.a,
    };
}

allocator: *std.mem.Allocator,
window: *WindowPlatform.Window,
pixbuf: ?zwl.PixelBuffer,

z_buffer: []f32,

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

    var fb = Self{
        .allocator = allocator,
        .window = window,
        .pixbuf = null,
        .z_buffer = undefined,
    };

    fb.z_buffer = try allocator.alloc(f32, 0);
    errdefer allocator.free(fb.z_buffer);

    return fb;
}

/// Destroys a previously created rendering instance.
pub fn deinit(self: *Self) void {
    self.allocator.free(self.z_buffer);
}

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

fn getPixBuf(self: *Self, rt: Renderer.RenderTarget) zwl.PixelBuffer {
    return if (rt.backing_texture) |tex|
        zwl.PixelBuffer{
            .data = @ptrCast([*]u32, tex.pixels.ptr),
            .width = @intCast(u16, tex.width),
            .height = @intCast(u16, tex.height),
        }
    else
        self.pixbuf.?;
}

pub fn clear(self: *Self, rt: Renderer.RenderTarget, color: Color) void {
    std.debug.assert(self.pixbuf != null);
    const pixel_value = zwl.Pixel{
        .r = color.r,
        .g = color.g,
        .b = color.b,
        .a = color.a,
    };
    const pixbuf = self.getPixBuf(rt);

    std.mem.set(u32, pixbuf.span(), @bitCast(u32, pixel_value));
}

pub fn submitUiPass(self: *Self, render_target: Renderer.RenderTarget, pass: Renderer.UiPass) !void {
    const Impl = struct {
        fn setPixel(buffer: zwl.PixelBuffer, x: isize, y: isize, col: Color) void {
            const ncol = toNativeColor(col);

            buffer.setPixel(@intCast(u16, x), @intCast(u16, y), toNativeColor(col));
        }

        const ColorData = struct {
            font: Resources.Font,
            color: Color,
        };
        fn fetchFontPixel(data: ColorData, ix: isize, iy: isize) ?Color {
            const x = std.math.cast(usize, ix) catch return null;
            const y = std.math.cast(usize, iy) catch return null;
            if (x >= data.font.texture.width or y >= data.font.texture.height) return null;

            return if (data.font.texture.pixels[data.font.texture.width * y + x].a >= 0x80)
                data.color
            else
                null;
        }

        fn fetchImagePixel(font: Resources.Texture, ix: isize, iy: isize) ?Color {
            const x = std.math.cast(usize, ix) catch return null;
            const y = std.math.cast(usize, iy) catch return null;
            if (x >= font.width or y >= font.height) return null;

            if (font.pixels[font.width * y + x].a < 0x80)
                return null;

            return Color{
                .r = font.pixels[font.width * y + x].r,
                .g = font.pixels[font.width * y + x].g,
                .b = font.pixels[font.width * y + x].b,
                .a = font.pixels[font.width * y + x].a,
            };
        }
    };
    const Canvas = painterz.Canvas(zwl.PixelBuffer, Color, Impl.setPixel);

    const pixbuf = self.getPixBuf(render_target);
    var canvas = Canvas.init(pixbuf);

    for (pass.drawcalls.items) |dc| {
        switch (dc) {
            .rectangle => |rectangle| {
                @panic("TODO: not implemented yet!");
            },
            .line => |line| {
                const Context = struct {
                    target: zwl.PixelBuffer,
                    width: u8,
                };

                const LineCanvas = painterz.Canvas(Context, Color, struct {
                    fn setPixel(context: Context, sx: isize, sy: isize, col: Color) void {
                        const ncol = toNativeColor(col);
                        const limit = @as(isize, context.width) * @as(isize, context.width);

                        var ry: isize = -@as(isize, context.width);
                        while (ry <= @as(isize, context.width)) : (ry += 1) {
                            var rx: isize = -@as(isize, context.width);
                            while (rx <= @as(isize, context.width)) : (rx += 1) {
                                const x = sx + rx;
                                const y = sy + ry;

                                if (x < 0 or y < 0 or x >= context.target.width or y >= context.target.height)
                                    continue;
                                if (rx * rx + ry * ry > limit)
                                    continue;

                                context.target.setPixel(@intCast(u16, x), @intCast(u16, y), ncol);
                            }
                        }
                    }
                }.setPixel);

                var line_canvas = LineCanvas.init(Context{
                    .target = pixbuf,
                    .width = line.thickness,
                });

                line_canvas.drawLine(line.x0, line.y0, line.x1, line.y1, line.color);
            },
            .polygon => |polygon| {
                canvas.fillPolygon(0, 0, polygon.color, Renderer.UiPass.Point, polygon.points);
            },
            .image => |image| {
                const src_rect = if (image.src_rectangle) |r| r else Renderer.UiPass.Rectangle{
                    .x = 0,
                    .y = 0,
                    .width = image.image.width,
                    .height = image.image.height,
                };

                canvas.copyRectangleStretched(
                    image.dest_rectangle.x,
                    image.dest_rectangle.y,
                    image.dest_rectangle.width,
                    image.dest_rectangle.height,
                    src_rect.x,
                    src_rect.y,
                    src_rect.width,
                    src_rect.height,
                    true,
                    image.image,
                    Impl.fetchImagePixel,
                );
            },
            .text => |text| {
                for (text.string) |c, i| {
                    canvas.copyRectangle(
                        text.x + @intCast(isize, text.font.glyph_size.width * i),
                        text.y,
                        @intCast(isize, text.font.glyph_size.width * (c % 16)),
                        @intCast(isize, text.font.glyph_size.height * (c / 16)),
                        text.font.glyph_size.width,
                        text.font.glyph_size.height,
                        true,
                        Impl.ColorData{
                            .font = text.font,
                            .color = text.color,
                        },
                        Impl.fetchFontPixel,
                    );
                }
            },
        }
    }
}

pub fn submitScenePass(self: *Self, render_target: Renderer.RenderTarget, pass: Renderer.ScenePass) !void {
    const pixbuf = self.getPixBuf(render_target);

    var b = draw.Buffer{
        .width = pixbuf.width,
        .height = pixbuf.height,
        .screen = std.mem.sliceAsBytes(pixbuf.span()),
        .depth = undefined, // oh no
    };
    if (self.z_buffer.len != b.screen.len) {
        self.z_buffer = try self.allocator.realloc(self.z_buffer, b.screen.len);
    }
    b.depth = self.z_buffer;

    // // Clear the z-buffer
    std.mem.set(f32, self.z_buffer, std.math.inf(f32));

    const resources = @fieldParentPtr(Renderer, "implementation", self).resources orelse @panic("resources must be set before rendering!");

    for (pass.drawcalls.items) |dc| {
        switch (dc) {
            .model => |drawcall| {
                for (drawcall.model.meshes) |mesh, ind| {
                    const texture_id = try resources.textures.getName(mesh.texture()); // this is not optimal,but okayish
                    const texture = try resources.textures.get(texture_id, Resources.usage.generic_render);

                    // ugly workaround to draw meshes with pixel_draw:
                    // converts between immutable data and mutable data
                    var index: usize = 3 * mesh.offset;
                    while (index < 3 * (mesh.offset + mesh.length)) : (index += 3) {
                        var vertices: [3]draw.Vertex = undefined;
                        for (vertices) |*dv, i| {
                            const sv = drawcall.model.vertices[drawcall.model.indices[index + i]];
                            dv.* = draw.Vertex{
                                .pos = .{
                                    .x = sv.x,
                                    .y = sv.y,
                                    .z = sv.z,
                                },
                                .uv = .{
                                    .x = sv.u,
                                    .y = sv.v,
                                },
                            };
                        }
                        var indices = [3]u32{ 0, 1, 2 };

                        var temp_mesh = draw.Mesh{
                            .v = &vertices,
                            .i = &indices,
                            .texture = texture.toPixelDraw(),
                        };

                        b.drawMesh(temp_mesh, .Texture, drawcall.transform);
                    }
                }
            },
        }
    }
}

pub fn submitTransition(self: *Self, render_target: Renderer.RenderTarget, transition: Renderer.Transition) !void {
    const Impl = struct {
        /// Renders a transition between `src_from` and `src_to` with `progress` percent between `0.0` and `1.0` using
        /// the given transition
        pub fn render(src_from: zwl.PixelBuffer, src_to: zwl.PixelBuffer, dest: zwl.PixelBuffer, progress: f32, style: Renderer.Transition.Style) void {
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
    };

    const target_pixbuf = self.getPixBuf(render_target);

    var pix_from = zwl.PixelBuffer{
        .width = @intCast(u16, transition.from.width),
        .height = @intCast(u16, transition.from.height),
        .data = @ptrCast([*]u32, transition.from.pixels.ptr),
    };

    var pix_to = zwl.PixelBuffer{
        .width = @intCast(u16, transition.to.width),
        .height = @intCast(u16, transition.to.height),
        .data = @ptrCast([*]u32, transition.to.pixels.ptr),
    };

    Impl.render(
        pix_from,
        pix_to,
        target_pixbuf,
        transition.progress,
        transition.style,
    );
}
