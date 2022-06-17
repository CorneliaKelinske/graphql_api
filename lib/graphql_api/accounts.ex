defmodule GraphqlApi.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias EctoShorts.Actions
  alias GraphqlApi.{Accounts.Preference, Accounts.User, Repo}

  @type error :: %{code: atom, message: String.t(), details: map}

  defguard empty_map?(map) when map_size(map) === 0

  defguard has_preference_filter?(map)
           when is_map_key(map, :likes_emails) or
                  is_map_key(map, :likes_faxes) or
                  is_map_key(map, :likes_phone_calls)

  @spec all_users(map) :: {:ok, [User.t()]}
  def all_users(params \\ %{})

  def all_users(params) when has_preference_filter?(params) do
    # If more user params are added, separate user params from preferences. Compose query without
    # user params and call `Actions.all(query, user_params)`

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

  @spec find_user(map) :: {:ok, User.t()} | {:error, error()}
  def find_user(params) when empty_map?(params) do
    {:error,
     %{code: :invalid_params, message: "no search params given", details: %{params: params}}}
  end

  def find_user(params) do
    Actions.find(User, params)
  end

  @spec update_user(pos_integer, map) :: {:ok, User.t()} | {:error, error | Ecto.Changeset.t()}
  def update_user(_id, params) when empty_map?(params) do
    {:error,
     %{code: :invalid_params, message: "no update params given", details: %{params: params}}}
  end

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

  @spec all_preferences(map) :: {:ok, [Preference.t()]}
  def all_preferences(params \\ %{}) do
    {:ok, Actions.all(Preference, params)}
  end

  @spec update_preferences(String.t(), map) ::
          {:ok, Preference.t()} | {:error, error | Ecto.Changeset.t()}
  def update_preferences(_id, params) when empty_map?(params) do
    {:error,
     %{code: :invalid_params, message: "no update params given", details: %{params: params}}}
  end

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
