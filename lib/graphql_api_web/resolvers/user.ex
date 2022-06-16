defmodule GraphqlApiWeb.Resolvers.User do
  @moduledoc false
  alias GraphqlApi.{Accounts, Accounts.User}

  @type resolution :: Absinthe.Resolution.t()
  @type error :: GraphqlApi.Accounts.error()

  @spec all(map, resolution()) :: {:ok, [User.t()]} | {:error, error}
  def all(params, _) do
    Accounts.all_users(params)
  end

  @spec find(map, resolution()) :: {:ok, User.t()} | {:error, error}
  def find(params, _) do
    Accounts.find_user(params)
  end

  @spec create_user(any, map, resolution()) :: {:ok, User.t()} | {:error, Ecto.Changeset.t()}
  def create_user(_, params, _) do
    Accounts.create_user(params)
  end

  @spec update_user(%{id: String.t()}, resolution()) ::
          {:ok, User.t()} | {:error, error | Ecto.Changeset.t()}
  def update_user(%{id: id} = params, _) do
    id
    |> String.to_integer()
    |> Accounts.update_user(Map.delete(params, :id))
  end
end
