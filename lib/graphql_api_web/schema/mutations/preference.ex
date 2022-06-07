defmodule GraphqlApiWeb.Schema.Mutations.Preference do
  use Absinthe.Schema.Notation
  alias GraphqlApiWeb.Resolvers

  object :preference_mutations do
    @desc "Updates a user's notification preference"
    field :update_user_preferences, :preference do
      arg :user_id, non_null(:id)
      arg :likes_emails, :boolean
      arg :likes_phone_calls, :boolean
      arg :likes_faxes, :boolean

      resolve &Resolvers.Preference.update_user_preferences/2
    end
  end
end