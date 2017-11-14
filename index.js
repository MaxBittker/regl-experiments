/*
  tags: audio, basic, lines
  <p>This example shows how to create a simple audio visualization, using your microphone as input.</p>
 */
/* global AudioContext */
const regl = require("regl")();
const camera = require("regl-camera")(regl, {
  center: [0, 0, 0]
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
    vert: `
    precision mediump float;
    uniform mat4 projection, view;
    
    #define FFT_SIZE ${fftSize}
    #define PI ${Math.PI}
    attribute float index, frequency;
    void main() {
      float theta = 2.0 * PI * index / float(FFT_SIZE);

      vec4 position = vec4(
        0.5 * cos(theta) + (frequency * 0.2),
        0.5 * sin(theta) + (frequency * 0.2),
        0.5 *  (frequency * 0.2),
        0.3);
       gl_Position = projection * view * position;
    }`,
    
    frag: `
    void main() {
        
      gl_FragColor = vec4(1, 1, 1, 1);
    }`,

    attributes: {
      index: Array(fftSize).fill().map((_, i) => i),
      frequency: {
        buffer: fftBuffer,
        normalized: true
      }
    },
    elements: null,
    instances: -1,
    lineWidth: 1,
    depth: { enable: false },
    count: fftSize,
    primitive: "line loop"
  });

  regl.frame(() => {
    camera(state => {

        // console.log(state)
    //   if (!state.dirty) return;
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
    });
  });
});
