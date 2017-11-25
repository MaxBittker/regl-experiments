function flatten(a) {
  return a.reduce((a, b) => a.concat(b));
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

function makeCircle(N) {
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

  //   lines = flatten(lines);

  return lines;
}
function makePoint(i, N){
//   var phi = 4 * Math.PI * (i / N);
  let phi = (i % 360);
  var rho = (i % (360*360) )/360 ;

  let r = 3;
  let x = r * Math.sin(phi) * Math.cos(rho);
  let y = r * Math.sin(phi) * Math.sin(rho);
  let z = r * Math.cos(phi) * 1.0;
  let p = [x,y,z];
  return [p, p.map(v=>v*0.9)];
}

function build(N) {
  let lines = Array(N)
    .fill()
    .map((_, i) => {
        return makePoint(i,N);
    });
    
  return lines;
}

export { cPoint, makeCircle, build };
