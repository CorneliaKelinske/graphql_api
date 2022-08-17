# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :graphql_api,
  ecto_repos: [GraphqlApi.Repo]

config :graphql_api,
  secret_key: "Imsecret"

config :ecto_shorts,
  repo: GraphqlApi.Repo,
  error_module: EctoShorts.Actions.Error

# Configures the endpoint
config :graphql_api, GraphqlApiWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [view: GraphqlApiWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: GraphqlApi.PubSub,
  live_view: [signing_salt: "TPx5kd1Z"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
