defmodule GraphqlApi.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias GraphqlApi.Accounts.Preference

  schema "users" do
    field :email, :string
    field :name, :string

    has_one :preferences, Preference
  end

  @required_params [:name, :email]

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, @required_params)
    |> validate_required(@required_params)
    |> cast_assoc(:preferences)
  end
end
