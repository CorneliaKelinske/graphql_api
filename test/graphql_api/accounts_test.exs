defmodule GraphqlApi.Accounts.Test do
  use GraphqlApi.DataCase, async: true

  alias GraphqlApi.Accounts

  describe "all/1" do
    test "returns a list of all users when no preferences are passed in" do
      {:ok, users} = Accounts.all_users(%{})
      assert length(users) === 4
    end

    test "returns a list of users with matching preferences when all three preferences are provided" do
      assert {:ok,
              [
                %{
                  email: "tim@gmail.com",
                  id: 4,
                  name: "Tim",
                  preferences: %{
                    likes_emails: false,
                    likes_faxes: false,
                    likes_phone_calls: false
                  }
                }
              ]} ===
               Accounts.all_users(%{
                 likes_emails: false,
                 likes_phone_calls: false,
                 likes_faxes: false
               })
    end

    test "returns a list of users with matching preferences when not all preferences are provided" do
      {:ok, users} = Accounts.all_users(%{likes_emails: true})
      assert length(users) === 2
    end

    test "returns tuple with :error and map with error info when no users with matching preferences are found" do
      assert {:error,
              %{
                message: "not found",
                details: %{
                  preferences: %{
                    preferences: %{likes_emails: true, likes_phone_calls: true, likes_faxes: true}
                  }
                }
              }} ===
               Accounts.all_users(%{
                 preferences: %{likes_emails: true, likes_phone_calls: true, likes_faxes: true}
               })
    end
  end

  describe "find/1" do
    test "returns the user with the matching id" do
      {:ok, user} = Accounts.find_user(%{id: 1})
      assert user.name === "Bill"
    end

    test "returns tuple with :error and map with error info when no user is found for the given id" do
      assert {:error, %{message: "not found", details: %{id: 9}}} === Accounts.find_user(%{id: 9})
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
               Accounts.create_user(%{
                 id: 5,
                 name: "harry",
                 email: "dresden@example.com",
                 preferences: %{likes_emails: false, likes_phone_calls: false, likes_faxes: false}
               })
    end
  end

  describe "update_user/2" do
    test "returns an updated user" do
      {:ok, user} = Accounts.update_user(4, %{name: "Tom"})
      assert user.name === "Tom"
    end

    test "returns tuple with :error and map with error info when no update params are provided" do
      assert {:error, %{message: "no update params given", details: %{params: %{}}}} ===
               Accounts.update_user(4, %{})
    end
  end

  describe "update_user_preferences/2" do
    test "returns updated preferences" do
      {:ok, preferences} = Accounts.update_user_preferences(1, %{likes_emails: true})

      assert preferences === %{
               likes_emails: true,
               likes_phone_calls: true,
               likes_faxes: true
             }
    end

    test "returns tuple with :error and map with error info when no update params are provided" do
      assert {:error, %{message: "no update params given", details: %{params: %{}}}} ===
               Accounts.update_user_preferences(4, %{})
    end
  end
end
