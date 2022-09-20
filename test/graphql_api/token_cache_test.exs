defmodule GraphqlApi.TokenCacheTest do
  use ExUnit.Case, async: true

  alias GraphqlApi.TokenCache

  describe "get/1 and put/2" do
    test "get/1 returns nil of key is not found, put/2 stores or updates a given key value pair" do
      assert nil === TokenCache.get(0)
      timestamp = DateTime.utc_now()
      assert true === TokenCache.put(0, %{token: "FakeToken", timestamp: timestamp})
      assert %{token: "FakeToken", timestamp: timestamp} === TokenCache.get(0)
      new_timestamp = DateTime.utc_now()
      assert true === TokenCache.put(0, %{token: "FakeToken", timestamp: new_timestamp})
      assert %{token: "FakeToken", timestamp: new_timestamp} === TokenCache.get(0)
    end
  end
end
