defmodule GraphqlApi.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias GraphqlApi.{Accounts.User, Accounts.Preference, Repo}

  def list_users() do
    {:ok, Repo.all(User)}
  end

  def find_user(%{id: id}) do
    case Repo.get(User, id) do
      nil -> {:error, "no user with that id"}
      user -> {:ok, user}
    end
  end

  def update_user(id, params) do
    with {:ok, user} <- find_user(%{id: id}) do
      user
      |> User.changeset(params)
      |> Repo.update()
    end
  end

  def create_user(params) do
    IO.inspect(params)
    %User{}
    |> User.changeset(params)
    |> Repo.insert()
  end

  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  def list_preferences do
    Repo.all(Preference)
  end

  def get_preference!(id), do: Repo.get!(Preference, id)

  def create_preference(attrs \\ %{}) do
    %Preference{}
    |> Preference.changeset(attrs)
    |> Repo.insert()
  end

  def update_preference(%Preference{} = preference, attrs) do
    preference
    |> Preference.changeset(attrs)
    |> Repo.update()
  end

  def delete_preference(%Preference{} = preference) do
    Repo.delete(preference)
  end

  def change_preference(%Preference{} = preference, attrs \\ %{}) do
    Preference.changeset(preference, attrs)
  end
end
