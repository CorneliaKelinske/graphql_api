defmodule GraphqlApi.Pipeline.ConsumerSupervisor do
  @moduledoc false
  use ConsumerSupervisor

  @spec start_link(pid) :: :ignore | {:error, any} | {:ok, pid}
  def start_link(caller) when is_pid(caller) do
    ConsumerSupervisor.start_link(__MODULE__, caller)
  end

  @impl ConsumerSupervisor
  def init(caller) when is_pid(caller) do
    children = [
      %{
        id: GraphqlApi.Pipeline.Consumer,
        start: {GraphqlApi.Pipeline.Consumer, :start_link, [caller]},
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
