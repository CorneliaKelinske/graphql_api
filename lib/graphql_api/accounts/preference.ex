defmodule GraphqlApi.Accounts.Preference do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset
  alias GraphqlApi.Accounts.User

  @type t :: %__MODULE__{
          id: pos_integer | nil,
          likes_emails: boolean | nil,
          likes_faxes: boolean | nil,
          likes_phone_calls: boolean | nil,
          user_id: pos_integer | nil,
          user: User.t() | nil | Ecto.Association.NotLoaded.t()
        }

  schema "preferences" do
    field :likes_emails, :boolean
    field :likes_faxes, :boolean
    field :likes_phone_calls, :boolean

    belongs_to :user, User
  end

  @required_params [:likes_emails, :likes_faxes, :likes_phone_calls]

  def required_params, do: @required_params

  @spec changeset(t, map) :: Ecto.Changeset.t()
  def changeset(preference, attrs) do
    preference
    |> cast(attrs, @required_params)
    |> validate_required(@required_params)
    |> unique_constraint(:user_id)
  end
end
