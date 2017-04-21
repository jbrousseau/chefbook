import React from 'react'
import Relay from 'react-relay'
import { Link } from 'react-router'

class HomePage extends React.Component {
  render() {
    return (
      <div>
        <h1>Newest Recipes</h1>
        <ul>
          {this.props.query.newestRecipes.edges.map(({ node }) => {
            return <li key={node.id}>
              <Link to={`/recipes/${node.id}`}>{node.title} posted on {node.createdAt}</Link> 
              by {node.author.fullName}
            </li>
          })}
        </ul>

        <h1>Newest Users</h1>
        <ul>
          {this.props.query.newestUsers.edges.map(({ node }) => {
            return <li key={node.id}>
              {node.fullName} joined on {node.createdAt}
            </li>
          })}
        </ul>
      </div>
    )
  }
}

export default Relay.createContainer(HomePage, {
  fragments: {
    query: () => Relay.QL`
      fragment on Query {
        newestRecipes: allRecipes(orderBy: CREATED_AT_DESC, first: 5) {
          edges {
            node {
              id
              title
              author: personByAuthorId {
                fullName
              }
              createdAt
            }
          }
        }
        newestUsers: allPeople(orderBy: CREATED_AT_DESC, first: 5) {
          edges {
            node {
              id
              fullName
              createdAt
            }
          }
        }
      }
    `,
  },
})
