module Main exposing (..)

import Html exposing (Html, program, div, text)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)
import String
import Stooq.WebsocketPorts exposing (newMarketIndex, error)
import Stooq.MarketIndex exposing (MarketIndex)
import Stooq.Error exposing (Error)


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
    div []
        [ text (toString model)
        ]



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ newMarketIndex NewIndex
        , error StooqError
        ]
