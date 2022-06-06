defmodule GraphqlApiWeb.Schema do
  use Absinthe.Schema

  import_types GraphqlApiWeb.Types.Preference
  import_types GraphqlApiWeb.Types.User
  # import_types GraphqlApiWeb.Schema.Queries.Preference
  import_types GraphqlApiWeb.Schema.Queries.User
  import_types GraphqlApiWeb.Schema.Mutations.Preference
  import_types GraphqlApiWeb.Schema.Mutations.User

  query do
    # import_fields :preference_queries
    import_fields :user_queries
  end

  mutation do
    import_fields :user_mutations
    import_fields :preference_mutations
  end
end
