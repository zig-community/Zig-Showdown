pub const Platform = struct {
    pub const vulkan_surface_extension = "VK_KHR_xcb_surface";

    pub fn init() !Platform {
        return Platform{};
    }
    pub fn deinit(self: *Platform) void {}
};
