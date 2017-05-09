defmodule MarketIndexTest do
    use ExUnit.Case

    alias StooqReader.MarketIndex

    import Mock

    setup do
        [
            valid_http_response: %HTTPotion.Response{
                body: "Symbol,Data,Czas,Otwarcie,Najwyzszy,Najnizszy,Zamkniecie\r\nIndex,2017-04-18,10:01:00,58939.48,59223.25,58939.48,72329.99\r\n",
                headers: %HTTPotion.Headers{hdrs: %{"connection" => "keep-alive",
                    "content-length" => "121", "content-type" => "text/html; charset=utf-8",
                    "date" => "Tue, 09 May 2017 07:04:59 GMT",
                    "etag" => "W/\"79-D1FqbFeyb7Z8EzWtx0iLf3S4FWY\"",
                    "x-powered-by" => "Express"}}, 
                status_code: 200
            },
            index_val: 72329.99,
            invalid_http_response: %HTTPotion.ErrorResponse{
                message: "error"
            }

        ]
    end

    test "ask_stooq returns current value for requested index", context do
        with_mock HTTPotion, [get: fn(_) -> context[:valid_http_response] end] do
            response_wig = MarketIndex.ask_stooq(:wig)
            assert response_wig == {:ok, :wig, context[:index_val]}

            response_wig20 = MarketIndex.ask_stooq(:wig20)
            assert response_wig20 == {:ok, :wig20, context[:index_val]}

            response_wig20fut = MarketIndex.ask_stooq(:wig20fut)
            assert response_wig20fut == {:ok, :wig20fut, context[:index_val]}

            response_mwig40 = MarketIndex.ask_stooq(:mwig40)
            assert response_mwig40 == {:ok, :mwig40, context[:index_val]}
            
            response_swig80 = MarketIndex.ask_stooq(:swig80)
            assert response_swig80 == {:ok, :swig80, context[:index_val]}
        end
    end

    test "ask_stooq returns error message for invalid http request", context do
        with_mock HTTPotion, [get: fn(_) -> context[:invalid_http_response] end] do
            response_wig = MarketIndex.ask_stooq(:wig)
            assert response_wig == {:err, "error"}
        end
    end
end
