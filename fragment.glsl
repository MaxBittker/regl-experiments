precision mediump float;
#pragma glslify: noise = require('glsl-noise/simplex/3d')

varying vec2 uv;
uniform float t;

void main() {
  
  vec3 color = vec3(sin(t),length(uv),0.5);
//   gl_FragColor = vec4(color ,1.0);
  float d = noise(vec3(uv*5., t));
  gl_FragColor = vec4(color*d,1.0);
}