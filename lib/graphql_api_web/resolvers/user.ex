defmodule GraphqlApiWeb.Resolvers.User do
  @moduledoc false
  alias GraphqlApi.{Accounts, Accounts.User, HitTracker}

  @type resolution :: Absinthe.Resolution.t()
  @type error :: GraphqlApi.Accounts.error()

  @spec all(map, resolution()) :: {:ok, [User.t()]} | {:error, error}
  def all(params, _) do
    HitTracker.add_hit(:users)
    {:ok, Accounts.all_users(params)}
  end

  @spec find(map, resolution()) :: {:ok, User.t()} | {:error, error}
  def find(params, _) do
    HitTracker.add_hit(:user)
    Accounts.find_user(params)
  end

  @spec create_user(map, resolution()) :: {:ok, User.t()} | {:error, Ecto.Changeset.t()}
  def create_user(params, _) do
    HitTracker.add_hit(:create_user)
    Accounts.create_user(params)
  end

  @spec update_user(%{id: String.t()}, resolution()) ::
          {:ok, User.t()} | {:error, error | Ecto.Changeset.t()}
  def update_user(%{id: id} = params, _) do
    HitTracker.add_hit(:update_user)

    id
    |> String.to_integer()
    |> Accounts.update_user(Map.delete(params, :id))
  end
end
