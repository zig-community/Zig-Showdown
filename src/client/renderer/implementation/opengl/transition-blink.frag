#version 330

in vec2 uv;

layout(location = 0) out vec4 result;

uniform ivec2 uScreenSize;
uniform sampler2D uFrom, uTo;
uniform float uProgress;

void main() {
  if(uProgress < 0.3)
    result = texture(uFrom, uv);
  else if(uProgress > 0.7)
    result = texture(uTo, uv);
  else
    result = vec4(0, 0, 0, 1);
}