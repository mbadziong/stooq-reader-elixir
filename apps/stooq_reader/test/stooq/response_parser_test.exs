defmodule ResponseParserTest do
    use ExUnit.Case

    alias StooqReader.ResponseParser

    import Mock

    setup do
        [
            body: "Symbol,Data,Czas,Otwarcie,Najwyzszy,Najnizszy,Zamkniecie\r\nIndex,2017-04-18,10:01:00,58939.48,59223.25,58939.48,72329.99\r\n",
            index_val: 72329.99,
            invalid_body: "Symbol,Data,Czas,Otwarcie,Najwyzszy,Najnizszy,Zamkniecie\r\nIndex,2017-04-18,10:01:00,58939.48,59223.25,58939.48,value\r\n",
            error_msg: "error message"
        ]
    end

    test "get_current_value parses response and returns float", context do
        current = ResponseParser.get_current_value({:ok, context[:body]})
        expected = {:ok, context[:index_val]}
        assert current == expected
    end

    test "get_current_value returns nil for invalid body", context do
        current = ResponseParser.get_current_value({:ok, context[:invalid_body]})
        expected = {:ok, nil}
        assert current == expected
    end

    test "get_current_value returns passed arguments if error", context do
        current = ResponseParser.get_current_value({:err, context[:error_msg]})
        expected = {:err, context[:error_msg]}
        assert current == expected
    end
end