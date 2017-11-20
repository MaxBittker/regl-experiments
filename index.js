const regl = require("regl")();
// var createReglRecorder = require('regl-recorder')

const VIDEO_WIDTH = 600
const VIDEO_HEIGHT = 600


// const regl = require('regl')(require('gl')(VIDEO_WIDTH, VIDEO_HEIGHT, {preserveDrawingBuffer: true}))

// var recorder = createReglRecorder(regl, 150)

const camera = require("regl-camera")(regl, {
  center: [0, 0, 0],
  damping: 0.9,
  rotationSpeed: 0.9,
});

let sin = Math.sin;
let cos = Math.cos;

function flatten(a) {
  return a.reduce((a, b) => a.concat(b));
}

// First we need to get permission to use the microphone
require("getusermedia")({ audio: true }, function(err, stream) {
  if (err) {
    return;
  }

  // Next we create an analyser node to intercept data from the mic
  const context = new AudioContext();
  const analyser = context.createAnalyser();
  // And then we connect them together
  context.createMediaStreamSource(stream).connect(analyser);

  // Here we preallocate buffers for streaming audio data
  const fftSize = analyser.frequencyBinCount;
  const frequencies = new Uint8Array(fftSize);
  const fftBuffer = regl.buffer({
    length: fftSize,
    type: "uint8",
    usage: "dynamic"
  });

  // This command draws the spectrogram
  const drawSpectrum = regl({
    vert: `
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
      vec3 p = position;
      

      float i = index / float(FFT_SIZE);
      
      float phi = 4.0 * PI * i;
      float rho = phi * 15. * sin(time*0.00001);
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
        
       gl_Position = projection * view * ps;
    }`,

    frag: `
    precision mediump float;
    varying vec3 vPosition;
    uniform float time;
    
    void main() {
      
      vec3 color = vec3(1.0);
    //  color  = vec3(sin( time*0.005 +distance(vPosition, vec3(0.1))*90.) );
     
      gl_FragColor = vec4(color,1.0);
    }`,
    uniforms:{
      time: (context)=>{return window.performance.now()}
    },
    attributes: {
      index: Array(fftSize).fill().map((_, i) => i),
      frequency: {
        buffer: fftBuffer, //flatten(fftBuffer.map( i => [i, i])),
        normalized: true
      },
      position: regl.buffer(makeCircle(fftSize))
    },
    elements: null,
    instances: -1,
    lineWidth: 1,
    depth: { enable: true },
    count: fftSize,
    primitive: "line loop"
  });

  function cPoint(i,v,N) {
    var phi = 4 * Math.PI * (i / N);
    var rho = phi*2;
    let r = 1;
    
    if(v==1){
      phi+= Math.PI*0.20;
    }
    if(v==2){
      // rho+= Math.PI*0.20;
      r= 0.9;
    }

    let x = r * Math.sin(phi)*Math.cos(rho);
    let y = r * Math.sin(phi)*Math.sin(rho);
    let z = r * Math.cos(phi)* 1.0;
    return [x,y,z];
    // return [Math.cos(phi), Math.sin(phi),Math.sin(phi*5.)*Math.cos(phi*10.)];
  }

  function makeCircle(N) {
    // where N is tesselation degree.
    let lines = Array(N).fill().map((_, i) => {
        // return [cPoint(i,0,N)];
        return [ cPoint(i,0,N), cPoint(i,1,N), cPoint(i,2,N) ];
      });

    let fl = flatten(lines);
    // return lines;
    return fl;
  }
  regl.frame(({viewportWidth,viewportHeight}) => {
    camera(state => {
      // console.log(state)
      //   if (!state.dirty) return;
      // Clear draw buffer
      regl.clear({
        color: [0, 0, 0, 1],
        depth: 1
      });
      // console.log(state)
      // Poll microphone data
      analyser.getByteFrequencyData(frequencies);
      // Here we use .subdata() to update the buffer in place
      fftBuffer.subdata(frequencies);

      // Draw the spectrum
      drawSpectrum();
      // recorder.frame(viewportWidth, viewportHeight)
    });
  });
});
