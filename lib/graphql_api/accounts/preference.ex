defmodule GraphqlApi.Accounts.Preference do
  use Ecto.Schema
  import Ecto.Changeset
  alias GraphqlApi.Accounts.{Preference, User}

  schema "preferences" do
    field :likes_emails, :boolean
    field :likes_faxes, :boolean
    field :likes_phone_calls, :boolean

    belongs_to :user, User
  end

  @required_params [:likes_emails, :likes_faxes, :likes_phone_calls]

  # def create_changeset(params) do
  #   changeset(%Preference{}, params)
  # end
  @doc false
  def changeset(preference, attrs) do
    preference
    |> cast(attrs, @required_params)
    |> validate_required(@required_params)
    |> unique_constraint(:user_id)
    |> cast_assoc(:user)
  end
end
