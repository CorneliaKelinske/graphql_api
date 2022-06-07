defmodule GraphqlApiWeb.Schema do
  @moduledoc false
  use Absinthe.Schema

  import_types GraphqlApiWeb.Types.Preference
  import_types GraphqlApiWeb.Types.User
  import_types GraphqlApiWeb.Schema.Queries.User
  import_types GraphqlApiWeb.Schema.Mutations.Preference
  import_types GraphqlApiWeb.Schema.Mutations.User
  import_types GraphqlApiWeb.Schema.Subscriptions.Preference
  import_types GraphqlApiWeb.Schema.Subscriptions.User

  query do
    import_fields :user_queries
  end

  mutation do
    import_fields :user_mutations
    import_fields :preference_mutations
  end

  subscription do
    import_fields :preference_subscriptions
    import_fields :user_subscriptions
  end
end
