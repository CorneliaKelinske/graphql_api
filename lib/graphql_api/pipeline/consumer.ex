defmodule GraphqlApi.Pipeline.Consumer do
  @moduledoc """
  Checks if user's auth token is expired and if so, updates the auth token
  """

  alias GraphqlApi.{Pipeline.Helpers, TokenCache}

  @spec start_link(pid, non_neg_integer()) :: {:ok, pid}
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
