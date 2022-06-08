defmodule GraphqlApi.Accounts do
  @moduledoc """
  Defines a list of users and the functions for interacting with those users
  """

  defguard empty_map?(map) when map_size(map) === 0

  @type user :: %{
          id: pos_integer(),
          name: String.t(),
          email: String.t(),
          preferences: preferences()
        }

  @type preferences :: %{
          likes_emails: boolean(),
          likes_phone_calls: boolean,
          likes_faxes: boolean
        }
  @type error :: %{message: String.t(), details: map}

  @users [
    %{
      id: 1,
      name: "Bill",
      email: "bill@gmail.com",
      preferences: %{
        likes_emails: false,
        likes_phone_calls: true,
        likes_faxes: true
      }
    },
    %{
      id: 2,
      name: "Alice",
      email: "alice@gmail.com",
      preferences: %{
        likes_emails: true,
        likes_phone_calls: false,
        likes_faxes: true
      }
    },
    %{
      id: 3,
      name: "Jill",
      email: "jill@hotmail.com",
      preferences: %{
        likes_emails: true,
        likes_phone_calls: true,
        likes_faxes: false
      }
    },
    %{
      id: 4,
      name: "Tim",
      email: "tim@gmail.com",
      preferences: %{
        likes_emails: false,
        likes_phone_calls: false,
        likes_faxes: false
      }
    }
  ]

  @spec all_users(map()) :: {:ok, [user()]} | {:error, error()}
  def all_users(params) when empty_map?(params) do
    {:ok, @users}
  end

  def all_users(preferences) do
    preference_keys = preference_keys(preferences)

    case Enum.filter(
           @users,
           &(relevant_preferences(&1.preferences, preference_keys) === preferences)
         ) do
      [] -> {:error, %{message: "not found", details: %{preferences: preferences}}}
      users -> {:ok, users}
    end
  end

  @spec find_user(%{id: pos_integer}) :: {:ok, user} | {:error, error()}
  def find_user(%{id: id}) do
    case Enum.find(@users, &(&1.id === id)) do
      nil -> {:error, %{message: "not found", details: %{id: id}}}
      user -> {:ok, user}
    end
  end

  @spec create_user(user()) :: {:ok, user}
  def create_user(params) do
    {:ok, params}
  end

  @spec update_user(pos_integer, map) :: {:ok, user} | {:error, error}
  def update_user(_id, params) when empty_map?(params) do
    {:error, %{message: "no update params given", details: %{params: params}}}
  end

  def update_user(id, params) do
    with {:ok, user} <- find_user(%{id: id}) do
      {:ok, Map.merge(user, params)}
    end
  end

  @spec update_user_preferences(integer(), map) ::
          {:ok, preferences()} | {:error, error}
  def update_user_preferences(_id, params) when empty_map?(params) do
    {:error, %{message: "no update params given", details: %{params: params}}}
  end

  def update_user_preferences(id, params) do
    with {:ok, user} <- find_user(%{id: id}) do
      preferences =
        user
        |> Map.get(:preferences)
        |> Map.merge(params)

      {:ok, preferences}
    end
  end

  defp preference_keys(preferences) do
    Map.keys(preferences)
  end

  defp relevant_preferences(user_preferences, preference_keys) do
    Map.take(user_preferences, preference_keys)
  end
end
