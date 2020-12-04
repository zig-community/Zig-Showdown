#version 330

in vec3 position;
in vec3 normal;
in vec2 uv;

layout(location = 0) out vec4 fragColor;

uniform mat4 uWorld;
uniform mat4 uViewProjection;
uniform sampler2D uAlbedoTexture;

void main() {
  vec3 ldir = normalize(vec3(0.3, -0.9, 0.2));

  float ldotn = clamp(-dot(ldir, normal), 0.0, 1.0);

  float lighting = 0.3 + 0.8 * ldotn;

  fragColor = vec4(lighting,lighting,lighting,1.0) * texture(uAlbedoTexture, uv);
}
