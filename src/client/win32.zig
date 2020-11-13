pub const Platform = struct {
    pub const vulkan_surface_extension = "VK_KHR_win32_surface";

    pub fn init() !Platform {
        return Platform{};
    }
    pub fn deinit(self: *Platform) void {}
};
