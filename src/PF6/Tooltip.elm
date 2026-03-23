module PF6.Tooltip exposing
    ( Tooltip, Position
    , tooltip
    , withTop, withBottom, withLeft, withRight
    , withMaxWidth
    , toMarkup
    )

{-| PF6 Tooltip component

Tooltips display a short description when a user hovers over or focuses an element.

See: <https://www.patternfly.org/components/tooltip>


# Definition

@docs Tooltip, Position


# Constructor

@docs tooltip


# Position modifiers

@docs withTop, withBottom, withLeft, withRight


# Display modifiers

@docs withMaxWidth


# Rendering

@docs toMarkup

-}

import Element exposing (Element)
import Element.Background as Bg
import Element.Border as Border
import Element.Font as Font
import Html.Attributes
import PF6.Tokens as Tokens


{-| Opaque Tooltip type
-}
type Tooltip msg
    = Tooltip (Options msg)


{-| Tooltip position relative to the trigger element
-}
type Position
    = Top
    | Bottom
    | Left
    | Right


type alias Options msg =
    { trigger : Element msg
    , content : String
    , position : Position
    , maxWidth : Int
    }


{-| Construct a Tooltip

    tooltip
        { trigger = myButton
        , content = "This action cannot be undone"
        }

-}
tooltip : { trigger : Element msg, content : String } -> Tooltip msg
tooltip config =
    Tooltip
        { trigger = config.trigger
        , content = config.content
        , position = Top
        , maxWidth = 300
        }


{-| Position tooltip above the trigger (default)
-}
withTop : Tooltip msg -> Tooltip msg
withTop (Tooltip opts) =
    Tooltip { opts | position = Top }


{-| Position tooltip below the trigger
-}
withBottom : Tooltip msg -> Tooltip msg
withBottom (Tooltip opts) =
    Tooltip { opts | position = Bottom }


{-| Position tooltip to the left of the trigger
-}
withLeft : Tooltip msg -> Tooltip msg
withLeft (Tooltip opts) =
    Tooltip { opts | position = Left }


{-| Position tooltip to the right of the trigger
-}
withRight : Tooltip msg -> Tooltip msg
withRight (Tooltip opts) =
    Tooltip { opts | position = Right }


{-| Set max width in pixels (default 300)
-}
withMaxWidth : Int -> Tooltip msg -> Tooltip msg
withMaxWidth px (Tooltip opts) =
    Tooltip { opts | maxWidth = px }


tooltipBubble : Options msg -> Element msg
tooltipBubble opts =
    Element.el
        [ Bg.color (Element.rgb255 21 21 21)
        , Font.color Tokens.colorTextOnDark
        , Font.size Tokens.fontSizeSm
        , Border.rounded Tokens.radiusMd
        , Element.paddingXY Tokens.spacerSm Tokens.spacerXs
        , Element.width (Element.maximum opts.maxWidth Element.shrink)
        , Element.htmlAttribute (Html.Attributes.style "pointer-events" "none")
        , Element.htmlAttribute (Html.Attributes.style "white-space" "normal")
        ]
        (Element.paragraph [] [ Element.text opts.content ])


{-| Render the Tooltip as an `Element msg`

The tooltip bubble is shown via elm-ui's `above`, `below`, `onLeft`, or `onRight`
attributes, so it appears on hover when composed with `Element.mouseOver` or
always visible when embedded directly.

For real hover behavior, use the `above`/`below` variant directly on your element:

    Element.el
        [ Element.above (tooltipView "My tooltip") ]
        myTrigger

-}
toMarkup : Tooltip msg -> Element msg
toMarkup (Tooltip opts) =
    let
        bubble =
            tooltipBubble opts

        positionAttr =
            case opts.position of
                Top ->
                    Element.above bubble

                Bottom ->
                    Element.below bubble

                Left ->
                    Element.onLeft bubble

                Right ->
                    Element.onRight bubble
    in
    Element.el
        [ positionAttr ]
        opts.trigger
