defmodule GraphqlApi.TokenCache do
  @moduledoc false
  use Task, restart: :permanent

  @table_name :token_cache
  @ets_opts [
    :named_table,
    :public,
    :compressed,
    write_concurrency: true,
    read_concurrency: true
  ]

  @type token_cache_value :: %{timestamp: DateTime.t(), token: binary}

  @spec start_link(any) :: {:ok, pid}
  def start_link(_opts \\ []) do
    Task.start_link(fn ->
      _ = :ets.new(@table_name, @ets_opts)

      Process.hibernate(Function, :identity, [])
    end)
  end

  @spec put(non_neg_integer(), token_cache_value()) :: true
  def put(key, value) do
    :ets.insert(@table_name, {key, value})
  end

  @spec get(non_neg_integer()) :: token_cache_value() | nil
  def get(key) do
    case :ets.lookup(@table_name, key) do
      [] -> nil
      [{^key, value}] -> value
    end
  end
end
