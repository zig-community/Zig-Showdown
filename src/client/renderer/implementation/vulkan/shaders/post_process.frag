#version 450

// Keep in sync with DescriptorManager.zig!
#define TEXTURE_POOL_SIZE (1024)
layout(set = 0, binding = 0) uniform sampler texture_sampler;
layout(set = 0, binding = 1) uniform texture2D textures[TEXTURE_POOL_SIZE];

layout(location = 0) out vec4 f_color;

void main() {
    f_color = vec4(1, 0, 1, 1);
}
