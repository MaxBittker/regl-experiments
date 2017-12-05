precision mediump float;

uniform float t;
uniform vec2 resolution;
uniform sampler2D texture;
uniform sampler2D webcam;
uniform vec2 mouse;
varying vec2 uv;
float PI = 3.14159;
vec2 pix = vec2(1./resolution.x,1./resolution.y);

#pragma glslify: hsl2rgb = require(glsl-hsl2rgb) 
#pragma glslify: luma = require(glsl-luma) 

#pragma glslify: orenn = require('glsl-diffuse-oren-nayar')
#pragma glslify: gauss = require('glsl-specular-gaussian')
#pragma glslify: camera = require('glsl-turntable-camera')
#pragma glslify: noise4d = require('glsl-noise/simplex/4d')
// #pragma glslify: noise3d = require('glsl-noise/simplex/3d')
// #pragma glslify: noise2d = require('glsl-noise/simplex/2d')
#pragma glslify: fbm2d = require('glsl-fractal-brownian-noise/2d')

#pragma glslify: fbm3d = require('glsl-fractal-brownian-noise/3d')
// #pragma glslify: fbm4d = require('glsl-fractal-brownian-noise/4d')

// #pragma glslify: noise4d = require(glsl-noise/simplex/4d)

void main () {
  vec2 sample = vec2(1.0-uv.x,  1.0 - uv.y);

  vec3 wcolor = texture2D(webcam, sample).rgb;
  float wmag = luma(wcolor);
  wcolor = hsl2rgb( 0.7, 0.2, wmag+0.5);
 

  vec2 sOffset = vec2(0, 1./resolution.y);
  sOffset *=0.0;
  vec3 scolor = texture2D(texture, uv+sOffset).rgb;
  
  vec3 color = wcolor;
  float l = fract( t*150. / resolution.x);
  
  if(uv.x < l +pix.x*5. && uv.x > l+ pix.x*4.){
    color = vec3(0.);
  }
  if(  uv.x <= l){
    color = scolor;
  }  
  
  gl_FragColor.rgb =color;

  gl_FragColor.a = 1.0;
}