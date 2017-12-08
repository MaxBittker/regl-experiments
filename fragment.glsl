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
#pragma glslify: noise2d = require('glsl-noise/simplex/2d')

#pragma glslify: fbm3d = require('glsl-fractal-brownian-noise/3d')
#pragma glslify: noise3d = require('glsl-noise/simplex/3d')
// #pragma glslify: fbm4d = require('glsl-fractal-brownian-noise/4d')

// #pragma glslify: noise4d = require(glsl-noise/simplex/4d)

void main () {
  vec2 sample = vec2(1.0-uv.x,  1.0 - uv.y);

  vec3 wcolor = texture2D(webcam, sample).rgb;
  float wmag = luma(wcolor);
  wcolor = hsl2rgb( 0.4+sin(t)*0.01 , 0.2, wmag+0.5);
 

  // vec2(0, 1./resolution.y);
  // sOffset *=0.0;

  // int n =5;
  // float f = 0.01;
  float uB = luma(texture2D(webcam, sample+pix*vec2(0.,2.0)).rgb);
  float dB = luma(texture2D(webcam, sample+pix*vec2(0 ,-2.0)).rgb);
  float lB = luma(texture2D(webcam, sample+pix*vec2(-2.0,0.)).rgb);
  float rB = luma(texture2D(webcam, sample+pix*vec2(2.0,0.)).rgb);
  
  vec2 d = vec2(
    rB - lB, dB - uB
    // lB - rB, uB - dB
  );
  vec2 sOffset = vec2(0.0);
  // sOffset.y = pix.y * noise3d(vec3(uv*20.,t));
  // sOffset.y += pix.y*1.8;
  // sOffset =  normalize(uv-vec2(0.5))* pix * -0.5;
  vec3 scolor = texture2D(texture, uv + sOffset + d*pix*50.  ).rgb;
  // scolor = hsl2rgb( fract(t*0.02) , 0.2, luma(scolor)+0.5);
  
  vec3 color = scolor;
 if (length(d) > 0.09
//  (noise3d(vec3(uv*050.,t*10.) + 2.0))
 ){
   color = wcolor;

 }
  // if(  luma(wcolor)  > luma(scolor) /*webcam darker*/
  //  && luma(wcolor)*0.5 /*+ sin(t*2.)*0.1*/ < luma(scolor)
  //   ){ 
  //   color = scolor;
  // }

  if(t<0.1){
    color = wcolor;
  }
  // color += vec3(0.005);
  // color += vec3(0.005);
  
  if(luma(color)> 0.9){
    // color*=0.5;
    // color+=wcolor*0.1;
  }
  // if(uv.y>1.-pix.y*2.){
    // color = hsl2rgb( 0.7+sin(t)*0.05 , 0.2, noise2d(vec2(uv.x*10.,t)));
  // }  
  gl_FragColor.rgb =color;

  gl_FragColor.a = 1.0;
}