const regl = require("regl")();
const mouse = require("mouse-change")();
const wc = require("./regl-webcam");

var fsh = require("./fragment.glsl");
var vsh = require("./vertex.glsl");

let datas = [];

const pixels = regl.texture();
let cam = wc({
  regl,
  done: webcam => {
    let canvas = document.body.children[3]
    let images = document.body.children[1]
    
    const drawFeedback = regl({
      frag: fsh,
      vert: vsh,
      attributes: {
        position: [-2, 0, 0, -2, 2, 2]
      },

      uniforms: {
        webcam,
        resolution: context => [context.viewportWidth, context.viewportHeight],
        texture: pixels,
        mouse: ({ pixelRatio, viewportHeight }) => [
          mouse.x * pixelRatio,
          viewportHeight - mouse.y * pixelRatio
        ],
        t: ({ tick }) => tick
      },
      count: 3
    });

    regl.frame(function({tick,viewportWidth}) {
      regl.clear({
        color: [0, 0, 0, 1]
      });
      
      drawFeedback();
      console.log(tick*1.5 % viewportWidth )
      if(tick*1.5 % viewportWidth > viewportWidth - 1.6){
        let durl = canvas.toDataURL('png');
        datas.push(durl)
        let i = document.createElement('img')
        i.src =durl
        images.appendChild(i)
      }
      pixels({
        copy: true
      });
    });
  
  
  
  }
});
