// const regl = require('regl')()
// const mouse = require("mouse-change")();
var createReglRecorder = require("regl-recorder");



const VIDEO_WIDTH = (VIDEO_HEIGHT = 600);

const regl = require("regl")(
  require("gl")(VIDEO_WIDTH, VIDEO_HEIGHT, { preserveDrawingBuffer: true })
);
var recorder = createReglRecorder(regl, 100);

var fsh = require("./fragment.glsl");
var vsh = require("./vertex.glsl");

const pixels = regl.texture();

const drawFeedback = regl({
  frag: fsh,
  vert: vsh,
  attributes: {
    position: [-2, 0, 0, -2, 2, 2]
  },

  uniforms: {
    resolution: context => [context.viewportWidth, context.viewportHeight],
    // resolution: context => [VIDEO_WIDTH, VIDEO_HEIGHT],
    
    // texture: pixels,
    // mouse: ({ pixelRatio, viewportHeight }) => [
      // mouse.x * pixelRatio,
      // viewportHeight - mouse.y * pixelRatio
    // ],
    // t: ({ tick }) => 0.01 * tick
    tick :({tick})=>tick
    
  },
  count: 3
});

regl.frame(function({viewportWidth,viewportHeight}) {
  regl.clear({
    depth:1,
    color: [0, 0, 0, 1]
  });

  drawFeedback();

  // pixels({
  //   copy: true
  // });
  recorder.frame(viewportWidth, viewportHeight)
  
  
});
