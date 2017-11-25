function flatten(a) {
  return a.reduce((a, b) => a.concat(b));
}

function add(...points){
    return points.reduce((a,b)=>[a[0]+b[0],a[1]+b[1],a[2]+b[2]])
}

function mult(v,s){
    return v.map(i=>i*s);
}

function cPoint(i, v, N) {
  var phi = 4 * Math.PI * (i / N);
  var rho = phi * 120;
  let r = 3;

  if (v == 1) {
    rho += 0.2;
  }
  if (v == 2) {
    r *= 0.5;
  }

  let x = r * Math.sin(phi) * Math.cos(rho);
  let y = r * Math.sin(phi) * Math.sin(rho);
  let z = r * Math.cos(phi) * 1.0;

  return [x, y, z];
  // return [Math.cos(phi), Math.sin(phi),Math.sin(phi*5.)*Math.cos(phi*10.)];
}

function buildSpiral(N) {
  // where N is tesselation degree.
  let lines = Array(N)
    .fill()
    .map((_, i) => {
      return [
        cPoint(i, 0, N),
        cPoint(i, 1, N),
        cPoint(i, 1, N),
        cPoint(i, 2, N),
        cPoint(i, 2, N),
        cPoint(i, 0, N)
      ];
    });

  return lines;
}

function makePoint(i, N) {
  //   var phi = 4 * Math.PI * (i / N);
  let phi = i % 360;
  var rho = (i % (360 * 360)) / 360;

  let r = 3;
  let x = r * Math.sin(phi) * Math.cos(rho);
  let y = r * Math.sin(phi) * Math.sin(rho);
  let z = r * Math.cos(phi) * 1.0;
  //   z*= 0.1;
  let p = [x, y, z];
  return [p, p.map(v => v * 0.7)];
}

function buildSphere(N) {
  let lines = Array(N)
    .fill()
    .map((_, i) => {
      return makePoint(i, N);
    });

  return lines;
}
function randomPoint(s=1){
    return [Math.random()-0.5,Math.random()-0.5,Math.random()-0.5].map(v=>v*s)
}

function build(N) {
  let line = [[0, 0, 0]];

  for (let i = 0; i < N; i++) {
    let n = add(line[i], randomPoint(10), [0.9,0,0]);
    // let n = [x + Math.random(), y + Math.random(), z + Math.random()];
    line.push(n);
    line.push(n);
    
  }
  return line;
}
export { cPoint, buildSpiral, buildSphere, build };
