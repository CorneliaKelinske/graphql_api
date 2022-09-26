defmodule GraphqlApiWeb.Schema.Subscriptions.AuthTokenTest do
  use GraphqlApiWeb.SubscriptionCase

  @auth_token_generated_doc """
  subscription AuthTokenGenerated($user_id: ID!) {
    authTokenGenerated(user_id: $user_id) {
      user_id
      token
      timestamp
    }
  }
  """

  describe "@auth_token_generated" do
    test "broadcasts when an auth_token for the given ID is generated", %{socket: socket} do
      ref = push_doc(socket, @auth_token_generated_doc, variables: %{"user_id" => "2"})

      assert_reply ref, :ok, %{subscriptionId: subscription_id}
    end
  end
end
