defmodule GraphqlApiWeb.Types.User do
  use Absinthe.Schema.Notation

  @desc "A user with notification preferences"
  object :user do
    field :id, :id
    field :name, :string
    field :email, :string

    field :preferences, :preference
  end
end
