defmodule GraphqlApiWeb.Resolvers.User do
  @moduledoc false
  alias GraphqlApi.Accounts

  @type resolution :: Absinthe.Resolution.t()
  @type user :: GraphqlApi.Accounts.user()
  @type error :: GraphqlApi.Accounts.error()

  @spec all(map, resolution()) :: {:ok, [user()]} | {:error, error}
  def all(params, _) do
    Accounts.all_users(params)
  end

  def find(params, _) do
    Accounts.find_user(params)
  end

  @spec create_user(map, resolution()) :: {:ok, user} | {:error, error}
  def create_user(params, _) do
    Accounts.create_user(params)
  end

  @spec update_user(%{id: String.t()}, resolution()) :: {:ok, user} | {:error, error}
  def update_user(%{id: id} = params, _) do
    id
    |> String.to_integer()
    |> Accounts.update_user(Map.delete(params, :id))
  end
end
