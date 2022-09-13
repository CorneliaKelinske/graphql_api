defmodule GraphqlApi.HitCounterTest do
  use ExUnit.Case

  alias GraphqlApi.HitCounter

  @request :test_request

  describe "get_hits/2" do
    test "returns 0 when add_hit\2 has never been called with a given request" do
      assert HitCounter.get_hits(@request) === 0
    end
  end

  describe "add_hit/2" do
    test "increments the number of hits stored for a given request, every time the request is sent" do
      assert :ok = HitCounter.add_hit(@request)
      assert :ok = HitCounter.add_hit(@request)
      assert HitCounter.get_hits(@request) === 2
    end
  end
end
