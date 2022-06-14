defmodule GraphqlApiWeb.Resolvers.Preference do
  @moduledoc false
  alias GraphqlApi.Accounts

  @type resolution :: Absinthe.Resolution.t()
  @type preferences :: GraphqlApi.Accounts.preferences()
  @type error :: GraphqlApi.Accounts.error()

  def all(params, _) do
    Accounts.all_preferences(params)
  end

  @spec update_user_preferences(%{user_id: String.t()}, resolution()) ::
          {:ok, preferences()} | {:error, error}
  def update_user_preferences(%{user_id: user_id} = params, _) do
    Accounts.update_preferences(user_id, params)
  end

  def find_user_preferences(%{user_id: id}, _) do
    Accounts.find_preferences(%{user_id: id})
  end
end
