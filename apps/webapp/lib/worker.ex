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
        response = StooqTask.fetch_market_index
        case state do
            [] -> StooqTask.send(response)
            _ -> StooqTask.send_if_no_duplicate(state, response)
        end

        case response do
                %{err: _} -> state
                _ -> {:ok, response}
            end
    end

    defp schedule_work do
        Process.send_after(self(), :work, 10_000)
    end
end