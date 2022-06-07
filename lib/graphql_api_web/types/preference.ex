defmodule GraphqlApiWeb.Types.Preference do
  use Absinthe.Schema.Notation

  @desc "Notification preferences for a users - queries"
  object :preference do
    field :user_id, non_null(:id)
    field :likes_emails, non_null(:boolean)
    field :likes_phone_calls, non_null(:boolean)
    field :likes_faxes, non_null(:boolean)
  end

  @desc "Notification preferences for a user - mutations"
  input_object :preference_input do
    field :likes_emails, non_null(:boolean)
    field :likes_phone_calls, non_null(:boolean)
    field :likes_faxes, non_null(:boolean)
  end
end
