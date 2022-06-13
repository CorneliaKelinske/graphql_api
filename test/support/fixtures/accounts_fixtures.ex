defmodule GraphqlApi.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `GraphqlApi.Accounts` context.
  """

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        email: "some email",
        name: "some name"
      })
      |> GraphqlApi.Accounts.create_user()

    user
  end

  @doc """
  Generate a preference.
  """
  def preference_fixture(attrs \\ %{}) do
    {:ok, preference} =
      attrs
      |> Enum.into(%{
        likes_emails: true,
        likes_faxes: true,
        likes_phone_calls: true
      })
      |> GraphqlApi.Accounts.create_preference()

    preference
  end
end
