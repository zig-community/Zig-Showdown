#version 330

in vec2 uv;

layout(location = 0) out vec4 result;

uniform ivec2 uScreenSize;
uniform sampler2D uFrom, uTo;
uniform float uProgress;

void main() {
  vec2 xy = vec2(float(uScreenSize.x) / float(uScreenSize.y), 1.0) * uv;
  
  float limit = 1.0 + float(uScreenSize.x) / float(uScreenSize.y);

  float threshold = limit * smoothstep(0.0, 1.0, uProgress);

  if(xy.x + xy.y <= threshold)
    result = texture(uTo, uv);
  else
    result = texture(uFrom, uv);
}