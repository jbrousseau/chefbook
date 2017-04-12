import './styles.css' // global css
import React from 'react'
import Relay from 'react-relay'
import { render } from 'react-dom'
import { Router, Route, Redirect, IndexRoute, browserHistory, applyRouterMiddleware } from 'react-router'
import useRelay from 'react-router-relay'
import App from './components/App'
import HomePage from './containers/HomePage'
import RecipeIndexPage from './containers/RecipeIndexPage'
import RecipePage from './containers/RecipePage'
import RegisterPage from './containers/RegisterPage'
import LoginPage from './containers/LoginPage'
import {
  homeQueries,
  recipeIndexQueries,
  recipeQueries,
} from './queries'

const routes = (
  <Route path="/" component={App}>
    <IndexRoute component={HomePage} queries={homeQueries}/>
    <Route path="recipes">
      <IndexRoute component={RecipeIndexPage} queries={recipeIndexQueries}/>
      <Route path=":recipeId" component={RecipePage} queries={recipeQueries}/>
    </Route>
    <Route path="login" component={LoginPage}/>
    <Route path="register" component={RegisterPage}/>
  </Route>
)

const mountNode = document.getElementById('root')

render(
  <Router
    history={browserHistory}
    routes={routes}
    render={applyRouterMiddleware(useRelay)}
    environment={Relay.Store}
  />,
  mountNode
)
