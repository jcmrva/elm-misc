module Main exposing (main)

import Browser exposing (Document, document)
import Html exposing (Html, div, text)
import Options exposing (..)
import Task exposing (..)
import Time exposing (..)


type alias Model =
    { time : Time.Posix
    , zone : Time.Zone
    , title : String
    , segments : List SegmentComplete
    , options : UserOptions
    , timer : Timer
    }


type Timer
    = Stopped
    | Running SegmentCurrent


type alias SegmentCurrent =
    { startTime : Time.Posix
    , abandon : Bool
    , comment : String
    }


type alias SegmentComplete =
    { startTime : Time.Posix
    , endTime : Time.Posix
    , comment : String
    }


init : flags -> ( Model, Cmd Msg )
init _ =
    let
        initModel =
            { time = 0 |> millisToPosix
            , zone = Time.utc
            , title = "Segment Stopwatch"
            , segments = []
            , options = userOptionsDefault
            , timer = Stopped
            }
    in
    ( initModel, Task.perform AdjustTimeZone Time.here )


view : Model -> Document Msg
view model =
    { title = model.title
    , body = [ body model ]
    }


body : Model -> Html Msg
body model =
    div [] []


type Msg
    = ReceiveTime Time.Posix
    | AdjustTimeZone Time.Zone
    | AdjustResolution
    | Start
    | Stop
    | Comment String
    | DeleteSegment
    | SaveLocal
    | DeleteLocal


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ReceiveTime time ->
            ( { model | time = time }, Cmd.none )

        AdjustTimeZone z ->
            ( { model | zone = z }, Cmd.none )

        Start ->
            let
                running =
                    Running (SegmentCurrent model.time False "")
            in
            ( { model | timer = running }, Cmd.none )

        Stop ->
            let
                segments =
                    case model.timer of
                        Running s ->
                            if s.abandon then
                                model.segments

                            else
                                SegmentComplete s.startTime model.time s.comment
                                    :: model.segments

                        Stopped ->
                            model.segments
            in
            ( { model | segments = segments, timer = Stopped }, Cmd.none )

        _ ->
            ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    -- case model.timer of
    -- Running _ ->
    -- _ ->
    --     Sub.none
    Time.every model.options.clockResolutionMillis ReceiveTime


main : Program () Model Msg
main =
    Browser.document
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
