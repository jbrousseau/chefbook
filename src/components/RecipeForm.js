import React from 'react'
import { StyleSheet, css } from 'aphrodite'

class RecipeForm extends React.Component {
  fields = {}

  handleSubmit = (event) => {
    event.preventDefault()
    const data = {
      authorId: this.props.currentPerson.person_id,
      title: this.fields.title.value,
    }
    this.props.onSubmit(data)
  }

  render() {
    const { onSubmit, recipe } = this.props
    return (
      <form onSubmit={this.handleSubmit}>
        <div>
          <label htmlFor="headline">Title</label>
          <input ref={(ref) => this.fields.title = ref} id="headline" type="text" defaultValue={recipe && recipe.title}/>
        </div>
        <input type="submit" value="Submit Recipe"/>
      </form>
    )
  }
}

export default RecipeForm
