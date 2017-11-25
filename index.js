const regl = require("regl")();

// var createReglRecorder = require('regl-recorder')

const VIDEO_WIDTH = 600
const VIDEO_HEIGHT = 600

import vsh from "./vertex.sh.js";
import fsh from "./fragment.sh.js";
import {cPoint, makeCircle} from "./construct"

// const regl = require('regl')(require('gl')(VIDEO_WIDTH, VIDEO_HEIGHT, {preserveDrawingBuffer: true}))

// var recorder = createReglRecorder(regl, 150)

const camera = require("regl-camera")(regl, {
  center: [0, 0, 0],
  damping: 0.9,
  rotationSpeed: 0.9,
});

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
    vert: vsh({fftSize}),
    frag: fsh,
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

  regl.frame(({viewportWidth,viewportHeight}) => {
    camera(state => {
      // Clear draw buffer
      regl.clear({
        color: [0, 0, 0, 1],
        depth: 1
      });


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
