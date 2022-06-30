defmodule GraphqlApiWeb.Resolvers.Preference do
  @moduledoc false
  alias GraphqlApi.{Accounts, Accounts.Preference, HitTracker}

  @type resolution :: Absinthe.Resolution.t()
  @type error :: GraphqlApi.Accounts.error()

  @spec all(map, resolution()) :: {:ok, [Preference.t()]}
  def all(params, _) do
    HitTracker.add_hit(:PREFERENCES)
    {:ok, Accounts.all_preferences(params)}
  end

  @spec update_user_preferences(%{user_id: String.t()}, resolution()) ::
          {:ok, Preference.t()} | {:error, error}
  def update_user_preferences(%{user_id: user_id} = params, _) do
    HitTracker.add_hit(:UPDATE_USER_PREFERENCES)
    Accounts.update_preferences(user_id, params)
  end

  @spec find_user_preferences(map, resolution()) ::
          {:ok, Preference.t()} | {:error, error()}
  def find_user_preferences(%{user_id: id}, _) do
    HitTracker.add_hit(:USER_PREFERENCES)
    Accounts.find_preferences(%{user_id: id})
  end
end
