const getUserMedia = require('getusermedia')

module.exports = function (options) {
  const regl = options.regl
  getUserMedia({video: true, audio: false}, function (err, stream) {
    if (err) {
      options.error && options.error(err)
      return
    }
    const video = document.createElement('video')
    video.srcObject = stream;
    document.body.appendChild(video)
    video.addEventListener('loadedmetadata', () => {
      video.play().then(() => {
      const webcam = regl.texture(video)
      regl.frame(() => webcam.subimage(video))
      options.done(webcam)
      })
    })
  })
}