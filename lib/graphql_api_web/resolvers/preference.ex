defmodule GraphqlApiWeb.Resolvers.Preference do
  alias GraphqlApi.Accounts

  def update_user_preferences(%{user_id: id} = params, _) do
    id
    |> String.to_integer()
    |> Accounts.update_user_preferences(Map.delete(params, :user_id))
  end
end
