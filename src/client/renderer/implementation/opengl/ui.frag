#version 330

in vec2 uv;
in vec4 tint;

layout(location = 0) out vec4 fragColor;

uniform ivec2 uScreenSize;
uniform sampler2D uTexture;

void main() {
  fragColor = tint * texture(uTexture, uv);
}
