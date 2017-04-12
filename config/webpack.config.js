'use strict';

var path = require('path');
var webpack = require('webpack');

module.exports = {
  context: path.resolve(__dirname, '../src'),
  entry: {
    app: './app.js',
  },
  module: {
    rules: [{
      test: /\.css$/,
      exclude: /node_modules/,
      loader: 'style-loader!css-loader?modules',
    }, {
      test: /\.css$/,
      include: /node_modules/,
      loader: 'style-loader!css-loader',
    }, {
      test: /\.js$/,
      include: [path.resolve(__dirname, '../src')],
      loader: 'babel-loader',
    }]
  },
  output: {
    filename: '[name].bundle.js',
    path: path.resolve(__dirname, '../dist/assets'),
    publicPath: '/assets',
  },
  devServer: {
    contentBase: path.resolve(__dirname, '../src'), 
  },
}
