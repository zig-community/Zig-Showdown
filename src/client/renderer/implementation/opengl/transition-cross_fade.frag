#version 330

in vec2 uv;

layout(location = 0) out vec4 result;

uniform ivec2 uScreenSize;
uniform sampler2D uFrom, uTo;
uniform float uProgress;

void main() {
  result = mix(
    texture(uFrom, uv),
    texture(uTo, uv),
    uProgress
  );
}