defmodule GraphqlApiWeb.Types.User do
  @moduledoc false
  use Absinthe.Schema.Notation

  import Absinthe.Resolution.Helpers, only: [dataloader: 2]
  alias GraphqlApi.TokenCache

  @desc "A user with notification preferences"
  object :user do
    field :id, non_null(:id)
    field :name, non_null(:string)
    field :email, non_null(:string)
    field :auth_token, :string do
      resolve fn user, _, _ ->  get_auth_token(user) end
    end

    field :preferences, non_null(:preferences),
      resolve: dataloader(GraphqlApi.Accounts, :preferences)
  end

  defp get_auth_token(%{id: id}) do
    case TokenCache.get(id) do
      %{token: token} -> {:ok, token}
      _ -> {:ok, nil}
    end
  end
end
