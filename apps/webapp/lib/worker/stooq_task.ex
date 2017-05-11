defmodule Webapp.StooqTask do
    alias Webapp.StooqChannel

    def fetch_market_index do
        StooqReader.fetch_market_index
    end

    def send(response) do
        case response do
            %{err: err} ->
                StooqChannel.send_err(err)
            market_index ->
                log_and_send(market_index)
        end
    end

    def send_if_no_duplicate(state, current) do
        case state do
            %{err: _err, time: _time} ->
                send(current)
            _ ->
                if not duplicate(state, current) do
                    send(current)
                end
        end
    end

    defp duplicate({:ok, latest}, current) do
        indexes = Map.keys(current) |> List.delete(:time)
        not List.foldl(indexes, false, fn(index, acc) -> 
            acc || latest[index] != current[index]
        end)
    end

    defp log_and_send(market_index) do
        FileLogger.append(market_index)
        StooqChannel.send_update(market_index)
    end
end
