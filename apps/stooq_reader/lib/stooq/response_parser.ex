defmodule StooqReader.ResponseParser do

    @current_value_key "Zamkniecie"
    @row_separator "\r\n"
    @value_separator ","

    def get_current_value(response) do
        case response do
            {:ok, body} -> {:ok, parse_body(body)}
            {:err, msg} -> {:err, msg}
        end
    end

    defp parse_body(body) do
        case csv_to_rows(body) do
            rows when length(rows) > 1 ->
                Enum.zip(Enum.at(rows, 0), Enum.at(rows, 1))
                |> Enum.find(fn tuple -> elem(tuple, 0) == @current_value_key end)
                |> elem(1)
                |> parse_float
            _ -> nil
        end
    end

    defp csv_to_rows(body) do
        body
        |> String.split(@row_separator)
        |> Enum.filter_map(&(String.length(&1) > 0), &(String.split(&1, @value_separator)))
    end

    defp parse_float(str) do
        case Float.parse(str) do
            {val, _} -> val
            :error -> nil
        end
    end
end
