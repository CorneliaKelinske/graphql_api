defmodule GraphqlApi.Pipeline.Consumer do
  use GenStage

  alias GraphqlApi.{Pipeline.Helpers, TokenCache}

  def start_link(_opts) do
    GenStage.start_link(__MODULE__, :ok)
  end

  def init(state) do
    {:consumer, state, subscribe_to: [GraphqlApi.Pipeline.Producer]}
  end

  def handle_events(events, _from, state) do

    Enum.each(events, & TokenCache.put(&1, Helpers.token_and_timestamp_map))
    


    {:noreply, [], state}
  end



end
