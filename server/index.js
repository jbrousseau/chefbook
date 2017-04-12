import path from 'path'
import dotenv from 'dotenv'
import webpack from 'webpack'
import WebpackDevServer from 'webpack-dev-server'
import postgraphql from 'postgraphql'
import webpackConfig from '../config/webpack.config'

// Load the config from .env file.
dotenv.load()
const {
  APP_PORT,
  APP_HOST,
  DB_STRING,
  DB_SCHEMA,
  SECRET,
  DEFAULT_ROLE,
  JWT_TOKEN_IDENTIFIER,
  IS_DEV_ENV
} = process.env

// we compile the frontend with webpack/babel
const compiler = webpack(webpackConfig)

// This allows use compile the front-end app on the fly.
// Do not use this in production!
const app = new WebpackDevServer(compiler, {
  contentBase: '/public/',
  publicPath: '/static/',
  noInfo: true,
  stats: { colors: true },
})

// Mount the postgraphql as middleware.
app.use(postgraphql(DB_STRING, DB_SCHEMA, {
      pgDefaultRole: DEFAULT_ROLE,
      classicIds: true,
      graphiql: IS_DEV_ENV=="true"?true:false,
      jwtSecret: SECRET,
      jwtPgTypeIdentifier: "chefbook.jwt_token",
}))

// Any other path will match this and will load the index.html file.
app.use('*', (req, res) => {
  res.sendFile(path.resolve(__dirname, 'public/index.html'))
})

// Start the app server.
app.listen(APP_PORT, () => {
  console.log(`Relay app server listening at http://${APP_HOST}:${APP_PORT}`)
})
