port module Stooq.WebsocketPorts exposing (newMarketIndex, error)

import Stooq.MarketIndex exposing (MarketIndex)
import Stooq.Error exposing (Error)


port newMarketIndex : (MarketIndex -> msg) -> Sub msg


port error : (Error -> msg) -> Sub msg
