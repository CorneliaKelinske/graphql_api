defmodule GraphqlApiWeb.Resolvers.User do
  @moduledoc false
  alias GraphqlApi.{Accounts, Accounts.User, HitCounter, TokenCache}

  @type resolution :: Absinthe.Resolution.t()
  @type error :: GraphqlApi.Accounts.error()

  @spec all(map, resolution()) :: {:ok, [User.t()]} | {:error, error}
  def all(params, _) do
    HitCounter.add_hit(:users)
    {:ok, Accounts.all_users(params)}
  end

  @spec find(map, resolution()) :: {:ok, User.t()} | {:error, error}
  def find(params, _) do
    HitCounter.add_hit(:user)
    Accounts.find_user(params)
  end

  @spec create_user(map, resolution()) :: {:ok, User.t()} | {:error, Ecto.Changeset.t()}
  def create_user(params, _) do
    HitCounter.add_hit(:create_user)
    Accounts.create_user(params)
  end

  @spec update_user(%{id: String.t()}, resolution()) ::
          {:ok, User.t()} | {:error, error | Ecto.Changeset.t()}
  def update_user(%{id: id} = params, _) do
    HitCounter.add_hit(:update_user)
    :counters.add(:persistent_term.get(:hit_counter), 8, 1)

    id
    |> String.to_integer()
    |> Accounts.update_user(Map.delete(params, :id))
  end

  def get_user_token(%{id: id}, _) do
    case TokenCache.get(id) do
      %{token: token} -> {:ok, token}
      _ -> nil
    end
  end
end
