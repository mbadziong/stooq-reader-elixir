defmodule StooqReader do

  alias StooqReader.MarketIndex

  @indexes [:wig, :wig20, :wig20fut, :mwig40, :swig80]
  @parse_error "Parse error"
  @time_key :time

  def fetch_market_index do
    @indexes
    |> Enum.map(&MarketIndex.ask_stooq/1)
    |> to_map
    |> add_current_date
  end

  defp to_map(index) do
    case index do
      [{:ok, _, _} | _tail] -> 
        if Enum.filter(index, &(elem(&1, 2) == nil)) |> length > 0 do
          [{:err, @parse_error}]
        else
          index |> Enum.map(fn index -> {elem(index, 1), elem(index, 2)} end)
        end
      _ -> index
    end
    |> Enum.into(%{})
  end

  defp add_current_date(marketIndex) do
    marketIndex
    |> Map.put(@time_key, DateTime.to_unix(DateTime.utc_now))
  end
end
