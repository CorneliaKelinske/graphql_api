defmodule GraphqlApiWeb.Schema.Mutations.UserTest do
  use GraphqlApi.DataCase, async: true
  import GraphqlApi.UserFixtures, only: [user: 1]
  alias GraphqlApi.{Accounts, Config}
  alias GraphqlApiWeb.Schema

  @secret_key Config.secret_key()

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
                 },
                 context: %{secret_key: @secret_key}
               )

      assert {:ok, %{name: "Molly"}} = Accounts.find_user(%{email: "molly@example.com"})
    end

    test "returns an error when no secret key is provided" do
      assert {
               :ok,
               %{
                 data: %{"createUser" => nil},
                 errors: [
                   %{
                     message: "Internal server error",
                     path: ["createUser"],
                     code: :internal_server_error,
                     details: %{error: "\"Please enter a secret key\""}
                   }
                 ]
               }
             } =
               Absinthe.run(@create_user_doc, Schema,
                 variables: %{
                   "name" => "Molly",
                   "email" => "molly@example.com",
                   "preferences" => @preferences
                 }
               )
    end

    test "returns a changeset error when user email already exists", %{user: %{email: email}} do
      assert {:ok,
              %{
                data: %{"createUser" => nil},
                errors: [
                  %{
                    details: %{argument: :email, value: "email@example.com"},
                    message: "has already been taken",
                    path: ["createUser"],
                    code: :conflict
                  }
                ]
              }} =
               Absinthe.run(@create_user_doc, Schema,
                 variables: %{
                   "name" => "Molly",
                   "email" => email,
                   "preferences" => @preferences
                 },
                 context: %{secret_key: @secret_key}
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
                 variables: %{"id" => user_id, "name" => "Horst", "email" => "horst@example.com"},
                 context: %{secret_key: @secret_key}
               )

      assert {:ok, %{name: "Horst"}} = Accounts.find_user(%{id: id})
    end

    test "returns error when incorrect secret key is provided", %{user: %{id: id, name: name}} do
      user_id = to_string(id)

      assert {
               :ok,
               %{
                 data: %{"updateUser" => nil},
                 errors: [
                   %{
                     message: "Internal server error",
                     path: ["updateUser"],
                     code: :internal_server_error,
                     details: %{error: "\"unauthenticated\""}
                   }
                 ]
               }
             } =
               Absinthe.run(@update_user_doc, Schema,
                 variables: %{"id" => user_id, "name" => "Horst", "email" => "horst@example.com"},
                 context: %{secret_key: "WrongKey"}
               )

      assert {:ok, %{name: ^name}} = Accounts.find_user(%{id: id})
    end
  end
end
