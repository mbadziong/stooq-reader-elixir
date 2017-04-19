defmodule Webapp.Worker do
    use GenServer
    alias Webapp.StooqTask


    def start_link() do
        GenServer.start_link(__MODULE__, [])
    end

    def init([]) do
        schedule_work()
        {:ok, []}
    end

    def handle_info(:work, state) do
        state = do_work(state)
        schedule_work()
        {:noreply, state}
    end

    defp do_work(state) do
        StooqTask.fetch_market_index
        {:ok, state}
    end

    defp schedule_work do
        Process.send_after(self(), :work, 10_000)
    end
end