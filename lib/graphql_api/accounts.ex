defmodule GraphqlApi.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias EctoShorts.Actions
  alias GraphqlApi.{Accounts.User, Accounts.Preference, Repo}

  defguard empty_map?(map) when map_size(map) === 0

  defguard has_preference_filter?(map)
           when is_map_key(map, :likes_emails) or
                  is_map_key(map, :likes_faxes) or
                  is_map_key(map, :likes_phone_calls)
  def all_users(params \\ %{})
  def all_users(params) when has_preference_filter?(params) do

    query =
      Enum.reduce(params, User.join_preferences(), fn
        {:likes_emails, likes_emails}, acc -> User.by_likes_emails(acc, likes_emails)
        {:likes_faxes, likes_faxes}, acc -> User.by_likes_faxes(acc, likes_faxes)
        {:likes_phone_calls, bool}, acc -> User.by_likes_phone_calls(acc, bool)
        {:name, name}, acc -> User.by_name(acc, name)
      end)
    {:ok, Repo.all(query)}
  end

  def all_users(params) do
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
    with {:ok, user} <- find_user(%{id: id}) do
      user
      |> Repo.preload(:preferences)
      |> then(&Actions.update(User, &1, params))
    end
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

  def update_preferences(user_id, params) do
    with {:ok, preference} <- find_preferences(%{user_id: user_id}) do
      Actions.update(Preference, preference, params)
    end
  end

  def find_preferences(params) do
    Actions.find(Preference, params)
  end
end
