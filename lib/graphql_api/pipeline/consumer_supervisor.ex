defmodule GraphqlApi.Pipeline.ConsumerSupervisor do
  use ConsumerSupervisor


  def start_link(_) do
    ConsumerSupervisor.start_link(__MODULE__, :ok)
  end

  def init(:ok) do
    children = [
      %{
      id: GraphqlApi.Pipeline.Consumer,
          start: {GraphqlApi.Pipeline.Consumer, :start_link, []},
          restart: :transient
      }
    ]

    opts = [
      strategy: :one_for_one,
      subscribe_to: [
        GraphqlApi.Pipeline.Producer
      ]
    ]

    ConsumerSupervisor.init(children, opts)
  end

end
