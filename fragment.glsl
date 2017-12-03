precision mediump float;

uniform float t;
uniform vec2 resolution;
uniform sampler2D texture;
uniform sampler2D webcam;
uniform vec2 mouse;

varying vec2 uv;
float PI = 3.14159;
#pragma glslify: hsl2rgb = require(glsl-hsl2rgb) 
#pragma glslify: luma = require(glsl-luma) 

#pragma glslify: orenn = require('glsl-diffuse-oren-nayar')
#pragma glslify: gauss = require('glsl-specular-gaussian')
#pragma glslify: camera = require('glsl-turntable-camera')
#pragma glslify: noise4d = require('glsl-noise/simplex/4d')
#pragma glslify: noise2d = require('glsl-noise/simplex/2d')
#pragma glslify: fbm3d = require('glsl-fractal-brownian-noise/3d')
#pragma glslify: fbm4d = require('glsl-fractal-brownian-noise/4d')

#pragma glslify: noise3d = require('glsl-noise/simplex/3d')

// #pragma glslify: noise4d = require(glsl-noise/simplex/4d)

void main () {
  vec2 sample = vec2(1.0-uv.x,  1.0 - uv.y);
  vec3 wcolor = texture2D(webcam, sample).rgb;
  float wmag = luma(wcolor);
 

  vec2 sOffset = uv/resolution *30.0;
  sOffset.x *=0.0;
  vec3 scolor = texture2D(texture, uv+sOffset).rgb;
  
  wcolor = hsl2rgb( fract(t*0.02) , 0.2, wmag+0.5);

  vec3 color = wcolor;

  if( luma(wcolor) > luma(scolor) && luma(scolor)>0.7 ){
    color = scolor;
  }

  if(length(scolor)< 0.01){
    color = wcolor;
  }

  // color *=1.01;
  if(uv.y>0.99){
    // color = vec3(1.0);
  }
  gl_FragColor.rgb =color;

  gl_FragColor.a = 1.0;
}