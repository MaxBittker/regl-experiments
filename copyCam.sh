webpack  && \
mkdir ../webcam-sketches/$1 && \
cp index.html ../webcam-sketches/$1/index.html && \
cp -r dist/ ../webcam-sketches/$1/dist && \
echo "<a href="$1">$1</a><br>" >> ../webcam-sketches/index.html