defmodule GraphqlApi.Pipeline.Consumer do


  alias GraphqlApi.{Pipeline.Helpers, TokenCache}

  def start_link(caller, event) do
    Task.start_link(fn ->
      handle_event(caller, event)
    end)
  end


  defp handle_event(caller, event) do
   if Helpers.update_needed?(event) === true do
    TokenCache.put(event, Helpers.token_and_timestamp_map())
   end



   Helpers.maybe_send_sync(caller)


  end
end
