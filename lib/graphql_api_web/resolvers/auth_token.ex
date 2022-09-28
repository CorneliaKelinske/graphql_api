defmodule GraphqlApiWeb.Resolvers.AuthToken do
  @moduledoc false

  alias GraphqlApi.{HitCounter, TokenCache}
  @type resolution :: Absinthe.Resolution.t()
  @type auth_token :: %{timestamp: DateTime.t(), token: String.t(), user_id: non_neg_integer()}

  @spec get_auth_token(%{:user_id => String.t()}, resolution()) :: {:ok, nil | auth_token()}
  def get_auth_token(%{user_id: user_id}, _) do
    HitCounter.add_hit(:auth_token)

    user_id
    |> String.to_integer()
    |> retrieve_token_from_cache()
  end

  @spec find_user_token(%{:id => non_neg_integer()}, any, resolution()) ::
          {:ok, nil | auth_token()}
  def find_user_token(%{id: id}, _, _) do
    retrieve_token_from_cache(id)
  end

  defp retrieve_token_from_cache(user_id) do
    case TokenCache.get(user_id) do
      nil ->
        {:ok, nil}

      %{token: _token, timestamp: _timestamp} = auth_token ->
        {:ok, Map.merge(auth_token, %{user_id: user_id})}
    end
  end
end
