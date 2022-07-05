defmodule GraphqlApi.HitTrackerTest do
  use ExUnit.Case, async: true

  alias GraphqlApi.HitTracker

  @request :create_user

  setup do
    {:ok, pid} = HitTracker.start_link(name: nil)
    %{pid: pid}
  end

  describe "get_hits/2" do
    test "returns 0 when add_hit\2 has never been called with a given request", %{pid: pid} do
      assert HitTracker.get_hits(pid, @request) === 0
    end
  end

  describe "add_hit/2" do
    test "increments the number of hits stored for a given request, every time the request is sent",
         %{pid: pid} do
      assert :ok = HitTracker.add_hit(pid, @request)
      assert :ok = HitTracker.add_hit(pid, @request)
      assert HitTracker.get_hits(pid, @request) === 2
    end
  end
end
