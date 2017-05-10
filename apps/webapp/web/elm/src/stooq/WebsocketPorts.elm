port module Stooq.WebsocketPorts exposing (newMarketIndex, error)

import Stooq.Model.MarketIndex exposing (MarketIndex)
import Stooq.Model.Error exposing (Error)


port newMarketIndex : (MarketIndex -> msg) -> Sub msg


port error : (Error -> msg) -> Sub msg
