defmodule GraphqlApi.PipelineTest do
  use GraphqlApi.DataCase, async: true

  import GraphqlApi.AccountsFixtures, only: [user: 1]

  alias GraphqlApi.TokenCache

  @expired ~U[2021-09-20 22:46:32.488564Z]
  @non_expired DateTime.utc_now()

  describe "pipeline" do
    setup :user

    test "updates an expired user token", %{user: user} do
      TokenCache.put(user.id, %{token: "FakeToken", timestamp: @expired})
      assert %{token: "FakeToken", timestamp: @expired} === TokenCache.get(user.id)
      start_pipeline()
      assert_receive(:sync, 500)
      assert %{token: _token, timestamp: timestamp} = TokenCache.get(user.id)
      assert timestamp !== @expired
    end

    test "does not update non-expired user token", %{user: user} do
      TokenCache.put(user.id, %{token: "FakeToken", timestamp: @non_expired})
      assert %{token: "FakeToken", timestamp: @non_expired} === TokenCache.get(user.id)
      start_pipeline()
      assert_receive(:sync, 500)
      assert %{token: _token, timestamp: timestamp} = TokenCache.get(user.id)
      assert timestamp === @non_expired
    end
  end

  defp start_pipeline do
    start_supervised!({GraphqlApi.Pipeline.Producer, self()})
    start_supervised!({GraphqlApi.Pipeline.ConsumerSupervisor, self()})
  end
end
