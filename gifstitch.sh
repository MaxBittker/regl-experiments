rm -rf video-* && webpack && node dist/bundle.js && gm  convert -loop 0 video-*/* output.gif
