module PF6.Timestamp exposing
    ( Timestamp
    , timestamp
    , withTooltip, withIcon, withCustomIcon
    , toMarkup
    )

{-| PF6 Timestamp component

A formatted date/time display with optional icon and tooltip.

See: <https://www.patternfly.org/components/timestamp>


# Definition

@docs Timestamp


# Constructor

@docs timestamp


# Modifiers

@docs withTooltip, withIcon, withCustomIcon


# Rendering

@docs toMarkup

-}

import Element exposing (Element)
import Element.Font as Font
import Html.Attributes
import PF6.Tokens as Tokens


{-| Opaque Timestamp type
-}
type Timestamp msg
    = Timestamp (Options msg)


type alias Options msg =
    { text : String
    , tooltip : Maybe String
    , showIcon : Bool
    , customIcon : Maybe (Element msg)
    }


{-| Construct a Timestamp with display text

    timestamp "Jan 1, 2024, 12:00 PM"

-}
timestamp : String -> Timestamp msg
timestamp text =
    Timestamp
        { text = text
        , tooltip = Nothing
        , showIcon = False
        , customIcon = Nothing
        }


{-| Add a tooltip shown on hover
-}
withTooltip : String -> Timestamp msg -> Timestamp msg
withTooltip tip (Timestamp opts) =
    Timestamp { opts | tooltip = Just tip }


{-| Show a default clock icon before the timestamp
-}
withIcon : Timestamp msg -> Timestamp msg
withIcon (Timestamp opts) =
    Timestamp { opts | showIcon = True }


{-| Show a custom icon before the timestamp
-}
withCustomIcon : Element msg -> Timestamp msg -> Timestamp msg
withCustomIcon icon (Timestamp opts) =
    Timestamp { opts | customIcon = Just icon }


{-| Render the Timestamp as an `Element msg`
-}
toMarkup : Timestamp msg -> Element msg
toMarkup (Timestamp opts) =
    let
        iconEl =
            case opts.customIcon of
                Just icon ->
                    Element.el
                        [ Font.size Tokens.fontSizeSm
                        , Font.color Tokens.colorTextSubtle
                        ]
                        icon

                Nothing ->
                    if opts.showIcon then
                        Element.el
                            [ Font.size Tokens.fontSizeSm
                            , Font.color Tokens.colorTextSubtle
                            ]
                            (Element.text "\u{1F552}")

                    else
                        Element.none

        textEl =
            Element.el
                [ Font.size Tokens.fontSizeSm
                , Font.color Tokens.colorTextSubtle
                ]
                (Element.text opts.text)

        tooltipAttr =
            opts.tooltip
                |> Maybe.map (\tip -> [ Element.htmlAttribute (Html.Attributes.title tip) ])
                |> Maybe.withDefault []
    in
    Element.row
        ([ Element.spacing Tokens.spacerXs ] ++ tooltipAttr)
        [ iconEl, textEl ]
