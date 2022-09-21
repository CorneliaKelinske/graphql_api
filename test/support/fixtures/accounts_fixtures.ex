defmodule GraphqlApi.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `GraphqlApi.Accounts` context.
  """
  alias GraphqlApi.Accounts

  @valid_user_params %{name: "Harry", email: "email@example.com"}
  @valid_user2_params %{name: "Waldo", email: "butters@example.com"}
  @valid_preference_params %{likes_emails: false, likes_phone_calls: false, likes_faxes: false}

  def user(_context) do
    {:ok, user} =
      @valid_user_params
      |> Map.put(:preferences, @valid_preference_params)
      |> Accounts.create_user()

    %{user: user}
  end

  def user2(_context) do
    {:ok, user2} =
      @valid_user2_params
      |> Map.put(:preferences, @valid_preference_params)
      |> Accounts.create_user()

    %{user2: user2}
  end
end
