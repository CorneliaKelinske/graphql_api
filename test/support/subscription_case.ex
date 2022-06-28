defmodule GraphqlApiWeb.SubscriptionCase do
  @moduledoc """
  This module defines the test case to be used by
  subscription tests.
  """
  use ExUnit.CaseTemplate

  using do
    quote do
      use GraphqlApiWeb.ChannelCase
      use Absinthe.Phoenix.SubscriptionTest, schema: GraphqlApiWeb.Schema

      setup do
        {:ok, socket} = Phoenix.ChannelTest.connect(GraphqlApiWeb.UserSocket, %{})
        {:ok, socket} = Absinthe.Phoenix.SubscriptionTest.join_absinthe(socket)

        {:ok, %{socket: socket}}
      end
    end
  end
end
