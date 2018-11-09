module Main exposing (main)

import Browser exposing (Document, document)
import Html exposing (Html, div, text)
import Time exposing (..)


type alias Model =
    { time : Time.Posix
    , zone : Time.Zone
    , title : String
    , segments : List Segment
    }


type alias Segment =
    { startTime : Time.Posix
    , endTime : Time.Posix
    , comment : String
    }


view : Model -> Document Msg
view model =
    { title = model.title
    , body = body model
    }


body : Model -> List (Html Msg)
body model =
    [ div [] [] ]


init : flags -> ( Model, Cmd Msg )
init _ =
    let
        initModel =
            { time = 0 |> millisToPosix
            , zone = Time.utc
            , title = ""
            , segments = []
            }
    in
    ( initModel, Cmd.none )


type Msg
    = ReceiveTime Time.Posix
    | NoOp


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ReceiveTime time ->
            let
                nextmodel =
                    { model | time = time }
            in
            ( nextmodel, Cmd.none )

        NoOp ->
            ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Time.every 1000 ReceiveTime


main : Program () Model Msg
main =
    Browser.document
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
