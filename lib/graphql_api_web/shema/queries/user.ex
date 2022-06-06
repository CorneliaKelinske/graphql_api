defmodule GraphqlApiWeb.Schema.Queries.User do
  use Absinthe.Schema.Notation
  alias GraphqlApiWeb.Resolvers

  object :user_queries do
    @desc "Returns a list of all users filtered based on their preferences"
    field :users, list_of(:user) do
      arg :likes_emails, :boolean
      arg :likes_phone_calls, :boolean
      arg :likes_faxes, :boolean

      resolve &Resolvers.User.all/2
    end

    @desc "Gets a user by id"
    field :user, :user do
      arg :id, non_null(:id)

      resolve &Resolvers.User.find/2
    end
  end
end
