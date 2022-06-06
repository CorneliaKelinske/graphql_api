defmodule GraphqlApiWeb.Resolvers.User do
  alias GraphqlApi.User

  def all(params, _) do
    User.all(params)
  end

  def find(%{id: id}, _) do
    id = String.to_integer(id)
    User.find(%{id: id})
  end
end
