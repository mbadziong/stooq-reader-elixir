defmodule Webapp.StooqChannel do
    use Phoenix.Channel
    alias Webapp.Endpoint

    def join("stooq:update", _payload, socket) do
        {:ok, socket}
    end

    def send_update(market_index) do
        Endpoint.broadcast("stooq:update", "update", market_index)
    end

    def send_err(msg) do
        Endpoint.broadcast("stooq:update", "error", %{message: msg})
    end
end