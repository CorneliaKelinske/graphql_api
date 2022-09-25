defmodule GraphqlApiWeb.Schema do
  @moduledoc false
  use Absinthe.Schema
  alias GraphqlApiWeb.Middlewares.{Authentication, HandleErrors}

  import_types GraphqlApiWeb.Types.AuthToken
  import_types GraphqlApiWeb.Types.Custom
  import_types GraphqlApiWeb.Types.Preference
  import_types GraphqlApiWeb.Types.User
  import_types GraphqlApiWeb.Types.Request
  import_types GraphqlApiWeb.Types.ResolverHit
  import_types GraphqlApiWeb.Schema.Queries.AuthToken
  import_types GraphqlApiWeb.Schema.Queries.Preference
  import_types GraphqlApiWeb.Schema.Queries.User
  import_types GraphqlApiWeb.Schema.Queries.ResolverHit
  import_types GraphqlApiWeb.Schema.Mutations.Preference
  import_types GraphqlApiWeb.Schema.Mutations.User
  import_types GraphqlApiWeb.Schema.Subscriptions.AuthToken
  import_types GraphqlApiWeb.Schema.Subscriptions.Preference
  import_types GraphqlApiWeb.Schema.Subscriptions.User

  query do
    import_fields :auth_token_queries
    import_fields :preference_queries
    import_fields :user_queries
    import_fields :resolver_hit_queries
  end

  mutation do
    import_fields :preference_mutations
    import_fields :user_mutations
  end

  subscription do
    import_fields :auth_token_subscriptions
    import_fields :preference_subscriptions
    import_fields :user_subscriptions
  end

  def context(ctx) do
    source = Dataloader.Ecto.new(GraphqlApi.Repo)
    dataloader = Dataloader.add_source(Dataloader.new(), GraphqlApi.Accounts, source)
    Map.put(ctx, :loader, dataloader)
  end

  def plugins do
    [Absinthe.Middleware.Dataloader] ++ Absinthe.Plugin.defaults()
  end

  def middleware(middleware, _, %{identifier: :mutation}) do
    [Authentication | middleware] ++ [HandleErrors]
  end

  def middleware(middleware, _, %{identifier: identifier})
      when identifier in [:query, :subscription] do
    middleware ++ [HandleErrors]
  end

  def middleware(middleware, _, _) do
    middleware
  end
end
