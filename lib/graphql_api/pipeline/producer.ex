defmodule GraphqlApi.Pipeline.Producer do
  use GenStage

  alias GraphqlApi.Accounts

  def start_link(initial \\ 0) do
    GenStage.start_link(__MODULE__, initial, name: __MODULE__)
  end

  def init(counter) do
    Process.send_after(self(), :scrape, 1_000)
    {:producer, counter}
  end

  def handle_demand(demand, state) do
    {:noreply, [], state + demand}
  end

  def handle_info(:scrape, state) do
    events =
      Accounts.all_users(%{})
      |> Enum.map(& &1.id)

      Process.send_after(self(), :scrape, 10_000)

    {:noreply, events, state}
  end


end
