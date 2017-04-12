import Relay from 'react-relay'

export class UpdateRecipeMutation extends Relay.Mutation {
  // The update mutation depends on the Recipe `id` and `rowId` so we declare it here.
  static fragments = {
    recipe: () => Relay.QL`
      fragment on Recipe {
        id,
        rowId,
      }
    `,
  }

  // This method should return a GraphQL operation that represents
  // the mutation to be performed.
  getMutation() {
    return Relay.QL`mutation { updateRecipeByRowId }`
  }

  // This method is used to prepare the variables that will be used as
  // input to the mutation.
  getVariables() {
    const { recipe, recipePatch } = this.props
    return {
      rowId: recipe.rowId,
      recipePatch,
    }
  }

  // Represents every field in your data model that could change
  // as a result of this mutation.
  getFatQuery() {
    return Relay.QL`
      fragment on UpdateRecipePayload {
        recipe {
          title,
          score,
          updatedAt,
        },
      }
    `
  }

  // This tells relay how to handle the payload of the update mutation.
  getConfigs() {
    return [{
      type: 'FIELDS_CHANGE',
      fieldIDs: {
        recipe: this.props.recipe.id,
      },
    }]
  }
}

export class DeleteRecipeMutation extends Relay.Mutation {
  static fragments = {
    recipe: () => Relay.QL`fragment on Recipe { rowId }`,
    query: () => Relay.QL`fragment on Query { id }`,
  }

  getMutation() {
    return Relay.QL`mutation { deleteRecipeByRowId }`
  }

  getConfigs() {
    return [{
      type: 'NODE_DELETE',
      parentName: 'query',
      parentID: this.props.query.id,
      connectionName: 'allRecipes',
      deletedIDFieldName: 'deletedRecipeId',
    }]
  }

  getVariables() {
    return {
      rowId: this.props.recipe.rowId
    }
  }

  getFatQuery() {
    return Relay.QL`
      fragment on DeleteRecipePayload {
        deletedRecipeId,
        query { allRecipes },
      }
    `
  }
}

export class CreateRecipeMutation extends Relay.Mutation {
  static fragments = {
    query: () => Relay.QL`fragment on Query { id }`,
  }

  getMutation() {
    return Relay.QL`mutation { createRecipe }`
  }

  getConfigs() {
    return [{
      type: 'RANGE_ADD',
      parentName: 'query',
      parentID: this.props.query.id,
      connectionName: 'allRecipes',
      edgeName: 'recipeEdge',
      rangeBehaviors: {
        '': 'append',
        'orderBy(CREATED_AT_DESC)': 'prepend',
      },
    }]
  }

  getVariables() {
    return {
      recipe: this.props.recipe
    }
  }

  getFatQuery() {
    return Relay.QL`
      fragment on CreateRecipePayload {
        recipeEdge
        query {
          allRecipes
        }
      }
    `
  }
}

export class RegisterPersonMutation extends Relay.Mutation {
  getMutation() {
    return Relay.QL`mutation { registerPerson }`
  }

  getConfigs() {
    return [{
      type: 'REQUIRED_CHILDREN',
      children: [
        Relay.QL`
          fragment on RegisterPersonPayload {
            person {
              firstName
              lastName
            }
          } 
        ` 
      ],
    }]
  }

  getVariables() {
    return { ...this.props.person }
  }

  getFatQuery() {
    return Relay.QL`
      fragment on RegisterPersonPayload {
        person
      }
    `
  }
}

export class AuthenticatePersonMutation extends Relay.Mutation {
  getMutation() {
    return Relay.QL`mutation { authenticate }`
  }

  getConfigs() {
    return [{
      type: 'REQUIRED_CHILDREN',
      children: [
        Relay.QL`
          fragment on AuthenticatePayload {
            jwtToken
          } 
        ` 
      ],
    }]
  }

  getVariables() {
    return { ...this.props.login }
  }

  getFatQuery() {
    return Relay.QL`
      fragment on AuthenticatePayload {
        jwtToken
      }
    `
  }
}
