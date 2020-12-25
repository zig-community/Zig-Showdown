const std = @import("std");
const vk = @import("vulkan");
const shaders = @import("showdown-vulkan-shaders");

const Device = @import("Device.zig");
const Swapchain = @import("Device.zig");
const VulkanRenderer = @import("VulkanRenderer.zig");

const asManyPtr = @import("util.zig").asManyPtr;

//! To keep everything nice in the rest of the implementation, the 'screen' framebuffer
//! actually refers to an internal regular framebuffer, backed by an image. In the final
//! pass (this pass), this framebuffer is then copied to the swapchain image, and post-
//! processing is applied simultaneously.
//! The PostProcessPipeline always renders to the final swap image.
//! To do that, this pipeline needs its own render pass and Vulkan framebuffers, as this
//! render pass needs to output an image in present_src_khr, and doesn't require a depth
//! buffer either.

pub const Self = @This();

/// This pipeline's render pass is different from the common case, so it has its own
render_pass: vk.RenderPass,

/// Swapchain framebuffers
framebuffers: []vk.Framebuffer,

pipeline_layout: vk.PipelineLayout,
pipeline: vk.Pipeline,

pub fn init(r: *VulkanRenderer) !Self {
    var self = Self{
        .render_pass = .null_handle,
        .framebuffers = try r.allocator.alloc(vk.Framebuffer, 0),
        .pipeline_layout = .null_handle,
        .pipeline = .null_handle,
    };
    errdefer self.deinit(r);

    try self.initRenderPass(r);
    try self.initFramebuffers(r);
    try self.initPipelineLayout(r);
    try self.initPipeline(r);

    return self;
}

pub fn deinit(self: Self, r: *const VulkanRenderer) void {
    r.device.vkd.destroyPipeline(r.device.handle, self.pipeline, null);
    r.device.vkd.destroyPipelineLayout(r.device.handle, self.pipeline_layout, null);

    for (self.framebuffers) |fb| {
        r.device.vkd.destroyFramebuffer(r.device.handle, fb, null);
    }

    r.allocator.free(self.framebuffers);
    r.device.vkd.destroyRenderPass(r.device.handle, self.render_pass, null);
}

pub fn draw(self: *Self, r: *VulkanRenderer, cmd_buf: vk.CommandBuffer) !void {
    r.device.vkd.cmdBeginRenderPass(cmd_buf, .{
        .render_pass = self.render_pass,
        .framebuffer = self.framebuffers[r.swapchain.image_index],
        .render_area = .{
            .offset = .{.x = 0, .y = 0},
            .extent = r.swapchain.extent,
        },
        .clear_value_count = 0,
        .p_clear_values = undefined,
    }, .@"inline");
    r.device.vkd.cmdBindPipeline(cmd_buf, .graphics, self.pipeline);
    r.device.vkd.cmdDraw(cmd_buf, 3, 1, 0, 0);
    r.device.vkd.cmdEndRenderPass(cmd_buf);
}

