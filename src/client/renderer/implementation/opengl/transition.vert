#version 330

out vec2 uv;

void main() {
  uv = vec2(
    float(gl_VertexID % 2),
    float(gl_VertexID / 2)
  );
  gl_Position = vec4(2.0 * uv - 1.0, 0.0, 1.0);
}