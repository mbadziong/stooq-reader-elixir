defmodule Webapp.StooqChannel do
    use Phoenix.Channel

    def join("stooq:update", _payload, socket) do
        {:ok, socket}
    end

    def send_update(market_index) do
        payload = %{
            "marketIndex" => market_index
        }

        Webapp.Endpoint.broadcast("stooq:update", "update", payload)
    end

    def send_err(msg) do
        Webapp.Endpoint.broadcast("stooq:update", "error", msg)
    end
end