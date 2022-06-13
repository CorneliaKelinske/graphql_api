defmodule GraphqlApi.Accounts.Test do
  use GraphqlApi.DataCase, async: true

  alias GraphqlApi.{Accounts, Repo}
  alias GraphqlApi.Accounts.{Preference, User}

  # describe "all/1" do
  #   test "returns a list of all users when no preferences are passed in" do
  #     {:ok, users} = Accounts.all_users(%{})
  #     assert length(users) === 4
  #   end

  #   test "returns a list of users with matching preferences when all three preferences are provided" do
  #     assert {:ok,
  #             [
  #               %{
  #                 email: "tim@gmail.com",
  #                 id: 4,
  #                 name: "Tim",
  #                 preferences: %{
  #                   likes_emails: false,
  #                   likes_faxes: false,
  #                   likes_phone_calls: false
  #                 }
  #               }
  #             ]} ===
  #              Accounts.all_users(%{
  #                likes_emails: false,
  #                likes_phone_calls: false,
  #                likes_faxes: false
  #              })
  #   end

  #   test "returns a list of users with matching preferences when not all preferences are provided" do
  #     {:ok, users} = Accounts.all_users(%{likes_emails: true})
  #     assert length(users) === 2
  #   end

  #   test "returns tuple with :error and map with error info when no users with matching preferences are found" do
  #     assert {:error,
  #             %{
  #               message: "not found",
  #               details: %{
  #                 preferences: %{
  #                   preferences: %{likes_emails: true, likes_phone_calls: true, likes_faxes: true}
  #                 }
  #               }
  #             }} ===
  #              Accounts.all_users(%{
  #                preferences: %{likes_emails: true, likes_phone_calls: true, likes_faxes: true}
  #              })
  #   end
  # end

  # describe "find/1" do
  #   test "returns the user with the matching id" do
  #     {:ok, user} = Accounts.find_user(%{id: 1})
  #     assert user.name === "Bill"
  #   end

  #   test "returns tuple with :error and map with error info when no user is found for the given id" do
  #     assert {:error, %{message: "not found", details: %{id: 9}}} === Accounts.find_user(%{id: 9})
  #   end
  # end

  describe "create_user/1" do
    test "creates a new user" do
      assert {:ok, %User{}} = Accounts.create_user(%{name: "Harry", email: "harry@dresden.com"})

      assert [%User{}] = Repo.all(User)
    end

    test "creates a new user with preferences" do
      assert {:ok, %User{id: id, preferences: %Preference{user_id: id}}} =
               Accounts.create_user(%{
                 name: "Harry",
                 email: "harry@dresden.com",
                 preferences: %{likes_emails: true, likes_faxes: false, likes_phone_calls: false}
               })

      assert [%User{}] = Repo.all(User)
      assert [%Preference{}] = Repo.all(Preference)
    end
  end

  # describe "update_user/2" do
  #   test "returns an updated user" do
  #     {:ok, user} = Accounts.update_user(4, %{name: "Tom"})
  #     assert user.name === "Tom"
  #   end

  #   test "returns tuple with :error and map with error info when no update params are provided" do
  #     assert {:error, %{message: "no update params given", details: %{params: %{}}}} ===
  #              Accounts.update_user(4, %{})
  #   end
  # end

  # describe "update_user_preferences/2" do
  #   test "returns updated preferences" do
  #     {:ok, preferences} = Accounts.update_user_preferences(1, %{likes_emails: true})

  #     assert preferences === %{
  #              likes_emails: true,
  #              likes_phone_calls: true,
  #              likes_faxes: true
  #            }
  #   end

  #   test "returns tuple with :error and map with error info when no update params are provided" do
  #     assert {:error, %{message: "no update params given", details: %{params: %{}}}} ===
  #              Accounts.update_user_preferences(4, %{})
  #   end
  # end

  # describe "users" do
  #   alias GraphqlApi.Accounts.User

  #   import GraphqlApi.AccountsFixtures

  #   @invalid_attrs %{email: nil, name: nil}

  #   test "list_users/0 returns all users" do
  #     user = user_fixture()
  #     assert Accounts.list_users() == [user]
  #   end

  #   test "get_user!/1 returns the user with given id" do
  #     user = user_fixture()
  #     assert Accounts.get_user!(user.id) == user
  #   end

  #   test "create_user/1 with valid data creates a user" do
  #     valid_attrs = %{email: "some email", name: "some name"}

  #     assert {:ok, %User{} = user} = Accounts.create_user(valid_attrs)
  #     assert user.email == "some email"
  #     assert user.name == "some name"
  #   end

  #   test "create_user/1 with invalid data returns error changeset" do
  #     assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
  #   end

  #   test "update_user/2 with valid data updates the user" do
  #     user = user_fixture()
  #     update_attrs = %{email: "some updated email", name: "some updated name"}

  #     assert {:ok, %User{} = user} = Accounts.update_user(user, update_attrs)
  #     assert user.email == "some updated email"
  #     assert user.name == "some updated name"
  #   end

  #   test "update_user/2 with invalid data returns error changeset" do
  #     user = user_fixture()
  #     assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, @invalid_attrs)
  #     assert user == Accounts.get_user!(user.id)
  #   end

  #   test "delete_user/1 deletes the user" do
  #     user = user_fixture()
  #     assert {:ok, %User{}} = Accounts.delete_user(user)
  #     assert_raise Ecto.NoResultsError, fn -> Accounts.get_user!(user.id) end
  #   end

  #   test "change_user/1 returns a user changeset" do
  #     user = user_fixture()
  #     assert %Ecto.Changeset{} = Accounts.change_user(user)
  #   end
  # end

  # describe "preferences" do
  #   alias GraphqlApi.Accounts.Preference

  #   import GraphqlApi.AccountsFixtures

  #   @invalid_attrs %{likes_emails: nil, likes_faxes: nil, likes_phone_calls: nil}

  #   test "list_preferences/0 returns all preferences" do
  #     preference = preference_fixture()
  #     assert Accounts.list_preferences() == [preference]
  #   end

  #   test "get_preference!/1 returns the preference with given id" do
  #     preference = preference_fixture()
  #     assert Accounts.get_preference!(preference.id) == preference
  #   end

  #   test "create_preference/1 with valid data creates a preference" do
  #     valid_attrs = %{likes_emails: true, likes_faxes: true, likes_phone_calls: true}

  #     assert {:ok, %Preference{} = preference} = Accounts.create_preference(valid_attrs)
  #     assert preference.likes_emails == true
  #     assert preference.likes_faxes == true
  #     assert preference.likes_phone_calls == true
  #   end

  #   test "create_preference/1 with invalid data returns error changeset" do
  #     assert {:error, %Ecto.Changeset{}} = Accounts.create_preference(@invalid_attrs)
  #   end

  #   test "update_preference/2 with valid data updates the preference" do
  #     preference = preference_fixture()
  #     update_attrs = %{likes_emails: false, likes_faxes: false, likes_phone_calls: false}

  #     assert {:ok, %Preference{} = preference} = Accounts.update_preference(preference, update_attrs)
  #     assert preference.likes_emails == false
  #     assert preference.likes_faxes == false
  #     assert preference.likes_phone_calls == false
  #   end

  #   test "update_preference/2 with invalid data returns error changeset" do
  #     preference = preference_fixture()
  #     assert {:error, %Ecto.Changeset{}} = Accounts.update_preference(preference, @invalid_attrs)
  #     assert preference == Accounts.get_preference!(preference.id)
  #   end

  #   test "delete_preference/1 deletes the preference" do
  #     preference = preference_fixture()
  #     assert {:ok, %Preference{}} = Accounts.delete_preference(preference)
  #     assert_raise Ecto.NoResultsError, fn -> Accounts.get_preference!(preference.id) end
  #   end

  #   test "change_preference/1 returns a preference changeset" do
  #     preference = preference_fixture()
  #     assert %Ecto.Changeset{} = Accounts.change_preference(preference)
  #   end
  # end
end
