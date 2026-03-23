module PF6.Popover exposing
    ( Popover, Position
    , popover
    , withTitle, withBody, withFooter
    , withTop, withBottom, withLeft, withRight
    , withMaxWidth, withOnClose
    , toMarkup
    )

{-| PF6 Popover component

Popovers display rich content (title, body, optional footer) in an
overlay triggered by clicking an element. Unlike a tooltip, popovers
stay open until explicitly dismissed.

See: <https://www.patternfly.org/components/popover>


# Definition

@docs Popover, Position


# Constructor

@docs popover


# Content modifiers

@docs withTitle, withBody, withFooter


# Position modifiers

@docs withTop, withBottom, withLeft, withRight


# Display modifiers

@docs withMaxWidth, withOnClose


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


{-| Opaque Popover type
-}
type Popover msg
    = Popover (Options msg)


{-| Popover position relative to its trigger
-}
type Position
    = Top
    | Bottom
    | Left
    | Right


type alias Options msg =
    { trigger : Element msg
    , isOpen : Bool
    , onToggle : Bool -> msg
    , title : Maybe String
    , body : Maybe (Element msg)
    , footer : Maybe (Element msg)
    , position : Position
    , maxWidth : Int
    , onClose : Maybe msg
    }


{-| Construct a Popover

    popover
        { trigger = Button.secondary { label = "More info", onPress = Nothing } |> Button.toMarkup
        , isOpen = model.popoverOpen
        , onToggle = PopoverToggled
        }

-}
popover :
    { trigger : Element msg
    , isOpen : Bool
    , onToggle : Bool -> msg
    }
    -> Popover msg
popover config =
    Popover
        { trigger = config.trigger
        , isOpen = config.isOpen
        , onToggle = config.onToggle
        , title = Nothing
        , body = Nothing
        , footer = Nothing
        , position = Top
        , maxWidth = 300
        , onClose = Nothing
        }


{-| Set the popover title
-}
withTitle : String -> Popover msg -> Popover msg
withTitle t (Popover opts) =
    Popover { opts | title = Just t }


{-| Set the popover body content
-}
withBody : Element msg -> Popover msg -> Popover msg
withBody el (Popover opts) =
    Popover { opts | body = Just el }


{-| Set the popover footer content
-}
withFooter : Element msg -> Popover msg -> Popover msg
withFooter el (Popover opts) =
    Popover { opts | footer = Just el }


{-| Position the popover above the trigger (default)
-}
withTop : Popover msg -> Popover msg
withTop (Popover opts) =
    Popover { opts | position = Top }


{-| Position the popover below the trigger
-}
withBottom : Popover msg -> Popover msg
withBottom (Popover opts) =
    Popover { opts | position = Bottom }


{-| Position the popover to the left
-}
withLeft : Popover msg -> Popover msg
withLeft (Popover opts) =
    Popover { opts | position = Left }


{-| Position the popover to the right
-}
withRight : Popover msg -> Popover msg
withRight (Popover opts) =
    Popover { opts | position = Right }


{-| Set maximum width in pixels (default 300)
-}
withMaxWidth : Int -> Popover msg -> Popover msg
withMaxWidth px (Popover opts) =
    Popover { opts | maxWidth = px }


{-| Set a message sent when the close (×) button is clicked
-}
withOnClose : msg -> Popover msg -> Popover msg
withOnClose msg (Popover opts) =
    Popover { opts | onClose = Just msg }


popoverPanel : Options msg -> Element msg
popoverPanel opts =
    Element.column
        [ Element.width (Element.maximum opts.maxWidth Element.fill)
        , Bg.color Tokens.colorBackgroundDefault
        , Border.rounded Tokens.radiusMd
        , Border.shadow
            { offset = ( 0, 4 )
            , size = 0
            , blur = 16
            , color = Element.rgba 0 0 0 0.15
            }
        , Border.solid
        , Border.width 1
        , Border.color Tokens.colorBorderDefault
        , Element.htmlAttribute (Html.Attributes.style "z-index" "9999")
        ]
        [ -- Header
          case opts.title of
            Just t ->
                Element.row
                    [ Element.width Element.fill
                    , Element.paddingXY Tokens.spacerMd Tokens.spacerSm
                    , Bg.color Tokens.colorBackgroundSecondary
                    , Border.widthEach { top = 0, right = 0, bottom = 1, left = 0 }
                    , Border.color Tokens.colorBorderDefault
                    ]
                    [ Element.el [ Font.bold, Font.size Tokens.fontSizeMd, Font.color Tokens.colorText, Element.width Element.fill ]
                        (Element.text t)
                    , case opts.onClose of
                        Just closeMsg ->
                            Input.button
                                [ Font.color Tokens.colorTextSubtle
                                , Element.padding Tokens.spacerXs
                                ]
                                { onPress = Just closeMsg
                                , label = Element.text "×"
                                }

                        Nothing ->
                            Element.none
                    ]

            Nothing ->
                Element.none

        -- Body
        , case opts.body of
            Just bodyEl ->
                Element.el
                    [ Element.width Element.fill
                    , Element.padding Tokens.spacerMd
                    , Font.size Tokens.fontSizeMd
                    , Font.color Tokens.colorText
                    ]
                    bodyEl

            Nothing ->
                Element.none

        -- Footer
        , case opts.footer of
            Just footerEl ->
                Element.el
                    [ Element.width Element.fill
                    , Element.paddingXY Tokens.spacerMd Tokens.spacerSm
                    , Bg.color Tokens.colorBackgroundSecondary
                    , Border.widthEach { top = 1, right = 0, bottom = 0, left = 0 }
                    , Border.color Tokens.colorBorderDefault
                    ]
                    footerEl

            Nothing ->
                Element.none
        ]


positionAttr : Position -> Bool -> Element.Attribute msg
positionAttr position isOpen =
    if not isOpen then
        Element.htmlAttribute (Html.Attributes.style "display" "none")

    else
        case position of
            Top ->
                Element.above Element.none
                    |> always (Element.above Element.none)

            Bottom ->
                Element.below Element.none
                    |> always (Element.below Element.none)

            Left ->
                Element.onLeft Element.none
                    |> always (Element.onLeft Element.none)

            Right ->
                Element.onRight Element.none
                    |> always (Element.onRight Element.none)


{-| Render the Popover as an `Element msg`

The popover uses elm-ui's `Element.above`/`Element.below`/`Element.onLeft`/`Element.onRight`
attributes on the trigger to position the panel. The trigger element is
always rendered; the panel is only shown when `isOpen = True`.

-}
toMarkup : Popover msg -> Element msg
toMarkup (Popover opts) =
    let
        panel =
            if opts.isOpen then
                popoverPanel opts

            else
                Element.none

        posAttr =
            case opts.position of
                Top ->
                    Element.above panel

                Bottom ->
                    Element.below panel

                Left ->
                    Element.onLeft panel

                Right ->
                    Element.onRight panel
    in
    Input.button
        [ posAttr ]
        { onPress = Just (opts.onToggle (not opts.isOpen))
        , label = opts.trigger
        }
