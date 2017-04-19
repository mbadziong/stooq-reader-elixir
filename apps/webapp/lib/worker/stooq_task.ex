defmodule Webapp.StooqTask do
    
    def fetch_market_index do
        case StooqReader.fetch_market_index do
            {:err, msg} -> 
                Webapp.StooqChannel.send_err(msg)
            market_index -> 
                Webapp.StooqChannel.send_update(market_index)
        end
    end
end