defmodule GraphqlApi.Pipeline.Producer do
  use GenStage

  alias GraphqlApi.Accounts

  def start_link(_) do
    GenStage.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_counter) do
    Process.send(self(), :scrape, [])
    {:producer, %{demand: 0, events: []}}
  end

  def handle_demand(new_demand, %{demand: demand, events: events}) do
    demand = demand + new_demand
    {outgoing_events, remaining_events} = Enum.split(events, demand)
    demand = demand - Enum.count(outgoing_events)
    state = %{demand: demand, events: remaining_events}

    {:noreply, outgoing_events, state}
  end

  def handle_info(:scrape, %{demand: demand, events: []}) do
    events =
      Accounts.all_users(%{})
      |> Enum.map(& &1.id)

    {outgoing_events, remaining_events} = Enum.split(events, demand)
    demand = demand - Enum.count(outgoing_events)
    state = %{demand: demand, events: remaining_events}


    Process.send_after(self(), :scrape, 10_000)

    {:noreply, outgoing_events, state}
  end

  def handle_info(:scrape, %{demand: demand, events: events}) do
    {outgoing_events, remaining_events} = Enum.split(events, demand)
    demand = demand - Enum.count(outgoing_events)
    state = %{demand: demand, events: remaining_events}


    Process.send_after(self(), :scrape, 10_000)

    {:noreply, outgoing_events, state}
  end
end
