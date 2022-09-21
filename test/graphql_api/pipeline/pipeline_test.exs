defmodule GraphqlApi.Pipeline.PipelineTest do
  use GraphqlApi.DataCase, async: true

  import GraphqlApi.AccountsFixtures, only: [user: 1]

  alias Ecto.Adapters.SQL.Sandbox
  alias GraphqlApi.TokenCache

  @expired ~U[2021-09-20 22:46:32.488564Z]
  @non_expired DateTime.utc_now()

  setup do
    pid =
      start_supervised!({GraphqlApi.Pipeline.Producer, 0})
      Sandbox.allow(GraphqlApi.Repo, self(), pid)
      start_supervised!(%{id: 1,start: {GraphqlApi.Pipeline.Consumer, :start_link, [[]]}})

      :ok
  end


 describe "pipeline" do
  setup :user



  test "updates an expired user token in the cache", %{user: user} do
    TokenCache.put(user.id, %{token: "FakeToken", timestamp: @expired})
    assert %{token: "FakeToken", timestamp: @expired} === TokenCache.get(user.id)
    Process.sleep(500)
    assert %{token: _token, timestamp: timestamp} = TokenCache.get(user.id)
    assert timestamp !== @expired
  end

  # test "does not update non-expired user token", %{user: user} do

  #   TokenCache.put(user.id + 1, %{token: "FakeToken", timestamp: @non_expired})
  #   assert %{token: "FakeToken", timestamp: @non_expired} === TokenCache.get(user.id + 1)
  #   Process.sleep(500)
  #   assert %{token: _token, timestamp: timestamp} = TokenCache.get(user.id + 1)
  #   assert timestamp === @non_expired
  # end

end


end
