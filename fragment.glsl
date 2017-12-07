precision mediump float;

uniform float tick;
uniform vec2 resolution;
// uniform sampler2D texture;
// uniform vec2 mouse;
varying vec2 uv;
float PI = 3.14159;
vec2 doModel(vec3 p);

float t = sin(tick * PI * 2. /100. )*0.5;

#pragma glslify: raytrace = require('glsl-raytrace', map = doModel, steps = 90)
#pragma glslify: normal = require('glsl-sdf-normal', map = doModel)
#pragma glslify: orenn = require('glsl-diffuse-oren-nayar')
#pragma glslify: gauss = require('glsl-specular-gaussian')
#pragma glslify: camera = require('glsl-turntable-camera')
#pragma glslify: fbm3d = require('glsl-fractal-brownian-noise/3d')
#pragma glslify: fbm4d = require('glsl-fractal-brownian-noise/4d')

#pragma glslify: noise = require('glsl-noise/simplex/4d')
#pragma glslify: noise2d = require('glsl-noise/simplex/2d')

#pragma glslify: noise3d = require('glsl-noise/simplex/3d')

// #pragma glslify: noise4d = require(glsl-noise/simplex/4d)


vec2 doModel(vec3 p) {
// float r  = 2.0 + noise4d(vec4(p, t)) * 0.035;
  float r = 1.2;
  // float r  = 1.5 + fbm4d(vec4(p,t*0.1), 9) * 0.45;

  float d  = length(p) - r;
  float wall = d ;//(p.z - asd0.9);
  wall = mod(wall, 0.4);
  // d = wall;
  float wr = fbm3d( vec3(p.xy, t), 2)*0.9 ;
  // float wr = fbm3d(vec4(p.zxz,t))*0.2 ;
  d = max(- wall+wr, d);
  wall = wall -  0.000001;
  d = max(wall-wr , d);
  //  float d  = length(p) - r;
  // float wall = (p.y - 0.9);
  // wall = mod(wall, 0.5);
  // float wr = noise4d(vec4(p.zxx,t))*0.1 ;
  // d = max(- wall+wr, d);
  // wall = wall -  0.00001;
  // d = max(wall-wr , d);

  float id = 0.0;
  // d += fbm3d(p, 5)*0.2;
  return vec2(d, id);
}

vec3 lighting(vec3 pos, vec3 nor, vec3 ro, vec3 rd) {
  vec3 dir1 = normalize(vec3(0, 1, 0));
  vec3 col1 = vec3(3.0, 0.7, 0.4);
  vec3 dif1 = col1 * orenn(dir1, -rd, nor, 0.15, 1.0);
  vec3 spc1 = col1 * gauss(dir1, -rd, nor, 0.15);

  vec3 dir2 = normalize(vec3(0.4, -1, 0.4));
  vec3 col2 = vec3(0.4, 0.4, 0.9);
  vec3 dif2 = col2 * orenn(dir2, -rd, nor, 0.15, 1.0);
  vec3 spc2 = col2 * gauss(dir2, -rd, nor, 0.15);

  return dif1 + spc1 + dif2 + spc2;
}

void main() {
  vec3 color = vec3(0.0);
  vec3 ro, rd;

  float rotation = t;
  float height   = 0.5;
  float dist     = 4.0;
  camera(rotation, height, dist, resolution, ro, rd);
  bool touched = false;
  vec2 tr = raytrace(ro, rd);
  if (tr.x > -0.5) {
    vec3 pos = ro + rd * tr.x;
    vec3 nor = normal(pos);

    color = lighting(pos, nor, ro, rd);
    touched = true;
  }

  // gamma correction
  color = pow(color, vec3(0.5545));
  
  
  // float a = noise3d( vec3(uv*20.,t*0.1) ) * PI*2.;
  // vec4 sample = texture2D(texture, uv + vec2( (cos(a)*3.0)/resolution.x, (sin(a)*3.0)/resolution.y ));
  
  // if(length(sample)>1.6){
    // color = vec3(1.0,0.1,0.1);
    // color = color*0.5 + sample.rgb*0.5;
  // }
  // vec4 back = texture2D(texture, uv+(vec2(0.0, 3./resolution.y)));
  // if(!touched){
    // color = sample.rgb;
  // }
  if (length(color) >  noise3d(vec3(uv*290.,t))+1.0){
    color = vec3(1.);
  }else{
    color = vec3(0.);
  }
  // gl_FragColor.rgb = curlNoise(vec3(uv * 15.,t));
  // gl_FragColor = vec4(1.0)* fbm4d(vec4(uv*2.0,t,1.0), 3);
  gl_FragColor.rgb = color;
  gl_FragColor.a   = 1.0;
}