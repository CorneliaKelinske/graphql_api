defmodule GraphqlApi.HitTracker do
  use Agent
  alias GraphqlApi.HitTracker

  @default_name HitTracker

  def start_link(opts \\ []) do
    initial_state = %{}
    opts = Keyword.put_new(opts, :name, @default_name)
    Agent.start_link(fn -> initial_state end, opts)
  end


  def add_hit(name \\ @default_name, message) do
    Agent.update(name, fn state ->
      Map.update(state, message, 1, & &1+1)
    end)
  end

  def get_hits(name \\ @default_name, message) do
    Agent.get(name, &Map.get(&1, message, 0))
  end





end
