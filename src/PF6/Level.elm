module PF6.Level exposing
    ( Level
    , level
    , withGutter
    , toMarkup
    )

{-| PF6 Level layout

Distributes items evenly, centered horizontally. Items wrap on resize.

See: <https://www.patternfly.org/layouts/level>


# Definition

@docs Level


# Constructor

@docs level


# Modifiers

@docs withGutter


# Rendering

@docs toMarkup

-}

import Element exposing (Element)
import PF6.Tokens as Tokens


{-| Opaque Level type
-}
type Level msg
    = Level (Options msg)


type alias Options msg =
    { items : List (Element msg)
    , hasGutter : Bool
    }


{-| Construct a Level with a list of items distributed evenly
-}
level : List (Element msg) -> Level msg
level items =
    Level { items = items, hasGutter = False }


{-| Add medium gutter spacing between items
-}
withGutter : Level msg -> Level msg
withGutter (Level opts) =
    Level { opts | hasGutter = True }


{-| Render the Level as an Element msg
-}
toMarkup : Level msg -> Element msg
toMarkup (Level opts) =
    let
        spacingAttr =
            if opts.hasGutter then
                Element.spacing Tokens.spacerMd

            else
                Element.spacing 0

        wrapItem child =
            Element.el
                [ Element.width Element.fill
                , Element.centerX
                ]
                (Element.el [ Element.centerX ] child)
    in
    Element.row
        [ Element.width Element.fill
        , spacingAttr
        ]
        (List.map wrapItem opts.items)
