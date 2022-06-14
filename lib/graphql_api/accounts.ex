defmodule GraphqlApi.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias EctoShorts.Actions
  alias GraphqlApi.{Accounts.User, Accounts.Preference, Repo}

  defguard empty_map?(map) when map_size(map) === 0

  def all_users(params \\ %{}) do
    {:ok, Actions.all(User, params)}
  end

  def find_user(%{id: id}) do
    case Repo.get(User, id) do
      nil -> {:error, "no user with that id"}
      user -> {:ok, user}
    end
  end

  def update_user(_id, params) when empty_map?(params) do
    {:error, %{message: "no update params given", details: %{params: params}}}
  end

  def update_user(id, params) do
    with {:ok, user} <- find_user(%{id: id}) do
      user
      |> User.changeset(params)
      |> Repo.update()
    end
  end

  def create_user(params) do
    %User{}
    |> User.changeset(params)
    |> Repo.insert()
  end

  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  def all_preferences(params \\ %{}) do
    {:ok, Actions.all(Preference, params)}
  end

  def update_preferences(_id, params) when empty_map?(params) do
    {:error, %{message: "no update params given", details: %{params: params}}}
  end

  def update_preferences(id, params) do
    with {:ok, preferences} <- find_preferences_by_user_id(%{id: id}) do
      preferences
      |> Preference.changeset(params)
      |> Repo.update()
    end
  end

  def find_preferences_by_user_id(%{id: id}) do
    case Repo.get_by(Preference, user_id: id) do
      nil -> {:error, "no preferences found for this user ID"}
      preferences -> {:ok, preferences}
    end
  end
end
