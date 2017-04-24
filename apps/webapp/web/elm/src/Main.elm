module Main exposing (..)

import Html exposing (Html, program, div, text)
import Date exposing (fromTime)
import Date.Extra exposing (toFormattedString)
import Material.Table as Table
import Stooq.WebsocketPorts exposing (newMarketIndex, error)
import Stooq.MarketIndex exposing (MarketIndex)
import Stooq.Error exposing (Error)
import Stooq.Consts exposing (columnNames, dateFormat)


main : Program Never Model Msg
main =
    program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- MODEL


type alias Model =
    { allIndexes : List MarketIndex
    , currentIndex : Maybe MarketIndex
    , error : Maybe String
    }



-- INIT


init : ( Model, Cmd Msg )
init =
    ( Model [] Nothing Nothing, Cmd.none )



-- UPDATE


type Msg
    = NewIndex MarketIndex
    | StooqError Error


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NewIndex marketIndex ->
            let
                all =
                    model.allIndexes
            in
                { model | allIndexes = marketIndex :: all, currentIndex = Just marketIndex, error = Nothing } ! []

        StooqError error ->
            { model | currentIndex = Nothing, error = Just error.message } ! []



-- VIEW


view : Model -> Html Msg
view model =
    Table.table []
        [ Table.thead []
            [ Table.tr []
                (List.map
                    (\index ->
                        Table.th [] [ text index ]
                    )
                    columnNames
                )
            ]
        , Table.tbody []
            (List.map
                (\marketIndex ->
                    Table.tr []
                        [ Table.th [] [ text (toFormattedString dateFormat (Date.fromTime (toFloat marketIndex.time * 1000))) ]
                        , Table.th [] [ text marketIndex.wig ]
                        , Table.th [] [ text marketIndex.wig20 ]
                        , Table.th [] [ text marketIndex.wig20fut ]
                        , Table.th [] [ text marketIndex.mwig40 ]
                        , Table.th [] [ text marketIndex.swig80 ]
                        ]
                )
                (List.take
                    50
                    model.allIndexes
                )
            )
        ]



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ newMarketIndex NewIndex
        , error StooqError
        ]
