defmodule GraphqlApi.HitTracker do
  @moduledoc """
  Tracks how often the GraphQL server is hit with
  each of the possible requests
  """
  use Agent
  alias GraphqlApi.HitTracker

  @type request ::
          :preferences
          | :user_preferences
          | :users
          | :user
          | :resolver_hits
          | :update_user_preferences
          | :create_user
          | :update_user

  @request_types [
    :preferences,
    :user_preferences,
    :users,
    :user,
    :resolver_hits,
    :update_user_preferences,
    :create_user,
    :update_user
  ]

  @default_name HitTracker

  @spec start_link :: {:ok, pid} | {:error, any}
  @spec start_link(keyword) :: {:ok, pid} | {:error, any}
  def start_link(opts \\ []) do
    initial_state = %{}
    opts = Keyword.put_new(opts, :name, @default_name)
    Agent.start_link(fn -> initial_state end, opts)
  end

  @spec add_hit(request()) :: :ok
  @spec add_hit(atom() | pid, request()) :: :ok
  def add_hit(name \\ @default_name, request) when request in @request_types do
    Agent.update(name, fn state ->
      Map.update(state, request, 1, &(&1 + 1))
    end)
  end

  @spec get_hits(request()) :: non_neg_integer()
  @spec get_hits(atom() | pid, request()) :: non_neg_integer()
  def get_hits(name \\ @default_name, request) when request in @request_types do
    Agent.get(name, &Map.get(&1, request, 0))
  end

  @spec request_types :: [request()]
  def request_types, do: @request_types
end
