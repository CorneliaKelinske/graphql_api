defmodule GraphqlApiWeb.Schema.Mutations.PreferenceTest do
  use GraphqlApi.DataCase
  import GraphqlApi.AccountsFixtures, only: [user: 1]

  alias GraphqlApiWeb.Schema

  @update_user_preferences_doc """
  mutation UpdateUserPreferences($userId: ID!, $likesEmails: Boolean, $likesPhoneCalls: Boolean, $likesFaxes: Boolean) {
    updateUserPreferences (userId: $userId, likesEmails: $likesEmails, likesPhoneCalls: $likesPhoneCalls, likesFaxes: $likesFaxes) {
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

  describe "@update_user_preferences" do
    setup :user

    test "updates user preferences", %{user: %{name: name, email: email, id: id}} do
      user_id = to_string(id)

      assert {
               :ok,
               %{
                 data: %{
                   "updateUserPreferences" => %{
                     "likesEmails" => true,
                     "likesFaxes" => false,
                     "likesPhoneCalls" => false,
                     "user" => %{
                       "email" => ^email,
                       "id" => ^user_id,
                       "name" => ^name
                     },
                     "userId" => ^user_id
                   }
                 }
               }
             } =
               Absinthe.run(@update_user_preferences_doc, Schema,
                 variables: %{"userId" => id, "likesEmails" => true}
               )
    end
  end
end
