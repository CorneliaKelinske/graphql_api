defmodule GraphqlApiWeb.Router do
  use GraphqlApiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/" do
    pipe_through :api

    forward "/graphql", Absinthe.Plug, schema: GraphqlApiWeb.Schema

    if Mix.env() === :dev do
      forward "/graphiql", Absinthe.Plug.GraphiQL,
        schema: GraphqlApiWeb.Schema,
        interface: :playground
    #     #context: %{pubsub: CommunityWeb.Endpoint}
    end
  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
end
