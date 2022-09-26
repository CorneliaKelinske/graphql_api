defmodule GraphqlApi.TokenCacheTest do
  use GraphqlApi.DataCase, async: true

  import GraphqlApi.UserFixtures, only: [user: 1]

  alias GraphqlApi.TokenCache

  setup :user

  describe "get/1 and put/2" do
    test "get/1 returns nil of key is not found, put/2 stores or updates a given key value pair",
         %{user: %{id: id}} do
      assert nil === TokenCache.get(id)
      timestamp = DateTime.utc_now()
      assert :ok === TokenCache.put(id, %{token: "FakeToken", timestamp: timestamp})
      assert %{token: "FakeToken", timestamp: timestamp} === TokenCache.get(id)
      new_timestamp = DateTime.utc_now()
      assert :ok === TokenCache.put(id, %{token: "FakeToken", timestamp: new_timestamp})
      assert %{token: "FakeToken", timestamp: new_timestamp} === TokenCache.get(id)
    end
  end
end
