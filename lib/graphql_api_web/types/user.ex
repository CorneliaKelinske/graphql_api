defmodule GraphqlApiWeb.Types.User do
  use Absinthe.Schema.Notation

  @desc "Notification preferences for a user"
  object :notification_preferences do
    field :likes_emails, :boolean
    field :likes_phone_calls, :boolean
    field :likes_faxes, :boolean
  end

  @desc "A user with preferences"
  object :user do
    field :id, :id
    field :name, :string
    field :email, :string

    field :preferences, :notification_preferences
  end
end
