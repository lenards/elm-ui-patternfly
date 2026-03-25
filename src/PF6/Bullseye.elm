module PF6.Bullseye exposing
    ( Bullseye
    , bullseye
    , withPadding, withMinHeight
    , toMarkup
    )

{-| PF6 Bullseye layout

Centers content vertically and horizontally in a container.
Can only contain one section of content.

See: <https://www.patternfly.org/layouts/bullseye>


# Definition

@docs Bullseye


# Constructor

@docs bullseye


# Modifiers

@docs withPadding, withMinHeight


# Rendering

@docs toMarkup

-}

import Element exposing (Element)
import PF6.Theme exposing (Theme)


{-| Opaque Bullseye type
-}
type Bullseye msg
    = Bullseye (Options msg)


type alias Options msg =
    { child : Element msg
    , padding : Int
    , minHeight : Maybe Int
    }


defaultOptions : Element msg -> Options msg
defaultOptions child =
    { child = child
    , padding = 0
    , minHeight = Nothing
    }


{-| Construct a Bullseye layout wrapping a single child element
-}
bullseye : Element msg -> Bullseye msg
bullseye child =
    Bullseye (defaultOptions child)


{-| Set padding around the centered content
-}
withPadding : Int -> Bullseye msg -> Bullseye msg
withPadding p (Bullseye opts) =
    Bullseye { opts | padding = p }


{-| Set minimum height for the container
-}
withMinHeight : Int -> Bullseye msg -> Bullseye msg
withMinHeight h (Bullseye opts) =
    Bullseye { opts | minHeight = Just h }


{-| Render the Bullseye as an Element msg
-}
toMarkup : Theme -> Bullseye msg -> Element msg
toMarkup _ (Bullseye opts) =
    let
        heightAttr =
            case opts.minHeight of
                Just h ->
                    Element.height (Element.minimum h Element.fill)

                Nothing ->
                    Element.height Element.fill
    in
    Element.el
        [ Element.centerX
        , Element.centerY
        , Element.width Element.fill
        , heightAttr
        , Element.padding opts.padding
        ]
        (Element.el [ Element.centerX, Element.centerY ] opts.child)
