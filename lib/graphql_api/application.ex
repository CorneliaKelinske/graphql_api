defmodule GraphqlApi.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    topologies = [
      example: [
        strategy: Cluster.Strategy.Epmd,
        config: [hosts: [:node_a@localhost, :node_b@localhost]]
      ]
    ]

    GraphqlApi.HitCounter.setup_counter()

    children =
      [
        {Cluster.Supervisor, [topologies, [name: GraphqlApi.ClusterSupervisor]]},
        # Start the Ecto repository
        GraphqlApi.Repo,
        # Start the Telemetry supervisor
        GraphqlApiWeb.Telemetry,
        # Start the PubSub system
        {Phoenix.PubSub, name: GraphqlApi.PubSub},
        # Start the Endpoint (http/https)
        GraphqlApiWeb.Endpoint,
        {Absinthe.Subscription, [GraphqlApiWeb.Endpoint]},
        GraphqlApi.TokenCache
      ] ++ pipeline()

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: GraphqlApi.Supervisor]
    Supervisor.start_link(children, opts)
  end

  if Mix.env() === :test do
    def pipeline, do: []
  else
    def pipeline do
      [
        {GraphqlApi.Pipeline.Producer, self()},
        {GraphqlApi.Pipeline.ConsumerSupervisor, self()}
      ]
    end
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    GraphqlApiWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
