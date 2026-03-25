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
import Html
import Html.Attributes
import PF6.Theme as Theme exposing (Theme)
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


tooltipBubble : Theme -> Options msg -> Element msg
tooltipBubble theme opts =
    let
        spacing =
            case opts.position of
                Top ->
                    Element.moveUp 8

                Bottom ->
                    Element.moveDown 8

                Left ->
                    Element.moveLeft 8

                Right ->
                    Element.moveRight 8
    in
    Element.el
        [ Bg.color (Element.rgb255 21 21 21)
        , Font.color (Theme.textOnDark theme)
        , Font.size Tokens.fontSizeSm
        , Border.rounded Tokens.radiusMd
        , Element.paddingXY Tokens.spacerSm Tokens.spacerXs
        , Element.width (Element.maximum opts.maxWidth Element.shrink)
        , Element.htmlAttribute (Html.Attributes.class "pf-tooltip-bubble")
        , Element.htmlAttribute (Html.Attributes.style "pointer-events" "none")
        , Element.htmlAttribute (Html.Attributes.style "white-space" "normal")
        , Element.htmlAttribute (Html.Attributes.style "opacity" "0")
        , Element.htmlAttribute (Html.Attributes.style "transition" "opacity 0.15s ease-in-out")
        , spacing
        ]
        (Element.paragraph [] [ Element.text opts.content ])


{-| CSS that shows the tooltip bubble on hover.

elm-ui's `mouseOver` only supports Decoration values (colors, shadows),
not visibility or opacity. We inject a small CSS rule that uses the
`:hover` pseudo-class to show the bubble when the trigger is hovered.

-}
hoverCss : Element msg
hoverCss =
    Element.html
        (Html.node "style"
            []
            [ Html.text ".pf-tooltip-wrap:hover .pf-tooltip-bubble { opacity: 1 !important; }" ]
        )


{-| Render the Tooltip as an `Element msg`

The tooltip bubble is hidden by default (opacity: 0) and shown on hover
via an injected CSS rule. The bubble is positioned using elm-ui's
`above`/`below`/`onLeft`/`onRight` attributes with an 8px gap.

-}
toMarkup : Theme -> Tooltip msg -> Element msg
toMarkup theme (Tooltip opts) =
    let
        bubble =
            tooltipBubble theme opts

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
        [ positionAttr
        , Element.htmlAttribute (Html.Attributes.class "pf-tooltip-wrap")
        , Element.inFront hoverCss
        ]
        opts.trigger
