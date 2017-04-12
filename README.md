# Chefbook


*An application with recipes to cook.*


## Installation

First, install postgraphql
see here : [installation of postgraphql](https://github.com/postgraphql/postgraphql/blob/master/README.md).

next, execute the command, to create database postgresql : 
```bash
npm run schema

```

Run postgraphql for the middleware :

```bash
postgraphql -s chefbook -c postgres://ubuntu:test@localhost:5432 -n 0.0.0.0 -p 8080 -e A_PASSWORD_FOR_PROD -t chefbook.jwt_token -r chefbook_anonymous
```
