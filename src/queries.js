import Relay from 'react-relay'

export const homeQueries = {
  query: () => Relay.QL`query { query }`,
}

export const recipeIndexQueries = {
  query: () => Relay.QL`query { query }`,
}

export const recipeQueries = {
  query: () => Relay.QL`query { query }`,
  recipe: () => Relay.QL`query { recipe(id: $recipeId) }`,
}
