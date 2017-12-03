precision mediump float;

uniform float t;
uniform vec2 resolution;
uniform sampler2D texture;
uniform sampler2D webcam;
uniform vec2 mouse;

varying vec2 uv;
float PI = 3.14159;

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

  // sample 
  vec3 scolor = texture2D(texture,uv).rgb;

  // vec3 color = wcolor*0.2 +  scolor*0.8;
  vec3 color = min(wcolor, scolor);
  color += vec3(0.01);
  gl_FragColor.rgb =color;
  gl_FragColor.a = 1.0;
}