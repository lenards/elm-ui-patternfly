module PF6.Backdrop exposing
    ( Backdrop
    , backdrop
    , withOpacity, withZIndex
    , toMarkup
    )

{-| PF6 Backdrop component

A semi-transparent overlay background used behind modals and other overlays.

See: <https://www.patternfly.org/components/backdrop>


# Definition

@docs Backdrop


# Constructor

@docs backdrop


# Modifiers

@docs withOpacity, withZIndex


# Rendering

@docs toMarkup

-}

import Element exposing (Element)
import Element.Background as Bg
import Element.Events
import Html.Attributes
import PF6.Theme exposing (Theme)


{-| Opaque Backdrop type
-}
type Backdrop msg
    = Backdrop (Options msg)


type alias Options msg =
    { onClick : msg
    , opacity : Float
    , zIndex : Int
    }


{-| Construct a Backdrop

    backdrop BackdropClicked

The msg fires when the backdrop is clicked.

-}
backdrop : msg -> Backdrop msg
backdrop onClick =
    Backdrop
        { onClick = onClick
        , opacity = 0.5
        , zIndex = 1000
        }


{-| Set the backdrop opacity (0.0 to 1.0, default 0.5)
-}
withOpacity : Float -> Backdrop msg -> Backdrop msg
withOpacity o (Backdrop opts) =
    Backdrop { opts | opacity = o }


{-| Set the z-index (default 1000)
-}
withZIndex : Int -> Backdrop msg -> Backdrop msg
withZIndex z (Backdrop opts) =
    Backdrop { opts | zIndex = z }


{-| Render the Backdrop as an `Element msg`

The backdrop covers the entire viewport using fixed positioning.
Consumers control visibility by conditionally rendering the backdrop.

-}
toMarkup : Theme -> Backdrop msg -> Element msg
toMarkup _ (Backdrop opts) =
    Element.el
        [ Element.width Element.fill
        , Element.height Element.fill
        , Bg.color (Element.rgba 0 0 0 opts.opacity)
        , Element.htmlAttribute (Html.Attributes.style "position" "fixed")
        , Element.htmlAttribute (Html.Attributes.style "top" "0")
        , Element.htmlAttribute (Html.Attributes.style "left" "0")
        , Element.htmlAttribute (Html.Attributes.style "right" "0")
        , Element.htmlAttribute (Html.Attributes.style "bottom" "0")
        , Element.htmlAttribute (Html.Attributes.style "z-index" (String.fromInt opts.zIndex))
        , Element.htmlAttribute (Html.Attributes.style "cursor" "pointer")
        , Element.Events.onClick opts.onClick
        ]
        Element.none
