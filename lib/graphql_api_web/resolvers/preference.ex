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
  def update_user_preferences(%{user_id: id} = params, _) do
    id = String.to_integer(id)
    params = Map.delete(params, :user_id)
    Accounts.update_preferences(id, params)
  end

  def find_user_preferences(%{user_id: id}, _) do
    id = String.to_integer(id)
    Accounts.find_preferences_by_user_id(%{id: id})
  end
end
