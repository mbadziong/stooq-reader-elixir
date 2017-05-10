module Stooq.Table.TableViewHelper exposing (createRows, getColor)

import Stooq.Model.IndexUpdateState as State exposing (..)
import Stooq.Model.MarketIndex exposing (MarketIndex)
import Stooq.Model.MarketIndexRow exposing (MarketIndexRow)
import Material.Color as Color
import Material.Options as Options


createRows : List MarketIndex -> List MarketIndexRow
createRows list =
    case list of
        [] ->
            []

        hd :: tl ->
            createRowsAcc tl hd


createRowsAcc : List MarketIndex -> MarketIndex -> List MarketIndexRow
createRowsAcc acc curr =
    case acc of
        [] ->
            (createRow curr Nothing) :: []

        prev :: tl ->
            (createRow curr (Just prev)) :: (createRowsAcc tl prev)


createRow : MarketIndex -> Maybe MarketIndex -> MarketIndexRow
createRow curr prev =
    MarketIndexRow
        curr.wig
        (case prev of
            Just val ->
                getIndexUpdateState curr.wig val.wig

            Nothing ->
                State.Same
        )
        curr.wig20
        (case prev of
            Just val ->
                getIndexUpdateState curr.wig20 val.wig20

            Nothing ->
                State.Same
        )
        curr.wig20fut
        (case prev of
            Just val ->
                getIndexUpdateState curr.wig20fut val.wig20fut

            Nothing ->
                State.Same
        )
        curr.mwig40
        (case prev of
            Just val ->
                getIndexUpdateState curr.mwig40 val.mwig40

            Nothing ->
                State.Same
        )
        curr.swig80
        (case prev of
            Just val ->
                getIndexUpdateState curr.swig80 val.swig80

            Nothing ->
                State.Same
        )
        curr.time


getIndexUpdateState : Float -> Float -> IndexUpdateState
getIndexUpdateState curr prev =
    if curr > prev then
        State.Increasing
    else if prev > curr then
        State.Decreasing
    else
        State.Same


getColor : IndexUpdateState -> Options.Property c m
getColor icon =
    let
        color =
            (case icon of
                State.Decreasing ->
                    Color.Red

                State.Increasing ->
                    Color.Green

                State.Same ->
                    Color.Grey
            )
    in
        Color.background (Color.color color Color.S300)
