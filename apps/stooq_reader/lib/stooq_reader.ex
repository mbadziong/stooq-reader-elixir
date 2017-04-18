defmodule StooqReader do

  alias StooqReader.MarketIndex

  @indexes [:wig, :wig20, :wig20fut, :mwig40, :swig80]

  def fetch_market_index do
    @indexes
    |> Enum.map(&MarketIndex.ask_stooq/1)
    |> validate
  end

  defp validate(index) do
    if Enum.filter(index, &(elem(&1, 2) == nil)) |> length > 0 do
      {:err, "Parse error"}
    else
      index
    end
  end
end
