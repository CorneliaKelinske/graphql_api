defmodule GraphqlApiWeb.Types.Request do
  @moduledoc false
  use Absinthe.Schema.Notation

  @desc "A request that can be sent to the GraphQL Server"
  enum :request do
    value :PREFERENCES
    value :USER_PREFERENCES
    value :USERS
    value :USER
    value :RESOLVER_HITS
    value :UPDATE_USER_PREFERENCES
    value :CREATE_USER
    value :UPDATE_USER
  end
end
