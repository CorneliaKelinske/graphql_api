Using the project with `User`s that were fitted with Ecto, we're going to add some new functionality to our application, for each request that goes to our GraphQL server, we're going to store it's hit to an aggregate of all hits to that resolver. This should be stored inside a process, and be ephemeral data. It should store data in the format of 

%{"create_user" => 10}
To view this data we're going to create a GraphQL query for viewing a resolvers hits

query {
  resolverHits(key: "create_user")
}
*Hint: Because field returns are types, we can specify :integer as a return type



Lastly, we're going to write integration tests for all your queries, mutations and subscriptions as well as for our ephemeral data holding process.

