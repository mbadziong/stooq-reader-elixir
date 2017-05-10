module Stooq.Model.MarketIndexRow exposing (MarketIndexRow)

import Stooq.Model.IndexUpdateState exposing (IndexUpdateState)


type alias MarketIndexRow =
    { wig : Float
    , wigIcon : IndexUpdateState
    , wig20 : Float
    , wig20Icon : IndexUpdateState
    , wig20fut : Float
    , wig20futIcon : IndexUpdateState
    , mwig40 : Float
    , mwig40Icon : IndexUpdateState
    , swig80 : Float
    , swig80Icon : IndexUpdateState
    , time : Float
    }
