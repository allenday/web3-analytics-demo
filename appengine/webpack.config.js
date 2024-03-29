const webpack = require("webpack");
const path = require("path");

const devMode = process.env.NODE_ENV !== "production";

const plugins = [
  new webpack.ProvidePlugin({
    Buffer: ["buffer", "Buffer"],
  }),
  new webpack.ProvidePlugin({
    process: "process/browser.js",
  }),
];


/** @type {import("webpack").Configuration} */
module.exports = {
  devServer: {
    port: 3000,
  },
  mode: process.env.NODE_ENV || "production",
  devtool: devMode ? "source-map" : false,
  entry: "./public/web3auth.js",
  target: "web",
  output: {
    path: path.resolve(__dirname, "./public"),
    filename: "bundle.js",
    crossOriginLoading: "anonymous",
  },
  resolve: {
    extensions: [".ts", ".tsx", ".js", ".jsx"],
    alias: {
      "bn.js": path.resolve("./node_modules", "bn.js"),
    },
    fallback: {
      http: require.resolve("stream-http"),
      https: require.resolve("https-browserify"),
      os: require.resolve("os-browserify/browser"),
      crypto: require.resolve("crypto-browserify"),
      assert: require.resolve("assert/"),
      stream: require.resolve("stream-browserify"),
      url: require.resolve("url/"),
      buffer: require.resolve("buffer/"),
      fs: false,
      path: false,
    },
  },
  plugins,
  module: {
    rules: [
      {
        test: /\.css$/,
        use: ["style-loader", "css-loader"],
      },
      {
        test: /\.(ts|js)x?$/,
        exclude: /(node_modules|bower_components)/,
        use: {
          loader: "babel-loader",
          options: {
            cacheDirectory: true,
            cacheCompression: false,
            targets: ["> 0.5%", "not dead", "not ie 11"],
          },
        },
      },
    ],
  },
};