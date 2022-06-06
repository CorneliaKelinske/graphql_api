defmodule GraphqlApi.User.Test do
  use GraphqlApi.DataCase, async: true

  alias GraphqlApi.User

  describe "all/1" do
    test "returns a list of all users when no preferences are passed in" do
      {:ok, users} = User.all(%{})
      assert length(users) === 4
    end

    test "returns a list of users with matching preferences when all three preferences are provided" do
      {:ok, users} =
        User.all(%{likes_emails: false, likes_phone_calls: false, likes_faxes: false})

      assert length(users) === 1
    end

    test "returns a list of users with matching preferences when not all preferences are provided" do
      {:ok, users} = User.all(%{likes_emails: true})
      assert length(users) === 2
    end

    test "returns tuple with :error and map with error info when no users with matching preferences are found" do
      assert {:error,
              %{
                message: "not found",
                details: %{
                  preferences: %{likes_emails: true, likes_phone_calls: true, likes_faxes: true}
                }
              }} === User.all(%{likes_emails: true, likes_phone_calls: true, likes_faxes: true})
    end
  end

  describe "find/1" do
    test "returns the user with the matching id" do
      {:ok, user} = User.find(%{id: 1})
      assert user.name === "Bill"
    end

    test "returns tuple with :error and map with error info when no user is found for the given id" do
      assert {:error, %{message: "not found", details: %{id: 9}}} === User.find(%{id: 9})
    end
  end

  describe "create/1" do
    test "returns a new user" do
      assert {:ok,
              %{
                id: 5,
                name: "harry",
                email: "dresden@example.com",
                preferences: %{likes_emails: false, likes_phone_calls: false, likes_faxes: false}
              }} ===
               User.create_user(%{
                 id: 5,
                 name: "harry",
                 email: "dresden@example.com",
                 preferences: %{likes_emails: false, likes_phone_calls: false, likes_faxes: false}
               })
    end
  end

  describe "update_user/2" do
    test "returns an updated user" do
      {:ok, user} = User.update_user(4, %{name: "Tom"})
      assert user.name === "Tom"
    end
  end

  describe "update_user_preferences/2" do
    test "returns a user with updated preferences" do
      {:ok, user} = User.update_user_preferences(1, %{likes_emails: true})

      assert user.preferences === %{
               likes_emails: true,
               likes_phone_calls: true,
               likes_faxes: true
             }
    end
  end
end
