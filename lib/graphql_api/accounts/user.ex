defmodule GraphqlApi.Accounts.User do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query
  alias GraphqlApi.Accounts.{Preference, User}

  @type t :: %__MODULE__{
          id: pos_integer | nil,
          email: String.t() | nil,
          name: String.t() | nil,
          preferences: Preference.t() | nil | Ecto.Association.NotLoaded.t()
        }

  schema "users" do
    field :email, :string
    field :name, :string

    has_one :preferences, Preference
  end

  @required_params [:name, :email]

  @spec create_changeset(map) :: Ecto.Changeset.t()
  def create_changeset(params) do
    changeset(%User{}, params)
  end

  @spec changeset(t, map) :: Ecto.Changeset.t()
  def changeset(user, attrs) do
    user
    |> cast(attrs, @required_params)
    |> validate_required(@required_params)
    |> unique_constraint(:email)
    |> cast_assoc(:preferences, required: true)
  end

  def join_preferences(query \\ User) do
    join(query, :inner, [u], p in assoc(u, :preferences), as: :preferences)
  end

  def by_preferences(query \\ join_preferences(), {filter, boolean}) do
    where(query, [preferences: p], field(p, ^filter) == ^boolean)
  end

  def by_name(query \\ User, name) do
    where(query, [u], u.name == ^name)
  end
end
