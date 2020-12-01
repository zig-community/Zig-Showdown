#version 330

layout(location = 0) in vec3 vPosition;
layout(location = 1) in vec3 vNormal;
layout(location = 2) in vec2 vTextureCoord;

out vec3 position;
out vec3 normal;
out vec2 uv;

uniform mat4 uWorld;
uniform mat4 uViewProjection;
uniform sampler2D uAlbedoTexture;

void main() {
  position = (uWorld * vec4(vPosition,1.0)).xyz;
  normal = mat3(uWorld) * vNormal;
  uv = vTextureCoord;

  gl_Position = uViewProjection * uWorld * vec4(vPosition, 1.0);
}