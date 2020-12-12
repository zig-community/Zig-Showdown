const std = @import("std");
const vk = @import("vulkan");

const Device = @import("Device.zig");
const Swapchain = @import("Device.zig");
const VulkanRenderer = @import("VulkanRenderer.zig");

const asManyPtr = @import("util.zig").asManyPtr;

//! The PostProcessPipeline always renders to the final swap image.
//! To do that, this pipeline needs its own render pass, as this render pass
//! needs to output an image in present_src_khr, and doesn't require a depth
//! buffer either.

pub const Self = @This();

/// This pipeline's render pass is different from the common case, so it has its own
render_pass: vk.RenderPass,

/// Swapchain framebuffers
framebuffers: []vk.Framebuffer,

pipeline_layout: vk.PipelineLayout,

pub fn init(r: *VulkanRenderer) !void {
    const self = &r.post_process_pipeline;
    self.* = .{
        .render_pass = .null_handle,
        .framebuffers = try r.allocator.alloc(vk.Framebuffer, 0),
        .pipeline_layout = .null_handle,
    };
    errdefer deinit(r);

    try self.initRenderPass(r);
    try self.initFramebuffers(r);
    try self.initPipelineLayout(r);
}

pub fn deinit(r: *VulkanRenderer) void {
    const self = &r.post_process_pipeline;
    r.device.vkd.destroyPipelineLayout(r.device.handle, self.pipeline_layout, null);

    for (self.framebuffers) |fb| {
        r.device.vkd.destroyFramebuffer(r.device.handle, fb, null);
    }

    r.allocator.free(self.framebuffers);
    r.device.vkd.destroyRenderPass(r.device.handle, self.render_pass, null);
}

fn initRenderPass(self: *Self, r: *VulkanRenderer) !void {
    const color_attachment = vk.AttachmentDescription{
        .flags = .{},
        .format = r.swapchain.surface_format.format,
        .samples = .{.@"1_bit" = true},
        .load_op = .clear,
        .store_op = .store,
        .stencil_load_op = .dont_care,
        .stencil_store_op = .dont_care,
        .initial_layout = .@"undefined",
        .final_layout = .present_src_khr,
    };

    const color_attachment_ref = vk.AttachmentReference{
        .attachment = 0,
        .layout = .color_attachment_optimal,
    };

    const subpass = vk.SubpassDescription{
        .flags = .{},
        .pipeline_bind_point = .graphics,
        .input_attachment_count = 0,
        .p_input_attachments = undefined,
        .color_attachment_count = 1,
        .p_color_attachments = asManyPtr(&color_attachment_ref),
        .p_resolve_attachments = null,
        .p_depth_stencil_attachment = null,
        .preserve_attachment_count = 0,
        .p_preserve_attachments = undefined,
    };

    self.render_pass = try r.device.vkd.createRenderPass(r.device.handle, .{
        .flags = .{},
        .attachment_count = 1,
        .p_attachments = asManyPtr(&color_attachment),
        .subpass_count = 1,
        .p_subpasses = asManyPtr(&subpass),
        .dependency_count = 0,
        .p_dependencies = undefined,
    }, null);
}

fn initFramebuffers(self: *Self, r: *VulkanRenderer) !void {
    // TODO: Delete currently existing framebuffers (if any)
    self.framebuffers = try r.allocator.alloc(vk.Framebuffer, r.swapchain.images.len);
    std.mem.set(vk.Framebuffer, self.framebuffers, .null_handle);

    // We don't need errdefer in this function, its handled in deinit(), and by
    // the fact that self.framebuffers is set to null_handle

    for (self.framebuffers) |*fb, i| {
        fb.* = try r.device.vkd.createFramebuffer(r.device.handle, .{
            .flags = .{},
            .render_pass = self.render_pass,
            .attachment_count = 1,
            .p_attachments = asManyPtr(&r.swapchain.image_views[i]),
            .width = r.swapchain.extent.width,
            .height = r.swapchain.extent.height,
            .layers = 1,
        }, null);
    }
}

fn initPipelineLayout(self: *Self, r: *VulkanRenderer) !void {
    self.pipeline_layout = try r.device.vkd.createPipelineLayout(r.device.handle, .{
        .flags = .{},
        .set_layout_count = 0,
        .p_set_layouts = undefined,
        .push_constant_range_count = 0,
        .p_push_constant_ranges = undefined,
    }, null);
}
