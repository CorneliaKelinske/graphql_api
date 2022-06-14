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


  def find_user(params) when empty_map?(params) do
    {:error, %{message: "no search params given", details: %{params: params}}}
  end

  def find_user(params) do
    Actions.find(User, params)
  end

  def update_user(_id, params) when empty_map?(params) do
    {:error, %{message: "no update params given", details: %{params: params}}}
  end

  def update_user(id, params) do
    Actions.update(User, id, params)
  end

  def create_user(params) do
    Actions.create(User, params)
  end

  def delete_user(%User{} = user) do
    Actions.delete(user)
  end

  def all_preferences(params \\ %{}) do
    {:ok, Actions.all(Preference, params)}
  end

  def update_preferences(_id, params) when empty_map?(params) do
    {:error, %{message: "no update params given", details: %{params: params}}}
  end

  def update_preferences(id, params) do
   Actions.update(Preference, id, params)
  end

  def find_preferences(params)  do
    Actions.find(Preference, params)
  end
end
