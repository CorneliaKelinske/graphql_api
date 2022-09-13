defmodule GraphqlApiWeb.Types.Request do
  @moduledoc false
  use Absinthe.Schema.Notation

  @request_types GraphqlApi.HitCounter.request_types()

  @desc "A request that can be sent to the GraphQL Server"
  enum :request, values: @request_types
end
