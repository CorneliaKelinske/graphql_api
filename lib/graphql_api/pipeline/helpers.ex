defmodule GraphqlApi.Pipeline.Helpers do
  

  @spec token_and_timestamp_map :: %{timestamp: DateTime.t(), token: binary}
  def token_and_timestamp_map do
    %{token: generate_token(), timestamp: DateTime.utc_now()}
  end


  defp generate_token() do
    Base.encode32(:crypto.strong_rand_bytes(8), padding: false)
  end
end
