defmodule GraphqlApi.TokenCache do
  use Task, restart: :permanent

  @table_name :token_cache
  @ets_opts [
    :named_table,
    :public,
    :compressed,
    write_concurrency: true,
    read_concurrency: true
  ]

  def start_link(_opts \\ []) do
    Task.start_link(fn ->
      :ets.new(@table_name, @ets_opts)

      Process.hibernate(Function, :identity, [])
    end)
  end

  def put(key, value) do
    :ets.insert(@table_name, {key, value})
  end

  def get(key) do
    case :ets.lookup(@table_name, key) do
      [] -> nil
      [{^key, value}] -> value
    end
  end
end