fn initRenderPass(self: *Self, r: *VulkanRenderer) !void {
    const color_attachment = vk.AttachmentDescription{
        .flags = .{},
        .format = r.swapchain.surface_format.format,
        .samples = .{.@"1_bit" = true},
        .load_op = .dont_care, // Fullscreen quad overwrites everything
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
    // TODO: Delete currently existing framebuffers (if any) when resizing
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

fn initPipeline(self: *Self, r: *VulkanRenderer) !void {
    const vert = try r.device.vkd.createShaderModule(r.device.handle, .{
        .flags = .{},
        .code_size = shaders.post_process_vert.len,
        .p_code = @ptrCast([*]const u32, shaders.post_process_vert),
    }, null);
    defer r.device.vkd.destroyShaderModule(r.device.handle, vert, null);

    const frag = try r.device.vkd.createShaderModule(r.device.handle, .{
        .flags = .{},
        .code_size = shaders.post_process_frag.len,
        .p_code = @ptrCast([*]const u32, shaders.post_process_frag),
    }, null);
    defer r.device.vkd.destroyShaderModule(r.device.handle, frag, null);

    const pssci = [_]vk.PipelineShaderStageCreateInfo {
        .{
            .flags = .{},
            .stage = .{.vertex_bit = true},
            .module = vert,
            .p_name = "main",
            .p_specialization_info = null,
        },
        .{
            .flags = .{},
            .stage = .{.fragment_bit = true},
            .module = frag,
            .p_name = "main",
            .p_specialization_info = null,
        }
    };

    // TODO: Move common setup to separate functionality
    const pvisci = vk.PipelineVertexInputStateCreateInfo{
        .flags = .{},
        .vertex_binding_description_count = 0,
        .p_vertex_binding_descriptions = undefined,
        .vertex_attribute_description_count = 0,
        .p_vertex_attribute_descriptions = undefined,
    };

    const piasci = vk.PipelineInputAssemblyStateCreateInfo{
        .flags = .{},
        .topology = .triangle_list,
        .primitive_restart_enable = vk.FALSE,
    };

    // TODO: Replace by dynamic state
    const viewport = vk.Viewport{
        .x = 0,
        .y = 0,
        .width = @intToFloat(f32, r.swapchain.extent.width),
        .height = @intToFloat(f32, r.swapchain.extent.height),
        .min_depth = 0,
        .max_depth = 1,
    };

    // TODO: Replace by dynamic state
    const scissor = vk.Rect2D{
        .offset = .{.x = 0, .y = 0},
        .extent = r.swapchain.extent,
    };

    const pvsci = vk.PipelineViewportStateCreateInfo{
        .flags = .{},
        .viewport_count = 1,
        .p_viewports = asManyPtr(&viewport),
        .scissor_count = 1,
        .p_scissors = asManyPtr(&scissor),
    };

    const prsci = vk.PipelineRasterizationStateCreateInfo{
        .flags = .{},
        .depth_clamp_enable = vk.FALSE,
        .rasterizer_discard_enable = vk.FALSE,
        .polygon_mode = .fill,
        // https://www.saschawillems.de/blog/2016/08/13/vulkan-tutorial-on-rendering-a-fullscreen-quad-without-buffers/
        .cull_mode = .{.front_bit = true},
        .front_face = .counter_clockwise,

        .depth_bias_enable = vk.FALSE,
        .depth_bias_constant_factor = 0,
        .depth_bias_clamp = 0,
        .depth_bias_slope_factor = 0,
        .line_width = 1,
    };

    const pmsci = vk.PipelineMultisampleStateCreateInfo{
        .flags = .{},
        .rasterization_samples = .{.@"1_bit" = true},
        .sample_shading_enable = vk.FALSE,
        .min_sample_shading = 1,
        .p_sample_mask = null,
        .alpha_to_coverage_enable = vk.FALSE,
        .alpha_to_one_enable = vk.FALSE,
    };

    const pcbas = vk.PipelineColorBlendAttachmentState{
        .blend_enable = vk.FALSE,
        .src_color_blend_factor = .one,
        .dst_color_blend_factor = .zero,
        .color_blend_op = .add,
        .src_alpha_blend_factor = .one,
        .dst_alpha_blend_factor = .zero,
        .alpha_blend_op = .add,
        .color_write_mask = .{.r_bit = true, .g_bit = true, .b_bit = true, .a_bit = true},
    };

    const pcbsci = vk.PipelineColorBlendStateCreateInfo{
        .flags = .{},
        .logic_op_enable = vk.FALSE,
        .logic_op = .copy,
        .attachment_count = 1,
        .p_attachments = @ptrCast([*]const vk.PipelineColorBlendAttachmentState, &pcbas),
        .blend_constants = [_]f32{0, 0, 0, 0},
    };

    const gpci = vk.GraphicsPipelineCreateInfo{
        .flags = .{},
        .stage_count = pssci.len,
        .p_stages = &pssci,
        .p_vertex_input_state = &pvisci,
        .p_input_assembly_state = &piasci,
        .p_tessellation_state = null,
        .p_viewport_state = &pvsci,
        .p_rasterization_state = &prsci,
        .p_multisample_state = &pmsci,
        .p_depth_stencil_state = null,
        .p_color_blend_state = &pcbsci,
        .p_dynamic_state = null,
        .layout = self.pipeline_layout,
        .render_pass = self.render_pass,
        .subpass = 0,
        .base_pipeline_handle = .null_handle,
        .base_pipeline_index = -1,
    };

    _ = try r.device.vkd.createGraphicsPipelines(
        r.device.handle,
        .null_handle,
        1, asManyPtr(&gpci),
        null,
        asManyPtr(&self.pipeline),
    );
}
