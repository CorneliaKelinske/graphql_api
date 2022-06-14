defmodule GraphqlApiWeb.Schema.Queries.User do
  @moduledoc false

  use Absinthe.Schema.Notation
  alias GraphqlApiWeb.Resolvers

  object :user_queries do
    @desc "Returns a list of all users filtered based on the given parameters"
    field :users, list_of(:user) do
      arg :name, :string
      arg :email, :string

      resolve &Resolvers.User.all/2
    end

    @desc "Gets a user based on the given params"
    field :user, :user do
      arg :id, :id
      arg :name, :string
      arg :email, :string

      resolve &Resolvers.User.find/2
    end
  end
end
