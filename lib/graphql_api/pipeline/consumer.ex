defmodule GraphqlApi.Pipeline.Consumer do
  use GenStage

  alias GraphqlApi.{Pipeline.Helpers, TokenCache}

  def start_link(caller) when is_pid(caller) do
    GenStage.start_link(__MODULE__, caller)
  end

  def init(caller) when is_pid(caller) do
    {:consumer, caller, subscribe_to: [GraphqlApi.Pipeline.Producer]}
  end

  def handle_events(events, _from, caller) do
    events =
      events
      |> Enum.filter(&Helpers.update_needed?(&1))
      |> List.flatten()
      |> dbg()

    if events !== [] do
      Enum.each(events, &TokenCache.put(&1, Helpers.token_and_timestamp_map()))
    end

    Helpers.maybe_send_sync(caller)
    {:noreply, [], caller}
  end
end
