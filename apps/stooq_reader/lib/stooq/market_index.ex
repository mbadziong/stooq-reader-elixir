defmodule StooqReader.MarketIndex do
    use Tesla

    alias StooqReader.ResponseParser

    plug Tesla.Middleware.BaseUrl, Application.get_env(:stooq_reader, :api_base_url)

    @indexes %{
        :wig => "wig",
        :wig20 => "wig20",
        :wig20fut => "fw20",
        :mwig40 => "mwig40",
        :swig80 => "swig80"
    }

    @prefix "?s="
    @suffix "&f=sd2t2ohlc&h"

    def ask_stooq(index) do
        case @indexes[index] |> get_index do
            {:ok, body} -> {:ok, index, body}
            {:err} -> {:err}
        end
    end

    defp get_index(index) do
        get(query_params_for(index))
        |> response
        |> ResponseParser.get_current_value
    end

    defp query_params_for(index) do
        @prefix <> index <> @suffix
    end

    defp response(%Tesla.Env{:body => body, :headers => _, :status => 200, :url => _}) do
        {:ok, body}
    end

    defp response(%Tesla.Env{:body => _, :headers => _, :status => _, :url => _}) do
        {:err}
    end
end