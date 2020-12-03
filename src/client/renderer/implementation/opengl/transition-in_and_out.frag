#version 330

in vec2 uv;

layout(location = 0) out vec4 result;

uniform ivec2 uScreenSize;
uniform sampler2D uFrom, uTo;
uniform float uProgress;

void main() {
  
  result = mix(
    texture(uFrom, uv),
    vec4(0),
    smoothstep(0.0, 1.0, clamp(2.0 * uProgress, 0.0, 1.0))
  );

  result = mix(
    result,
    texture(uTo, uv),
    smoothstep(0.0, 1.0, clamp(2.0 * uProgress - 1.0, 0.0, 1.0))
  );
}