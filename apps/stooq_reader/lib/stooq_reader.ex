defmodule StooqReader do

  alias StooqReader.MarketIndex

  @indexes [:wig, :wig20, :wig20fut, :mwig40, :swig80]

  def fetch_market_index do
    @indexes
    |> Enum.map(&MarketIndex.ask_stooq/1)
    |> to_map
  end

  defp to_map(index) do
    case index do
      [{:err} | _tail] -> [{:err, "API error"}]
      [{:ok, _, _} | _tail] -> 
        if Enum.filter(index, &(elem(&1, 2) == nil)) |> length > 0 do
          [{:err, "Parse error"}]
        else
          index |> Enum.map(fn index -> {elem(index, 1), elem(index, 2)} end)
        end
    end
    |> Enum.into(%{})
  end
end
