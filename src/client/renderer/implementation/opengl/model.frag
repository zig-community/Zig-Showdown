#version 330

in vec3 position;
in vec3 normal;
in vec2 uv;

layout(location = 0) out vec4 fragColor;

uniform mat4 uWorld;
uniform mat4 uViewProjection;
uniform sampler2D uAlbedoTexture;

void main() {
  fragColor = texture(uAlbedoTexture, uv);
}
