module PF4.Switch exposing
    ( Switch
    , switch
    , withReversed, withText
    , isChecked, markChecked, markUnchecked, toggleCheck
    , toMarkup
    )

{-| A component for toggling or _switching_ values **on** or **off**


# Definition

@docs Switch


# Constructor function

@docs switch


# Configuration functions

@docs withReversed, withText


# State change functions

@docs isChecked, markChecked, markUnchecked, toggleCheck


# Rendering element

@docs toMarkup

-}

import Element exposing (Element)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input


{-| Opaque `Switch` element that can produce `msg` messages
-}
type Switch msg
    = Switch (TextOptions msg)


type alias TextOptions msg =
    { checked : Bool
    , onText : String
    , offText : String
    , position : Position
    , onChange : Bool -> msg
    }


{-| Opaque `IconSwitch` element that can produce `msg` messages
-}
type IconSwitch msg
    = IconSwitch (IconOptions msg)


type alias IconOptions msg =
    { checked : Bool
    , ariaLabel : String
    , icon : Element msg
    , onChange : Bool -> msg
    }


type Position
    = Default
    | Reversed


{-| Constructs a `Switch` from the arguments

  - `onText` is the text that will be displayed when the switch is "on", or `checked` is true
  - `offText` is the text that will be displayed when the switch is "off", or `checked` is false

-}
switch :
    { checked : Bool
    , onText : String
    , offText : String
    , onChange : Bool -> msg
    }
    -> Switch msg
switch args =
    Switch
        { checked = args.checked
        , onText = args.onText
        , offText = args.offText
        , position = Default
        , onChange = args.onChange
        }


iconSwitch :
    { checked : Bool
    , ariaLabel : String
    , icon : Element msg
    , onChange : Bool -> msg
    }
    -> IconSwitch msg
iconSwitch args =
    IconSwitch
        { checked = args.checked
        , ariaLabel = args.ariaLabel
        , icon = args.icon
        , onChange = args.onChange
        }


{-| Configures the position of the text to be on the left of the switch

The default position of the text is to the right of the switch.

-}
withReversed : Switch msg -> Switch msg
withReversed (Switch options) =
    Switch
        { options | position = Reversed }


{-| Configures the text display when the switch is "on" or "off"
-}
withText : { onText : String, offText : String } -> Switch msg -> Switch msg
withText { onText, offText } (Switch options) =
    Switch
        { options
            | onText = onText
            , offText = offText
        }


{-| Set the `checked` value to true
-}
markChecked : Switch msg -> Switch msg
markChecked (Switch options) =
    Switch
        { options | checked = True }


{-| Set the `checked` value to false
-}
markUnchecked : Switch msg -> Switch msg
markUnchecked (Switch options) =
    Switch
        { options | checked = False }


{-| Given the internal `checked` state, set it to the opposite
-}
toggleCheck : Switch msg -> Switch msg
toggleCheck (Switch options) =
    Switch
        { options | checked = not options.checked }


{-| Return true is the element is `checked`, otherwise false
-}
isChecked : Switch msg -> Bool
isChecked (Switch options) =
    options.checked


hiddenLabel : Bool -> Input.Label msg
hiddenLabel checked =
    if checked then
        Input.labelHidden "On"

    else
        Input.labelHidden "Off"


circleMarkup : Element msg
circleMarkup =
    Element.el
        [ Element.width <| Element.px 16
        , Element.height <| Element.px 16
        , Border.rounded 8
        , Background.color <|
            Element.rgb255 255 255 255
        ]
        Element.none


switchMarkup : Bool -> Element msg
switchMarkup isChecked_ =
    let
        currentColor =
            if isChecked_ then
                Element.rgb255 0 102 204

            else
                Element.rgb255 106 110 115

        attrs_ =
            [ Element.width <| Element.px 40
            , Element.height <| Element.px 24
            , Element.centerY
            , Border.rounded 12
            , Background.color currentColor
            ]

        content =
            Element.el (childAttrs_ ++ circlePosition) <|
                circleMarkup

        childAttrs_ =
            [ Element.centerY
            , Element.height Element.fill
            ]

        circlePosition =
            if isChecked_ then
                [ Element.alignRight
                , Element.paddingEach
                    { top = 4
                    , right = 4
                    , bottom = 0
                    , left = 0
                    }
                ]

            else
                [ Element.alignLeft
                , Element.paddingEach
                    { top = 4
                    , right = 0
                    , bottom = 0
                    , left = 4
                    }
                ]
    in
    Element.el attrs_ <|
        Element.row
            [ Element.width Element.fill
            , Element.height Element.fill
            ]
            [ content ]


{-| Given the custom type representation, renders as an `Element msg`.
-}
toMarkup : Switch msg -> Element msg
toMarkup (Switch options) =
    let
        switchEl =
            Input.checkbox
                [ Element.width Element.shrink
                , Font.size 20
                ]
                { onChange = options.onChange
                , icon = switchMarkup
                , checked = options.checked
                , label = hiddenLabel options.checked
                }

        textEl =
            Element.el [] <|
                Element.text <|
                    if options.checked then
                        options.onText

                    else
                        options.offText

        contentEl =
            case options.position of
                Default ->
                    [ switchEl, textEl ]

                Reversed ->
                    [ textEl, switchEl ]

        rowAttrs_ =
            [ Element.spacingXY 6 0 ]
    in
    Element.el [] <|
        Element.row rowAttrs_ contentEl
