precision mediump float;

uniform float t;
uniform vec2 resolution;
uniform sampler2D texture;
uniform vec2 mouse;
varying vec2 uv;
float PI = 3.14159;
vec2 doModel(vec3 p);

#pragma glslify: raytrace = require('glsl-raytrace', map = doModel, steps = 90)
#pragma glslify: normal = require('glsl-sdf-normal', map = doModel)
#pragma glslify: orenn = require('glsl-diffuse-oren-nayar')
#pragma glslify: gauss = require('glsl-specular-gaussian')
#pragma glslify: camera = require('glsl-turntable-camera')
#pragma glslify: noise = require('glsl-noise/simplex/4d')
#pragma glslify: noise2d = require('glsl-noise/simplex/2d')
#pragma glslify: noise3d = require('glsl-noise/simplex/3d')

vec2 doModel(vec3 p) {
  p.x -=(( mouse.x/resolution.x ) - 0.5)*4.0;
  p.y -=(( mouse.y/resolution.y ) - 0.5)*4.0;
  
  float r  = 0.3 + noise(vec4(p, t)) * 0.25;
  // r*=sin(t)*mouse.x;
  float d  = length(p) - r;
  // float wall = (p.y + 1.0 + noise3d(vec3(p.xz*0.9,t))*0.2 )- length(p.zy);

  // d = min(wall, d);
  // d = max(-p.y, d);
  
  float id = 0.0;

  return vec2(d, id);
}

vec3 lighting(vec3 pos, vec3 nor, vec3 ro, vec3 rd) {
  vec3 dir1 = normalize(vec3(0, 1, 0));
  vec3 col1 = vec3(3.0, 0.7, 0.4);
  vec3 dif1 = col1 * orenn(dir1, -rd, nor, 0.15, 1.0);
  vec3 spc1 = col1 * gauss(dir1, -rd, nor, 0.15);

  vec3 dir2 = normalize(vec3(0.4, -1, 0.4));
  vec3 col2 = vec3(0.4, 0.8, 0.9);
  vec3 dif2 = col2 * orenn(dir2, -rd, nor, 0.15, 1.0);
  vec3 spc2 = col2 * gauss(dir2, -rd, nor, 0.15);

  return dif1 + spc1 + dif2 + spc2;
}

void main() {
  vec3 color = vec3(0.0);
  vec3 ro, rd;

  float rotation = 0.;
  float height   = 2.5;
  float dist     = 4.0;
  camera(rotation, height, dist, resolution, ro, rd);
  bool touched = false;
  vec2 t = raytrace(ro, rd);
  if (t.x > -0.5) {
    vec3 pos = ro + rd * t.x;
    vec3 nor = normal(pos);

    color = lighting(pos, nor, ro, rd);
    touched = true;
  }

  // gamma correction
  color = pow(color, vec3(0.5545));
  
  
  float a = noise3d( vec3(uv*20.,t) ) * PI*2.;
  vec4 sample = texture2D(texture, uv + vec2( (cos(a)*3.0)/resolution.x, (sin(a)*3.0)/resolution.y ));
  
  // if(length(sample)>1.6){
    // color = vec3(1.0,0.1,0.1);
    color = color*0.5 + sample.rgb*0.5;
  // }
  vec4 back = texture2D(texture, uv+(vec2(0.0, 3./resolution.y)));
  if(!touched){
    color = sample.rgb;
  }
  gl_FragColor.rgb = color ;
  gl_FragColor.a   = 1.0;
}