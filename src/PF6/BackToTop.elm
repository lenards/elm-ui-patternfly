module PF6.BackToTop exposing
    ( BackToTop
    , backToTop
    , withAlwaysVisible, withBottomOffset
    , toMarkup
    )

{-| PF6 BackToTop component

A floating button that scrolls the user back to the top of the page.
Positioned at the bottom-right corner of the viewport.

See: <https://www.patternfly.org/components/back-to-top>


# Definition

@docs BackToTop


# Constructor

@docs backToTop


# Modifiers

@docs withAlwaysVisible, withBottomOffset


# Rendering

@docs toMarkup

-}

import Element exposing (Element)
import Element.Background as Bg
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import Html.Attributes
import PF6.Tokens as Tokens


{-| Opaque BackToTop type
-}
type BackToTop msg
    = BackToTop (Options msg)


type alias Options msg =
    { onClick : msg
    , alwaysVisible : Bool
    , bottomOffset : Int
    }


{-| Construct a BackToTop button

    backToTop ScrollToTop

-}
backToTop : msg -> BackToTop msg
backToTop onClick =
    BackToTop
        { onClick = onClick
        , alwaysVisible = False
        , bottomOffset = 24
        }


{-| Always show the back-to-top button (default is hidden until scrolled)
-}
withAlwaysVisible : BackToTop msg -> BackToTop msg
withAlwaysVisible (BackToTop opts) =
    BackToTop { opts | alwaysVisible = True }


{-| Set the bottom offset in pixels from the viewport edge
-}
withBottomOffset : Int -> BackToTop msg -> BackToTop msg
withBottomOffset offset (BackToTop opts) =
    BackToTop { opts | bottomOffset = offset }


{-| Render the BackToTop as an `Element msg`
-}
toMarkup : BackToTop msg -> Element msg
toMarkup (BackToTop opts) =
    Input.button
        [ Bg.color Tokens.colorPrimary
        , Font.color Tokens.colorTextOnDark
        , Font.size Tokens.fontSizeMd
        , Element.padding Tokens.spacerSm
        , Border.rounded Tokens.radiusPill
        , Border.width 0
        , Element.htmlAttribute (Html.Attributes.style "position" "fixed")
        , Element.htmlAttribute (Html.Attributes.style "bottom" (String.fromInt opts.bottomOffset ++ "px"))
        , Element.htmlAttribute (Html.Attributes.style "right" "24px")
        , Element.htmlAttribute (Html.Attributes.style "z-index" "9999")
        , Element.htmlAttribute (Html.Attributes.style "cursor" "pointer")
        , Element.htmlAttribute
            (Html.Attributes.style "box-shadow"
                "0 0.25rem 0.5rem 0rem rgba(3,3,3,0.12), 0 0 0.25rem 0 rgba(3,3,3,0.06)"
            )
        ]
        { onPress = Just opts.onClick
        , label =
            Element.row [ Element.spacing Tokens.spacerXs ]
                [ Element.el [ Font.size Tokens.fontSizeLg ] (Element.text "\u{2191}")
                , Element.text "Back to top"
                ]
        }
