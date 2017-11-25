const fsh = `
precision mediump float;
varying vec3 vPosition;
uniform float time;

void main() {
  
  vec3 color = vec3(1.0);
//  color  = vec3(sin( time*0.005 +distance(vPosition, vec3(0.1))*90.) );
  
  gl_FragColor = vec4(color,1.0);
}
`

export default fsh