module Main exposing (..)

import Html exposing (Html, program, div, text, p)
import Date exposing (fromTime)
import Date.Extra exposing (toFormattedString)
import Material
import Material.Table as Table
import Material.Layout as Layout
import Material.Options as Options
import Material.Typography as Typo
import Stooq.WebsocketPorts exposing (newMarketIndex, error)
import Stooq.Model.MarketIndex exposing (MarketIndex)
import Stooq.Table.TableViewHelper exposing (createRows, getColor)
import Stooq.Model.Error exposing (Error)
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
    , mdl : Material.Model
    }



-- INIT


init : ( Model, Cmd Msg )
init =
    ( Model [] Nothing Nothing Material.model, Cmd.none )



-- UPDATE


type Msg
    = NewIndex MarketIndex
    | Mdl (Material.Msg Msg)
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

        Mdl msg_ ->
            Material.update Mdl msg_ model



-- VIEW


view : Model -> Html Msg
view model =
    Layout.render Mdl
        model.mdl
        [ Layout.fixedHeader
        ]
        { header =
            [ Layout.row
                []
                [ Layout.title [] [ text "Stooq Reader" ]
                , Layout.spacer
                ]
            ]
        , drawer = []
        , tabs = ( [], [] )
        , main =
            [ Options.div
                [ Options.center ]
                [ Table.table []
                    [ Table.thead []
                        [ Table.tr []
                            (List.map
                                (\index ->
                                    Table.th []
                                        [ Options.styled p
                                            [ Typo.center ]
                                            [ text index ]
                                        ]
                                )
                                columnNames
                            )
                        ]
                    , Table.tbody []
                        (List.map
                            (\marketIndex ->
                                Table.tr []
                                    [ Table.th [] [ text (toFormattedString dateFormat (Date.fromTime (marketIndex.time * 1000))) ]
                                    , Table.th [ getColor marketIndex.wigIcon ] [ text (toString marketIndex.wig) ]
                                    , Table.th [ getColor marketIndex.wig20Icon ] [ text (toString marketIndex.wig20) ]
                                    , Table.th [ getColor marketIndex.wig20futIcon ] [ text (toString marketIndex.wig20fut) ]
                                    , Table.th [ getColor marketIndex.mwig40Icon ] [ text (toString marketIndex.mwig40) ]
                                    , Table.th [ getColor marketIndex.swig80Icon ] [ text (toString marketIndex.swig80) ]
                                    ]
                            )
                            (List.take
                                50
                                (createRows model.allIndexes)
                            )
                        )
                    ]
                ]
            ]
        }



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ newMarketIndex NewIndex
        , error StooqError
        ]
