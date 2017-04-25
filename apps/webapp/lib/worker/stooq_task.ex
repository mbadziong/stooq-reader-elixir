defmodule Webapp.StooqTask do
    alias Webapp.StooqChannel

    def fetch_market_index do
        case StooqReader.fetch_market_index do
            %{err: err} ->
                StooqChannel.send_err(err)
            market_index ->
                StooqChannel.send_update(market_index)
        end
    end
end
