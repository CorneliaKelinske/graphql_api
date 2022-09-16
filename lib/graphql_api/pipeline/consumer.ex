defmodule GraphqlApi.Pipeline.Consumer do
  use GenStage

  def start_link(_opts) do
    GenStage.start_link(__MODULE__, :ok)
  end

  def init(state) do
    {:consumer, state, subscribe_to: [GraphqlApi.Pipeline.Producer]}
  end

  def handle_events(events, _from, state) do
    for event <- events do
      IO.inspect({self(), event, state})
    end

    {:noreply, [], state}
  end
end
