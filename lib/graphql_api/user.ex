defmodule GraphqlApi.User do
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

  def all() do
    {:ok, @users}
  end

  def all(preferences) do
    preference_keys = preference_keys(preferences)

    case Enum.filter(
           @users,
           &(relevant_preferences(&1.preferences, preference_keys) === preferences)
         ) do
      [] -> {:error, %{message: "not found", details: %{preferences: preferences}}}
      users -> {:ok, users}
    end
  end

  def find(%{id: id}) do
    case Enum.find(@users, &(&1.id === id)) do
      nil -> {:error, %{message: "not found", details: %{id: id}}}
      user -> {:ok, user}
    end
  end

  def create_user(params) do
    {:ok, params}
  end

  def update_user(id, params) do
    with {:ok, user} <- find(%{id: id}) do
      {:ok, Map.merge(user, params)}
    end
  end

  def update_user_preferences(id, params) do
    with {:ok, user} <- find(%{id: id}) do
      user =
        user
        |> Map.get(:preferences)
        |> Map.merge(params)
        |> then(&Map.put(user, :preferences, &1))

      {:ok, user}
    end
  end

  defp preference_keys(preferences) do
    Map.keys(preferences)
  end

  defp relevant_preferences(user_preferences, preference_keys) do
    Map.take(user_preferences, preference_keys)
  end
end
