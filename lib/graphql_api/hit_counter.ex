defmodule GraphqlApi.HitCounter do
  @moduledoc """
  Starts up the counter and stores it as a persistent term
  """

  @type request ::
          :preferences
          | :user_preferences
          | :users
          | :user
          | :resolver_hits
          | :update_user_preferences
          | :create_user
          | :update_user
          | :test_request

  @request_types [
    :preferences,
    :user_preferences,
    :users,
    :user,
    :resolver_hits,
    :update_user_preferences,
    :create_user,
    :update_user,
    :test_request
  ]

  @indexes %{
    preferences: 1,
    update_user_preferences: 2,
    user_preferences: 3,
    resolver_hits: 4,
    users: 5,
    user: 6,
    create_user: 7,
    update_user: 8,
    test_request: 9
  }

  @spec setup_counter :: :ok
  def setup_counter do
    hit_counter = :counters.new(9, [:write_concurrency])
    :persistent_term.put(:hit_counter, hit_counter)
  end

  @spec add_hit(request()) :: :ok
  def add_hit(request) when request in @request_types do
    :counters.add(hit_counter(), index(request), 1)
  end

  @spec get_hits(request()) :: integer()
  def get_hits(request) when request in @request_types do
    :counters.get(hit_counter(), index(request))
  end

  @spec request_types :: [request()]
  def request_types, do: @request_types

  defp hit_counter do
    :persistent_term.get(:hit_counter)
  end

  defp index(request) do
    Map.get(@indexes, request)
  end
end
