defmodule GraphqlApi.Pipeline.Producer do
  use GenStage

  alias GraphqlApi.Accounts

  def start_link(initial \\ 0) do
    GenStage.start_link(__MODULE__, initial, name: __MODULE__)
  end

  def init(counter), do: {:producer, counter}

  def handle_demand(demand, state) do
    events =
      Accounts.all_users(%{})
      |> Enum.map(& &1.id)

    {:noreply, events, state + demand}
  end
end
