defmodule GraphqlApiWeb.Resolvers.AuthToken do
  @moduledoc false

  alias GraphqlApi.TokenCache
  @type resolution :: Absinthe.Resolution.t()
  @type auth_token :: %{timestamp: DateTime.t(), token: String.t(), user_id: non_neg_integer()}

  @spec get_auth_token(%{:user_id => String.t() | non_neg_integer()}, resolution()) ::
          {:ok, nil | auth_token()}
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

  @spec find_user_token(%{:id => non_neg_integer()}, any, resolution()) ::
          {:ok, nil | auth_token()}
  def find_user_token(%{id: id}, _, resolution) do
    get_auth_token(%{user_id: id}, resolution)
  end

  defp maybe_convert_id(id) when is_binary(id) do
    String.to_integer(id)
  end

  defp maybe_convert_id(id), do: id
end
