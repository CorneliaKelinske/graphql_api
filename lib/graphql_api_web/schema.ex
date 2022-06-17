defmodule GraphqlApiWeb.Schema do
  @moduledoc false
  use Absinthe.Schema
  alias GraphqlApiWeb.Middlewares.HandleErrors

  import_types GraphqlApiWeb.Types.Preference
  import_types GraphqlApiWeb.Types.User
  import_types GraphqlApiWeb.Schema.Queries.Preference
  import_types GraphqlApiWeb.Schema.Queries.User
  import_types GraphqlApiWeb.Schema.Mutations.Preference
  import_types GraphqlApiWeb.Schema.Mutations.User
  import_types GraphqlApiWeb.Schema.Subscriptions.Preference
  import_types GraphqlApiWeb.Schema.Subscriptions.User

  query do
    import_fields :preference_queries
    import_fields :user_queries
  end

  mutation do
    import_fields :preference_mutations
    import_fields :user_mutations
  end

  subscription do
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

  def middleware(middleware, _field, _) do
    middleware ++ [HandleErrors]
  end
end
