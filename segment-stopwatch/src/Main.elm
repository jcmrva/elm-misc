module Main exposing (main)

import Browser exposing (Document, document)
import Html exposing (Html, div, text)
import Time exposing (..)


type alias Model =
    { time : Time.Posix
    , zone : Time.Zone
    , title : String
    , currentStart : Time.Posix
    , segments : List Segment
    , running : Bool
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
            , running = False
            , title = "Segment Stopwatch"
            , currentStart = 0 |> millisToPosix
            , segments = []
            }
    in
    ( initModel, Cmd.none )


type Msg
    = ReceiveTime Time.Posix
    | Start
    | Stop
    | Comment String
    | DeleteSegment Segment


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ReceiveTime time ->
            ( { model | time = time }, Cmd.none )

        Stop ->
            let
                newSegment =
                    { startTime = model.currentStart, endTime = model.time, comment = "" }
            in
            ( { model | segments = newSegment :: model.segments }, Cmd.none )

        _ ->
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
