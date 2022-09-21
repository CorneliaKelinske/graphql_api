defmodule GraphqlApi.Pipeline.PipelineTest do
  use GraphqlApi.DataCase, async: true

  import GraphqlApi.AccountsFixtures, only: [user: 1, user2: 1]

  alias GraphqlApi.TokenCache

  @expired ~U[2021-09-20 22:46:32.488564Z]
  @non_expired DateTime.utc_now()



 describe "pipeline" do
  setup [:user, :user2]



  test "updates an expired user token", %{user: user} do
    TokenCache.put(user.id, %{token: "FakeToken", timestamp: @expired})
    assert %{token: "FakeToken", timestamp: @expired} === TokenCache.get(user.id)
    start_pipeline()
    assert_receive(:sync, 5000)
    assert_receive(:sync, 5000)
    assert_receive(:sync, 5000)
    assert %{token: _token, timestamp: timestamp} = TokenCache.get(user.id)
    assert timestamp !== @expired
  end

  # test "does not update non-expired user token", %{user: user2} do

  #   TokenCache.put(user2.id, %{token: "FakeToken", timestamp: @non_expired})
  #   assert %{token: "FakeToken", timestamp: @non_expired} === TokenCache.get(user2.id)
  #   start_pipeline()
  #   Process.sleep(500)
  #   assert %{token: _token, timestamp: timestamp} = TokenCache.get(user2.id)
  #   assert timestamp === @non_expired
  # end

end

defp start_pipeline() do
    start_supervised!({GraphqlApi.Pipeline.Producer, self()})
    start_supervised!(%{id: 1,start: {GraphqlApi.Pipeline.Consumer, :start_link, [self()]}})
end


end
