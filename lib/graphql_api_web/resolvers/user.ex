defmodule GraphqlApiWeb.Resolvers.User do
  alias GraphqlApi.Accounts

  def all(params, _) do
    Accounts.all_users(params)
  end

  def find(%{id: id}, _) do
    id = String.to_integer(id)
    Accounts.find_user(%{id: id})
  end

  def create_user(params, _) do
    Accounts.create_user(params)
  end

  def update_user(%{id: id} = params, _) do
    id = String.to_integer(id)
    Accounts.update_user(id, Map.delete(params, :id))
  end
end
