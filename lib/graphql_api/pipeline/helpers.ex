defmodule GraphqlApi.Pipeline.Helpers do
  @moduledoc """
  Helper functions for the consumer and the pipeline tests
  """
  alias GraphqlApi.{Config, TokenCache}

  @token_max_age Config.token_max_age()

  @spec token_and_timestamp_map :: TokenCache.token_cache_value()
  def token_and_timestamp_map do
    %{token: generate_token(), timestamp: DateTime.utc_now()}
  end

  @spec update_needed?(non_neg_integer) :: boolean
  def update_needed?(id) do
    case TokenCache.get(id) do
      %{timestamp: timestamp} -> check_expired(timestamp)
      nil -> true
    end
  end

  @spec maybe_send_sync(pid) :: :sync
  @doc """
  Provides a synchronization point for testing GenServers.
  Sends a message in test and noops in other environments

  assert_receive(:sync, 500) in test file
  """
  if Mix.env() === :test do
    def maybe_send_sync(pid), do: send(pid, :sync)
  else
    def maybe_send_sync(_pid), do: :sync
  end

  defp check_expired(timestamp) do
    if DateTime.diff(DateTime.utc_now(), timestamp, @token_max_age.unit) >= @token_max_age.amount do
      true
    else
      false
    end
  end

  defp generate_token do
    Base.encode32(:crypto.strong_rand_bytes(20), padding: false)
  end
end
