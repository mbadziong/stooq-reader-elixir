defmodule StooqReaderTest do
    use ExUnit.Case

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
            market_index: %{
                mwig40: 72329.99, swig80: 72329.99, time: 1494321695, wig: 72329.99,
                wig20: 72329.99, wig20fut: 72329.99
            },
            unix_time: 1494321695,
            utc_now: %DateTime{calendar: Calendar.ISO, day: 9, hour: 9, microsecond: {113000, 6},
                minute: 30, month: 5, second: 21, std_offset: 0, time_zone: "Etc/UTC",
                utc_offset: 0, year: 2017, zone_abbr: "UTC"
            },
            invalid_http_response: %HTTPotion.ErrorResponse{
                message: "error"
            },
            market_index_error: %{err: "error", time: 1494321695}
        ]
    end

    test "fetch_market_index returns market index values", context do
        with_mocks([
            {HTTPotion, [], [get: fn(_) -> context[:valid_http_response] end]},
            {DateTime, [], [to_unix: fn(_) -> context[:unix_time] end,
                            utc_now: fn() -> context[:utc_now] end]}
        ]) do
            current = StooqReader.fetch_market_index
            expected = context[:market_index]
            assert current == expected
        end
    end

    test "fetch_market_index returns error if http call fails", context do
        with_mocks([
            {HTTPotion, [], [get: fn(_) -> context[:invalid_http_response] end]},
            {DateTime, [], [to_unix: fn(_) -> context[:unix_time] end,
                            utc_now: fn() -> context[:utc_now] end]}
        ]) do
            current = StooqReader.fetch_market_index
            expected = context[:market_index_error]
            assert current == expected
        end
    end
end
