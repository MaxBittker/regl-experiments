export default ({fftSize})=>`

precision mediump float;
uniform mat4 projection, view;
uniform float time;
attribute vec3 position;
varying vec3 vPosition;
#define FFT_SIZE ${fftSize}
#define PI ${Math.PI}
attribute float index, frequency;
void main() {
  float theta = 2.0 * PI * index / float(FFT_SIZE);
  vec4 p = vec4(position,1.0);

  float i = index / float(FFT_SIZE);
  
  float phi = 2.0 * PI * i;
  float rho = phi * 10. * time*0.0001;
  float r = 1.0;

  float x = r * sin(phi) * cos(rho);
  float y = r * sin(phi) * sin(rho);
  float z = r * cos(phi)* 1.0;
  vec4 ps = vec4(
    x,
    y ,
    z ,
    (0.3 - frequency*0.15));
  vPosition = ps.xyz;
    
   gl_Position = projection * view * p+ ps;
}`
