defmodule GraphqlApiWeb.Resolvers.Preference do
  @moduledoc false
  alias GraphqlApi.Accounts

  @type resolution :: Absinthe.Resolution.t()
  @type preferences :: GraphqlApi.Accounts.preferences()
  @type error :: GraphqlApi.Accounts.error()

  @spec update_user_preferences(%{user_id: String.t()}, resolution()) ::
          {:ok, preferences()} | {:error, error}
  def update_user_preferences(%{user_id: id} = params, _) do
    id = String.to_integer(id)

    Accounts.update_preference(id, params)
  end
end
