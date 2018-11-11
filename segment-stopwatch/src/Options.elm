module Options exposing (MaxSegments, UserOptions, setSegmentLimit, userOptionsDefault)


type alias UserOptions =
    { clockResolutionMillis : Float
    , maxSegments : MaxSegments
    }


userOptionsDefault =
    { clockResolutionMillis = 100
    , maxSegments = Unlimited
    }


type MaxSegments
    = Unlimited
    | Limit Int


setSegmentLimit l =
    if l >= 1 && l <= 1000 then
        Limit l

    else
        Unlimited


getLimit : UserOptions -> Int
getLimit opts =
    case opts.maxSegments of
        Limit l ->
            l

        Unlimited ->
            0
