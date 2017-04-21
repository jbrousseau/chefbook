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
          <label htmlFor="title">Title</label>
          <input ref={(ref) => this.fields.title = ref} id="title" type="text" defaultValue={recipe && recipe.title}/>
        </div>
        <div>
          <label htmlFor="cooktime">Cook time</label>
          <input ref={(ref) => this.fields.cookTime = ref} id="title" type="text" defaultValue={recipe && recipe.cookTime}/>
        </div>
        <div>
          <label htmlFor="setuptime">Setup time</label>
          <input ref={(ref) => this.fields.setupTime = ref} id="title" type="text" defaultValue={recipe && recipe.setupTime}/>
        </div>
        <div>
          <label htmlFor="category">Category</label>
          <input ref={(ref) => this.fields.setupTime = ref} id="title" type="text" defaultValue={recipe && recipe.setupTime}/>
        </div>
        <input type="submit" value="Submit Recipe"/>
      </form>
    )
  }
}

export default RecipeForm
