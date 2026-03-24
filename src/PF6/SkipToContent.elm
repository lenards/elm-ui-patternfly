module PF6.SkipToContent exposing
    ( SkipToContent
    , skipToContent
    , toMarkup
    )

{-| PF6 SkipToContent component

An accessibility skip-navigation link that is visually hidden until focused.
Place at the very top of the page layout so keyboard users can jump past navigation.

See: <https://www.patternfly.org/components/skip-to-content>


# Definition

@docs SkipToContent


# Constructor

@docs skipToContent


# Rendering

@docs toMarkup

-}

import Element exposing (Element)
import Html
import Html.Attributes
import PF6.Tokens as Tokens


{-| Opaque SkipToContent type
-}
type SkipToContent
    = SkipToContent Options


type alias Options =
    { href : String
    , label : String
    }


{-| Construct a SkipToContent link

    skipToContent { href = "#main-content", label = "Skip to main content" }

-}
skipToContent : { href : String, label : String } -> SkipToContent
skipToContent config =
    SkipToContent
        { href = config.href
        , label = config.label
        }


{-| Render the SkipToContent as an `Element msg`

The link is visually hidden (positioned off-screen) by default.
When the user focuses it via keyboard navigation, it becomes visible
at the top of the viewport.

-}
toMarkup : SkipToContent -> Element msg
toMarkup (SkipToContent opts) =
    Element.html
        (Html.a
            [ Html.Attributes.href opts.href
            , Html.Attributes.style "position" "absolute"
            , Html.Attributes.style "left" "-9999px"
            , Html.Attributes.style "top" "auto"
            , Html.Attributes.style "width" "1px"
            , Html.Attributes.style "height" "1px"
            , Html.Attributes.style "overflow" "hidden"
            , Html.Attributes.style "z-index" "9999"
            , Html.Attributes.style "padding" (String.fromInt Tokens.spacerSm ++ "px " ++ String.fromInt Tokens.spacerMd ++ "px")
            , Html.Attributes.style "background-color" "#0066cc"
            , Html.Attributes.style "color" "#ffffff"
            , Html.Attributes.style "font-size" (String.fromInt Tokens.fontSizeMd ++ "px")
            , Html.Attributes.style "text-decoration" "none"
            , Html.Attributes.style "border-radius" (String.fromInt Tokens.radiusMd ++ "px")
            , Html.Attributes.class "pf6-skip-to-content"
            ]
            [ Html.text opts.label ]
        )
