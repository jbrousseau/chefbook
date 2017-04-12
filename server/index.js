import path from 'path'
import dotenv from 'dotenv'
import express from 'express';
import webpack from 'webpack'
import webpackMiddleware from 'webpack-dev-middleware';
import postgraphql from 'postgraphql'
import webpackConfig from '../config/webpack.config'
import webpackHotMiddleware from 'webpack-hot-middleware';

// Load the config from .env file.
dotenv.load()
const {
  APP_PORT,
  DB_STRING,
  DB_SCHEMA,
  SECRET,
  DEFAULT_ROLE,
  JWT_TOKEN_IDENTIFIER,
  IS_DEV_ENV
} = process.env

const app = express();

// we compile the frontend with webpack/babel
/*const compiler = webpack(webpackConfig)

// This allows use compile the front-end app on the fly.
// Do not use this in production!
const app = new WebpackDevServer(compiler, {
  contentBase: '/public/',
  publicPath: '/static/',
  noInfo: true,
  stats: { colors: true },
})*/




if (IS_DEV_ENV) {
    const compiler = webpack(webpackConfig);
    const middleware = webpackMiddleware(compiler, {
      publicPath: webpackConfig.output.publicPath,
      contentBase: 'src',
      noInfo: true,
      stats: {
        colors: true,
        hash: false,
        timings: true,
        chunks: false,
        chunkModules: false,
        modules: false
      }
    });

    app.use(middleware);
    app.use(webpackHotMiddleware(compiler));
    app.use(express.static('public'));

    app.use(postgraphql(DB_STRING, DB_SCHEMA, {
      pgDefaultRole: DEFAULT_ROLE,
      classicIds: true,
      graphiql: IS_DEV_ENV,
      jwtSecret: SECRET,
      jwtPgTypeIdentifier: JWT_TOKEN_IDENTIFIER,
    }))

    app.use('*', (req, res) => {
      res.write(middleware.fileSystem.readFileSync(path.join(__dirname, 'dist/index.html')));
      res.end();
    });

  } else {
    app.use(express.static(__dirname + '/dist'));
    app.use(express.static('public'));
    app.use('*', (req, res) => {
      res.sendFile(path.join(__dirname, 'dist/index.html'));
    });
  }

// Start the app server.
app.listen(APP_PORT, () => {
  console.log(`Relay app server listening at http://localhost:${APP_PORT}`)
})

