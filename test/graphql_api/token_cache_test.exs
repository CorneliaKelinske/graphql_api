defmodule GraphqlApi.TokenCacheTest do
  use ExUnit.Case, async: true

  alias GraphqlApi.TokenCache

  describe "get/1" do
    test "returns nil when given key is not found" do
      assert nil === TokenCache.get(0)
    end
  end
end
