const fsh = `
precision mediump float;
varying vec3 vPosition;
uniform float time;
varying lowp vec4 vColor;

void main() {
  
  vec3 color = vec3(1.0,0.5,0.3);
//  color  = vec3(sin( time*0.005 +distance(vPosition, vec3(0.1))*90.) );
  gl_FragColor = vColor;
  // gl_FragColor = vec4(color ,1.0);
}
`

export default fsh