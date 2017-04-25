defmodule StooqReader.MarketIndex do
    alias StooqReader.ResponseParser

    @base_url Application.get_env(:stooq_reader, :api_base_url)

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
            {:err, msg} -> {:err, msg}
        end
    end

    defp get_index(index) do
        index
        |> build_url
        |> HTTPotion.get()
        |> response
        |> ResponseParser.get_current_value
    end

    defp build_url(index) do
        @base_url <> @prefix <> index <> @suffix
    end

    defp response(%HTTPotion.Response{:body => body, :headers => _, :status_code => _}) do
        {:ok, body}
    end

    defp response(%HTTPotion.ErrorResponse{:message => msg}) do
        {:err, msg}
    end
end