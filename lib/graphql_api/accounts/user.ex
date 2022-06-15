defmodule GraphqlApi.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query
  alias GraphqlApi.Accounts.{Preference, User}
  alias GraphqlApi.Repo

  schema "users" do
    field :email, :string
    field :name, :string

    has_one :preferences, Preference
  end

  @required_params [:name, :email]

  def create_changeset(params) do
    changeset(%User{}, params)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, @required_params)
    |> validate_required(@required_params)
    |> cast_assoc(:preferences, required: true)
  end

  def join_preferences(query \\ User) do
    join(query, :inner, [u], p in assoc(u, :preferences), as: :preferences)
  end

  def by_likes_emails(query \\ join_preferences(), likes_emails) do
    where(query, [preferences: p], p.likes_emails == ^likes_emails)
  end

  def by_likes_phone_calls(query \\ join_preferences(), likes_phone_calls) do
    where(query, [preferences: p], p.likes_phone_calls == ^likes_phone_calls)
  end

  def by_likes_faxes(query \\ join_preferences(), likes_faxes) do
    where(query, [preferences: p], p.likes_faxes == ^likes_faxes)
  end

  def by_name(query \\ User, name) do
    where(query, [u], u.name == ^name)
  end
end
