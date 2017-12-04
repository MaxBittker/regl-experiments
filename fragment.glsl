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
#pragma glslify: noise3d = require('glsl-noise/simplex/3d')
#pragma glslify: noise2d = require('glsl-noise/simplex/2d')

// #pragma glslify: fbm3d = require('glsl-fractal-brownian-noise/3d')
// #pragma glslify: fbm4d = require('glsl-fractal-brownian-noise/4d')

// #pragma glslify: noise4d = require(glsl-noise/simplex/4d)

void main () {
  vec2 sample = vec2(1.0-uv.x,  1.0 - uv.y);

  vec3 wcolor = texture2D(webcam, sample).rgb;
  float wmag = luma(wcolor);
  // wcolor = hsl2rgb( fract(fract(t*0.02)*5.) , 0.2, wmag+0.5);
 

  vec2 sOffset = vec2(0, 1./resolution.y);
  // sOffset *=0.0;

  float a = t * PI * 5.;
  // sOffset = vec2(0.);
  vec3 scolor = texture2D(texture, uv+sOffset).rgb;

  vec3 sum = vec3(0.);
  
  sum += texture2D(webcam, sample + vec2(- pix.x, - pix.y)).rgb * 0.25;
  sum += texture2D(webcam, sample + vec2(+ pix.x, - pix.y)).rgb * 0.25;
  sum += texture2D(webcam, sample + vec2(- pix.x, + pix.y)).rgb * 0.25;
  sum += texture2D(webcam, sample + vec2(+ pix.x, + pix.y)).rgb * 0.25;
  sum += texture2D(webcam, sample + vec2(0.)).rgb * -0.7;
                        
  if(length(sum)<0.2){
    sum = vec3(0.);
  }else{
    sum = vec3(1.);
  }
  vec3 color = sum;
  if(luma(sum)<luma(scolor)){
    color = scolor;
  }
  
  color *= 0.99;
  // color *= 1.01;
  
  if( length(color) > 0.05){
    // color = wcolor;
  }
  gl_FragColor.rgb =color;

  gl_FragColor.a = 1.0;
}