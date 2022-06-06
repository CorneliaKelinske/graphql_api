defmodule GraphqlApiWeb.Schema do
  use Absinthe.Schema

  import_types GraphqlApiWeb.Types.User
  import_types GraphqlApiWeb.Schema.Queries.User

  query do
    import_fields :user_queries
  end
end
