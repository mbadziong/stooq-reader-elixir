defmodule StooqReaderTest do
  use ExUnit.Case

  test "the truth" do
    IO.inspect(StooqReader.fetch_market_index)
    assert 1 + 1 == 2
  end
end
