defmodule GraphqlApiWeb.Resolvers.Preference do
  @moduledoc false
  alias GraphqlApi.{Accounts, Accounts.Preference}

  @type resolution :: Absinthe.Resolution.t()
  @type error :: GraphqlApi.Accounts.error()

  @spec all(map, resolution()) :: {:ok, [Preference.t()]}
  def all(params, _) do
    {:ok, Accounts.all_preferences(params)}
  end

  @spec update_user_preferences(%{user_id: String.t()}, resolution()) ::
          {:ok, Preference.t()} | {:error, error}
  def update_user_preferences(%{user_id: user_id} = params, _) do
    Accounts.update_preferences(user_id, params)
  end

  @spec find_user_preferences(map, resolution()) ::
          {:ok, Preference.t()} | {:error, error()}
  def find_user_preferences(%{user_id: id}, _) do
    Accounts.find_preferences(%{user_id: id})
  end
end
