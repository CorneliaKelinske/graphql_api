defmodule GraphqlApiWeb.Types.User do
  use Absinthe.Schema.Notation

  @desc "A user with notification preferences"
  object :user do
    field :id, non_null(:id)
    field :name, non_null(:string)
    field :email, non_null(:string)

    field :preferences, non_null(:preference)
  end
end