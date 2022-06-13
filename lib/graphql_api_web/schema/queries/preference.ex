defmodule GraphqlApiWeb.Schema.Queries.Preference do
  @moduledoc false
  use Absinthe.Schema.Notation
  alias GraphqlApiWeb.Resolvers

  object :preference_queries do
    field :preferences, :preferences do
      arg :user_id, non_null(:id)

      resolve &Resolvers.Preference.find_user_preferences/2
    end
  end
end
