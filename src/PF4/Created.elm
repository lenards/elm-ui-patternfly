module PF4.Created exposing
    ( created
    , toMarkup
    )

{-| A component for showing "time since created", in days

Not listed in the official PatternFly 4 component list.


# Constructor function

@docs created


# Rendering element

@docs toMarkup

-}

import Element exposing (Element)
import Time


{-| Opaque `Created` element that can produce `msg` messages
-}
type Created msg
    = Created (Options msg)


type alias Options msg =
    { createdOn : Time.Posix
    , now : Time.Posix
    , extraAttributes : List (Element.Attribute msg)
    }


{-| Constructs a `Created msg` element using a record
with a `createdOn` and `now` value.

Uses `Time` in `elm/time`.

    Created.created
        { createdOn = Time.millisToPosix 1609468521866
        , now = Time.millisToPosix 1609468694666
        }
        |> Created.toMarkup

-}
created : { createdOn : Time.Posix, now : Time.Posix } -> Created msg
created { createdOn, now } =
    Created
        { createdOn = createdOn
        , now = now
        , extraAttributes = []
        }


withExtraAttributes : List (Element.Attribute msg) -> Created msg -> Created msg
withExtraAttributes extra (Created options) =
    Created { options | extraAttributes = extra }


calcUnitsAgo_ : Options msg -> { number : Int, label : String }
calcUnitsAgo_ options =
    let
        secondsDiff =
            Time.posixToMillis options.now
                - Time.posixToMillis options.createdOn
    in
    if secondsDiff > (24 * 60 * 60) then
        { number = secondsDiff // (24 * 60 * 60)
        , label = "days"
        }

    else if secondsDiff > (60 * 60) then
        { number = secondsDiff // (60 * 60)
        , label = "hours"
        }

    else
        { number = secondsDiff // 60
        , label = "minutes"
        }


{-| Given the custom type representation, renders as an `Element msg`.
-}
toMarkup : Created msg -> Element msg
toMarkup (Created options) =
    let
        { number, label } =
            calcUnitsAgo_ options

        attrs_ =
            options.extraAttributes

        createdLabel =
            "Created "
                ++ String.fromInt number
                ++ " "
                ++ label
                ++ " ago."
    in
    Element.el attrs_ <|
        Element.text createdLabel
