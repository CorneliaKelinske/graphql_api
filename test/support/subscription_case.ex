defmodule GraphqlApiWeb.SubscriptionCase do
  @moduledoc """
  This module defines the test case to be used by
  subscription tests.
  """
  use ExUnit.CaseTemplate
  alias Absinthe.Phoenix.SubscriptionTest
  alias Phoenix.ChannelTest

  using do
    quote do
      use GraphqlApiWeb.ChannelCase
      use Absinthe.Phoenix.SubscriptionTest, schema: GraphqlApiWeb.Schema

      setup do
        {:ok, socket} = ChannelTest.connect(GraphqlApiWeb.UserSocket, %{})
        {:ok, socket} = SubscriptionTest.join_absinthe(socket)

        {:ok, %{socket: socket}}
      end
    end
  end
end
