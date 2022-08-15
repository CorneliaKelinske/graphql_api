defmodule GraphqlApiWeb.Schema.Mutations.UserTest do
  use GraphqlApi.DataCase, async: true
  import GraphqlApi.AccountsFixtures, only: [user: 1]
  alias GraphqlApi.Accounts
  alias GraphqlApiWeb.Schema

  @create_user_doc """
    mutation CreateUser($name: String!, $email: String!, $preferences: PreferenceInput!){
    createUser (name: $name, email: $email, preferences: $preferences) {

     id
     name
     email
      preferences {
        id
        user_id
        likes_emails
        likes_phone_calls
        likes_faxes
      }
    }
  }
  """

  @preferences %{
    "likesEmails" => true,
    "likesFaxes" => false,
    "likesPhoneCalls" => false
  }

  describe "@create_user" do
    setup :user

    test "creates a new user" do
      assert {
               :ok,
               %{
                 data: %{
                   "createUser" => %{
                     "name" => "Molly",
                     "email" => "molly@example.com",
                     "preferences" => %{
                       "likes_emails" => true,
                       "likes_faxes" => false,
                       "likes_phone_calls" => false
                     }
                   }
                 }
               }
             } =
               Absinthe.run(@create_user_doc, Schema,
                 variables: %{
                   "name" => "Molly",
                   "email" => "molly@example.com",
                   "preferences" => @preferences
                 }
               )

      assert {:ok, %{name: "Molly"}} = Accounts.find_user(%{email: "molly@example.com"})
    end

    test "returns a changeset error when user email already exists", %{user: %{email: email}} do
      assert {:ok,
              %{
                data: %{"createUser" => nil},
                errors: [
                  %{
                    locations: [%{column: 3, line: 2}],
                    message: "email: has already been taken",
                    path: ["createUser"]
                  }
                ]
              }} =
               Absinthe.run(@create_user_doc, Schema,
                 variables: %{
                   "name" => "Molly",
                   "email" => email,
                   "preferences" => @preferences
                 }
               )
    end
  end

  @update_user_doc """
    mutation UpdateUser($id: ID!, $name: String!, $email: String!){
    updateUser (id: $id, name: $name, email: $email) {

     id
     name
     email
      preferences {
        id
        user_id
        likes_emails
        likes_phone_calls
        likes_faxes
      }
    }
  }
  """

  describe "@update_user" do
    setup :user

    test "updates a user based on their id", %{user: %{id: id}} do
      user_id = to_string(id)

      assert {
               :ok,
               %{
                 data: %{
                   "updateUser" => %{
                     "name" => "Horst",
                     "email" => "horst@example.com",
                     "id" => ^user_id
                   }
                 }
               }
             } =
               Absinthe.run(@update_user_doc, Schema,
                 variables: %{"id" => user_id, "name" => "Horst", "email" => "horst@example.com"}
               )

      assert {:ok, %{name: "Horst"}} = Accounts.find_user(%{id: id})
    end
  end
end
