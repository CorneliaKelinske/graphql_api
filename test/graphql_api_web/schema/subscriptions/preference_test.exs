defmodule GraphqlApiWeb.Schema.Subscriptions.PreferenceTest do
  use GraphqlApiWeb.SubscriptionCase
  import GraphqlApi.AccountsFixtures, only: [user: 1]

  @update_user_preferences_doc """
  mutation UpdateUserPreferences($userId: ID!, $likesEmails: Boolean, $likesPhoneCalls: Boolean, $likesFaxes: Boolean) {
    updateUserPreferences (userId: $userId, likesEmails: $likesEmails, likesPhoneCalls: $likesPhoneCalls, likesFaxes: $likesFaxes) {
      id
      userId
      likesEmails
      likesPhoneCalls
      likesFaxes
      user {
        name
        email
        id
      }
    }
  }
  """

  @updated_user_preferences_doc """
  subscription UpdatedUserPreferences($userId: ID!) {
    updatedUserPreferences(user_id: $userId) {
      id
      userId
      likesEmails
      likesPhoneCalls
      likesFaxes
      user {
        name
        email
        id
      }
    }
  }
  """

  describe "@updated_user_preferences" do
    setup :user

    test "sends a user when @updatedUserPreferences mutation is triggered", %{
      socket: socket,
      user: %{name: name, email: email, id: id}
    } do
      user_id = to_string(id)

      ref = push_doc(socket, @updated_user_preferences_doc, variables: %{"userId" => id})

      assert_reply ref, :ok, %{subscriptionId: subscription_id}

      ref =
        push_doc(socket, @update_user_preferences_doc,
          variables: %{"userId" => id, "likesEmails" => true}
        )

      assert_reply ref, :ok, reply

      assert %{
        data: %{"updateUserPreferences" => %{
          "userId" => ^user_id,
          "likesEmails" => true,
          "user" => %{
            "name" => ^name,
            "email" => ^email
          }
        }}
      } = reply

      assert_push "subscription:data", data

      assert %{
        subscriptionId: ^subscription_id,
        result: %{
          data: %{"updatedUserPreferences" => %{
            "userId" => ^user_id,
            "likesEmails" => true,
            "user" => %{
              "name" => ^name,
              "email" => ^email
            }
          }}
        }
      } = data

    end
  end
end