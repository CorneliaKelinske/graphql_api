defmodule GraphqlApiWeb.Types.AuthToken do
  use Absinthe.Schema.Notation

  @desc "An auth token for a user"
  object :auth_token do
    field :user_id, non_null(:id)
    # field :time_stamp, non_null(:string)
    field :token, non_null(:string)
  end
end
