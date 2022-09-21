defmodule GraphqlApi.Pipeline.Helpers do
  alias GraphqlApi.{Config, TokenCache}

  @token_max_age Config.token_max_age()

  @spec token_and_timestamp_map :: %{timestamp: DateTime.t(), token: binary}
  def token_and_timestamp_map do
    %{token: generate_token(), timestamp: DateTime.utc_now()}
  end

  def update_needed?(id) do
    with %{timestamp: timestamp} <- TokenCache.get(id) do
      check_expired(timestamp)
    else
      nil -> true
    end
  end

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

  defp generate_token() do
    Base.encode32(:crypto.strong_rand_bytes(20), padding: false)
  end
end
