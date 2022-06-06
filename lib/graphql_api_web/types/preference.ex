defmodule GraphqlApiWeb.Types.Preference do
  use Absinthe.Schema.Notation

  @desc "Notification preferences for a users - queries"
  object :preference do
    field :likes_emails, :boolean
    field :likes_phone_calls, :boolean
    field :likes_faxes, :boolean
  end

  @desc "Notification preferences for a user - mutations"
  input_object :preference_input do
    field :likes_emails, :boolean
    field :likes_phone_calls, :boolean
    field :likes_faxes, :boolean
  end
end
