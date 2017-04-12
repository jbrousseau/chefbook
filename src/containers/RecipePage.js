import React from 'react'
import Relay from 'react-relay'
import { Link, withRouter } from 'react-router'
import { StyleSheet, css } from 'aphrodite'
import ContentEditable from '../components/ContentEditable'
import { UpdateRecipeMutation, DeleteRecipeMutation } from '../mutations'

class RecipePage extends React.Component {
  render() {
    const { currentPerson, recipe } = this.props
    const authAndOwn = currentPerson && currentPerson.person_id === recipe.authorId

    return (
      <article>
        <Link to="/recipes">back to Recipes</Link>
        <header>
          <ContentEditable
            editable={authAndOwn}
            onChange={this.handleChange} 
            tagName="h1"
            text={recipe.title}
            data-prop="title"
          />
          <p>by {recipe.author.fullName}</p>
        </header>
        <ContentEditable
          editable={authAndOwn}
          onChange={this.handleChange} 
          tagName="div"
          text={recipe.score}
          data-prop="score"
        />
        <footer>
          {authAndOwn &&
            <button onClick={this.handleDelete}>Delete Recipe</button>
          }
        </footer>
      </article>
    )
  }

  handleChange = event => {
    const propName = event.target.dataset.prop
    const newValue = event.target.innerText
    const oldValue = this.props.post[propName]

    if (newValue === oldValue) return

    this.props.relay.commitUpdate(
      new UpdateRecipeMutation({
        post: this.props.post,
        postPatch: { [propName]: newValue },
      })
    )
  }

  handleDelete = event => {
    this.props.router.push('/recipes')
    this.props.relay.commitUpdate(
      new DeleteRecipeMutation({
        query: this.props.query,
        post: this.props.post,
      })
    )
  }

}

export default Relay.createContainer(withRouter(RecipePage), {
  fragments: {
    query: () => Relay.QL`
      fragment on Query {
        ${DeleteRecipeMutation.getFragment('query')}
      }
    `,
    recipe: () => Relay.QL`
      fragment on Recipe {
        title
        score
        authorId
        author: personByAuthorId {
          fullName
        }
        ${UpdateRecipeMutation.getFragment('recipe')}
        ${DeleteRecipeMutation.getFragment('recipe')}
      }
    `,
  },
})
