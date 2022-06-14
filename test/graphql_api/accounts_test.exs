defmodule GraphqlApi.Accounts.Test do
  use GraphqlApi.DataCase, async: true
  import GraphqlApi.AccountsFixtures

  alias GraphqlApi.{Accounts, Repo}
  alias GraphqlApi.Accounts.{Preference, User}

  @valid_user_params %{name: "Harry", email: "dresden@example.com"}
  @valid_preference_params %{likes_emails: false, likes_phone_calls: false, likes_faxes: false}

  describe "all_users/1" do
    setup [:user]

    test "returns a list of all users when no parameters are given", %{
      user: %{id: id, name: name, email: email}
    } do
      assert {:ok, [%User{id: ^id, name: ^name, email: ^email}]} = Accounts.all_users()
    end

    test "returns a list of all users matching the given parameter(s)",  %{
      user: %{id: id, name: name, email: email}
    } do
      assert {:ok, [%User{id: ^id, name: ^name, email: ^email}]} = Accounts.all_users(%{email: email})
      assert {:ok, [%User{id: ^id, name: ^name, email: ^email}]} = Accounts.all_users(%{email: email, name: name})
    end

  end

  describe "find_user/1" do
    setup [:user]

    test "returns a a tuple with :ok and the corresponding user when a given Id exists", %{
      user: %{id: id, name: name, email: email}
    } do
      assert {:ok, %User{id: ^id, name: ^name, email: ^email}} = Accounts.find_user(%{id: id})
    end

    test "returns tuple with :error and reason when a given ID does not exist", %{user: user} do
      assert Accounts.find_user(%{id: user.id + 1}) === {:error, "no user with that id"}
    end
  end

  describe "update_user/2" do
    setup [:user]

    test "updates an existing user", %{user: user} do
      assert {:ok, [%User{email: "email@example.com"}]} = Accounts.all_users()

      assert {:ok, %User{email: "wizard@example.com"}} =
               Accounts.update_user(user.id, %{email: "wizard@example.com"})

      assert {:ok, [%User{email: "wizard@example.com"}]} = Accounts.all_users()
    end

    test "returns tuple with :error and map with error info when no update params are provided",
         %{user: user} do
      assert {:error, %{message: "no update params given", details: %{params: %{}}}} ===
               Accounts.update_user(user.id, %{})
    end
  end

  describe "create_user/1" do
    test "creates a new user" do
      assert {:ok, %User{}} = Accounts.create_user(@valid_user_params)

      assert [%User{}] = Repo.all(User)
    end

    test "creates a new user with preferences" do
      create_params = Map.put(@valid_user_params, :preferences, @valid_preference_params)

      assert {:ok, %User{id: id, preferences: %Preference{user_id: id}}} =
               Accounts.create_user(create_params)

      assert [%User{}] = Repo.all(User)
      assert [%Preference{}] = Repo.all(Preference)
    end
  end

  describe "delete_user/1" do
    setup [:user]

    test "deletes a user including their preferences", %{user: user} do
      Accounts.delete_user(user)
      assert Accounts.find_user(%{id: user.id}) === {:error, "no user with that id"}
      assert Accounts.all_preferences() === {:ok, []}
    end
  end

  describe "all_preferences/0" do
    setup [:user]

    test "returns a list of all preferences when no params are given", %{user: %{id: id}} do
      assert {:ok, [%Preference{user_id: ^id}]} = Accounts.all_preferences()
    end

    test "returns a list of all sets of preferences matching the given parameter(s)",  %{
      user: %{id: id}
    } do
      assert {:ok, [%Preference{user_id: ^id, likes_emails: false}]} = Accounts.all_preferences(%{likes_emails: false})
      assert {:ok, [%Preference{user_id: ^id, likes_emails: false, likes_faxes: false}]} = Accounts.all_preferences(%{likes_emails: false, likes_faxes: false})
    end

  end

  describe "find_preferences/1" do
    setup [:user]

    test "returns a a tuple with :ok and the corresponding preferences when preferences for a given user ID exist",
         %{
           user: %{id: id}
         } do
      assert {:ok, %Preference{user_id: ^id}} = Accounts.find_preferences_by_user_id(%{id: id})
    end

    test "returns tuple with :error and reason when there are no preference for a given user ID",
         %{user: user} do
      assert Accounts.find_preferences_by_user_id(%{id: user.id + 1}) ===
               {:error, "no preferences found for this user ID"}
    end
  end

  describe "update_preferences/2" do
    setup [:user]

    test "returns updated preferences", %{user: %{id: id}} do
      {:ok,
       %Preference{user_id: ^id, likes_emails: true, likes_faxes: false, likes_phone_calls: false}} =
        Accounts.update_preferences(id, %{likes_emails: true})
    end

    test "returns tuple with :error and map with error info when no update params are provided",
         %{user: user} do
      assert {:error, %{message: "no update params given", details: %{params: %{}}}} ===
               Accounts.update_preferences(user.id, %{})
    end
  end
end
