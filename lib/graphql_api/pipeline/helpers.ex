defmodule GraphqlApi.Pipeline.Helpers do
  alias GraphqlApi.TokenCache


  @spec token_and_timestamp_map :: %{timestamp: DateTime.t(), token: binary}
  def token_and_timestamp_map do
    %{token: generate_token(), timestamp: DateTime.utc_now()}
  end

  def update_needed?(id) do
    with %{timestamp: timestamp} <- TokenCache.get(id) do
      check_expired(id, timestamp)
    else
      nil -> id
    end
  end


  defp check_expired(id, timestamp) do
    if DateTime.diff(DateTime.utc_now(), timestamp, :hour) >= 24 do
      id
    else
      []
    end
  end

  defp generate_token() do
    Base.encode32(:crypto.strong_rand_bytes(8), padding: false)
  end
end
