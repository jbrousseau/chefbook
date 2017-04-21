import React from 'react'
import Relay from 'react-relay'
import { StyleSheet, css } from 'aphrodite'
import RecipeItem from '../components/RecipeItem'
import RecipeForm from '../components/RecipeForm'
import ScrollBottomNotifier from '../utils/ScrollBottomNotifier'
import { CreateRecipeMutation } from '../mutations'

class RecipeIndex extends React.Component {
  state = {
    addingRecipe: false,
    loading: false,
  }

  insertRecipe = (data) => {
    this.props.relay.commitUpdate(
      new CreateRecipeMutation({
        query: this.props.query,
        recipe: data,
      }), {
      onSuccess: () => this.setAddingRecipe(false),
    })
  }

  setAddingRecipe = (event, value) => {
    const { addingRecipe } = this.state
    this.setState({ addingRecipe: value || !addingRecipe })
  }

  handleScrollBottom = () => {
    const { relay, query } = this.props
    relay.setVariables({
      count: relay.variables.count + 5,
    }, ({ready, done, error, aborted}) => {
      this.setState({
        loading: !ready && !(done || error || aborted)
      })
    })
  }

  renderRecipeForm() {
    return (
      <div>
        <button onClick={this.setAddingRecipe}>
          {this.state.addingRecipe ? 'Cancel' : 'Add Recipe'}
        </button>
        {this.state.addingRecipe &&
          <RecipeForm
            currentPerson={this.props.currentPerson}
            onSubmit={this.insertRecipe}
          />
        }
      </div>
    )
  }

  render() {
    const { recipes } = this.props.query

    return (
      <div>
        <h1>Recipes</h1>
        {this.props.currentPerson && this.renderRecipeForm()}
        <ScrollBottomNotifier onScrollBottom={this.handleScrollBottom}>
          {recipes.edges.length && recipes.edges.map(({ node: recipe }) =>
            <div key={recipe.id}>
              <RecipeItem {...recipe}/>
            </div>
          )}
        </ScrollBottomNotifier>
      </div>
    )
  }
}

export default Relay.createContainer(RecipeIndex, {
  initialVariables: {
    count: 5,
  },
  fragments: {
    query: () => Relay.QL`
      fragment on Query {
        recipes: allRecipes(
          first: $count
          orderBy: CREATED_AT_DESC
        ) {
          pageInfo {
            hasNextPage
            hasPreviousPage
          }
          totalCount
          edges {
            node {
              id
              title
              score
              createdAt
              updatedAt
              author: personByAuthorId {
                fullName
              }
            }
          }
        }
        ${CreateRecipeMutation.getFragment('query')}
      }
    `,
  },
})
