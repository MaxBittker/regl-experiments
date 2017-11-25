var glsl = require('glslify')

const fsh = glsl`
#pragma glslify: noise = require('glsl-noise/simplex/3d')

precision mediump float;
varying vec2 uv;
uniform float t;

void main() {
  
  vec3 color = vec3(sin(t),length(uv),0.5);
  // gl_FragColor = vec4(color ,1.0);
  gl_FragColor = vec4(noise(uv*25.0,t),1);
}
`
console.log(fsh)
export default fsh