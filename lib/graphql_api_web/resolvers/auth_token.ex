defmodule GraphqlApiWeb.Resolvers.AuthToken do
  @moduledoc false

  alias GraphqlApi.TokenCache

  def get_auth_token(%{user_id: user_id}, _) do
    user_id
    |> maybe_convert_id()
    |> TokenCache.get()
    |> case do
      nil ->
        {:ok, nil}

      %{token: _token, timestamp: _timestamp} = auth_token ->
        {:ok, Map.merge(auth_token, %{user_id: user_id})}
    end
  end

  def find_user_token(%{id: id}, _, resolution) do
    get_auth_token(%{user_id: id}, resolution)
  end

  defp maybe_convert_id(id) when is_binary(id) do
    String.to_integer(id)
  end

  defp maybe_convert_id(id), do: id
end
