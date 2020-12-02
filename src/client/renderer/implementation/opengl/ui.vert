#version 330

layout(location = 0) in ivec2 vPosition;
layout(location = 1) in vec2 vTextureCoord;
layout(location = 2) in vec4 vColor;

out vec2 uv;
out vec4 tint;

uniform ivec2 uScreenSize;
uniform sampler2D uTexture;

void main() {
  tint = vColor;
  uv = vTextureCoord;
  gl_Position = vec4(
    vec2(1,-1) * (2.0 * vec2(vPosition) / vec2(uScreenSize - 1) - 1.0),
    0.0,
    1.0
  );
}