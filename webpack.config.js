var webpack = require("webpack");
var path = require("path");
var fs = require('fs');

var nodeModules = {};
fs.readdirSync('node_modules')
  .filter(function(x) {
    return ['.bin'].indexOf(x) === -1;
  })
  .forEach(function(mod) {
    nodeModules[mod] = 'commonjs ' + mod;
  });


var BUILD_DIR = path.resolve(__dirname, "dist");
var APP_DIR = __dirname;

var config = {
  entry: APP_DIR + "/index.js",
  output: {
    path: BUILD_DIR,
    publicPath: "/dist/",
    filename: "bundle.js"
  },
  devtool: "#cheap-source-map",
  target:"node",
  externals: nodeModules,
  module: {
    loaders: [
      {
        test: /\.(glsl|frag|vert)$/,
        use: "raw-loader",
        exclude: /node_modules/
      },
      {
        test: /\.(glsl|frag|vert)$/,
        use: "glslify-loader",
        exclude: /node_modules/
      }
    ]
  }
};

module.exports = config;
