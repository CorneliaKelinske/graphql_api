defmodule GraphqlApi.Accounts do
  @moduledoc """
  The Accounts context.
  """

  alias EctoShorts.Actions
  alias GraphqlApi.{Accounts.Preference, Accounts.User, Repo}

  @type error :: ErrorMessage.t()
  @preference_params Preference.required_params()

  @spec all_users(map) :: [User.t()]

  def all_users(params) do
    user_params = Map.drop(params, @preference_params)

    params
    |> Map.take(@preference_params)
    |> Enum.reduce(User.join_preferences(), fn
      filter, acc -> User.by_preferences(acc, filter)
    end)
    |> Actions.all(user_params)
  end

  @spec find_user(map) :: {:ok, User.t()} | {:error, error()}
  def find_user(params) do
    Actions.find(User, params)
  end

  @spec update_user(pos_integer, map) :: {:ok, User.t()} | {:error, error | Ecto.Changeset.t()}
  def update_user(id, params) do
    with {:ok, user} <- find_user(%{id: id}) do
      user
      |> Repo.preload(:preferences)
      |> then(&Actions.update(User, &1, params))
    end
  end

  @spec create_user(map) :: {:ok, User.t()} | {:error, Ecto.Changeset.t()}
  def create_user(params) do
    Actions.create(User, params)
  end

  @spec delete_user(User.t()) :: {:ok, User.t()} | {:error, Ecto.Changeset.t()}
  def delete_user(%User{} = user) do
    Actions.delete(user)
  end

  @spec all_preferences(map) :: [Preference.t()]
  def all_preferences(params \\ %{}) do
    Actions.all(Preference, params)
  end

  @spec update_preferences(String.t(), map) ::
          {:ok, Preference.t()} | {:error, error | Ecto.Changeset.t()}

  def update_preferences(user_id, params) do
    with {:ok, preference} <- find_preferences(%{user_id: user_id}) do
      Actions.update(Preference, preference, params)
    end
  end

  @spec find_preferences(map) :: {:ok, Preference.t()} | {:error, error()}
  def find_preferences(params) do
    Actions.find(Preference, params)
  end
end
