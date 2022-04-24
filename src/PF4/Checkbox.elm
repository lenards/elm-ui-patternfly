module PF4.Checkbox exposing
    ( Checkbox
    , checkbox
    , Palette, withPalette
    , toMarkup
    )

{-| A component for presenting an option to select (either single item or multiple items);
typically this is a choose to do an action or reflects an "on/off" or binary setting.


# Definition

@docs Checkbox


# Constructor function

@docs checkbox


# Configuration functions

@docs Palette, withPalette


# Rendering element

@docs toMarkup

-}

import Element exposing (Element)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import Html.Attributes exposing (class)


{-| Opaque `Checkbox` element that can produce `msg` messages for indicating a selection
-}
type Checkbox msg
    = Checkbox (Options msg)


type LabelText
    = LabelText String


type CheckboxType
    = Default LabelText
    | Standalone


type alias Options msg =
    { checked : Bool
    , onCheck : Bool -> msg
    , palette : Palette
    , type_ : CheckboxType
    }


{-| A palette rendering the color of the checkbox
-}
type alias Palette =
    { idle : Element.Color
    , focused : Element.Color
    , checked : Element.Color
    }


defaultPalette : Palette
defaultPalette =
    { idle = Element.rgb255 0xFF 0xFF 0xFF
    , focused = Element.rgb255 0xE0 0xE0 0xE0
    , checked = Element.rgb255 0x00 0x66 0xCC
    }


{-| Constructs a `Checkbox` from the arguments
-}
checkbox :
    { checked : Bool
    , onCheck : Bool -> msg
    , label : String
    }
    -> Checkbox msg
checkbox args =
    Checkbox
        { checked = args.checked
        , onCheck = args.onCheck
        , palette = defaultPalette
        , type_ = Default <| LabelText args.label
        }


{-| Render with a custom palette
-}
withPalette : Palette -> Checkbox msg -> Checkbox msg
withPalette newPalette (Checkbox options) =
    Checkbox { options | palette = newPalette }


white : Element.Color
white =
    Element.rgb 1 1 1


checkmark : Bool -> Element msg
checkmark checked =
    -- based off of render check in elm-ui's `defaultCheckbox`
    Element.el
        [ Border.color white
        , Element.height (Element.px 6)
        , Element.width (Element.px 9)
        , Element.rotate (degrees -45)
        , Element.centerX
        , Element.centerY
        , Element.moveUp 1
        , Element.transparent (not checked)
        , Border.widthEach
            { top = 0
            , left = 2
            , bottom = 2
            , right = 0
            }
        ]
        Element.none


defaultIcon : Palette -> Bool -> Element msg
defaultIcon palette checked =
    let
        borderColor =
            if checked then
                palette.checked

            else
                Element.rgb (211 / 255) (211 / 255) (211 / 255)

        borderWidth =
            if checked then
                0

            else
                1

        shadowColor =
            if checked then
                Element.rgba (238 / 255) (238 / 255) (238 / 255) 0

            else
                Element.rgb (238 / 255) (238 / 255) (238 / 255)

        backgroundColor =
            if checked then
                palette.checked

            else
                palette.idle
    in
    Element.el
        [ Element.htmlAttribute (class "focusable")
        , Element.width (Element.px 14)
        , Element.height (Element.px 14)
        , Font.color white
        , Element.centerY
        , Font.size 9
        , Font.center
        , Border.rounded 3
        , Border.color borderColor
        , Border.shadow
            { offset = ( 0, 0 )
            , blur = 1
            , size = 1
            , color = shadowColor
            }
        , Background.color backgroundColor
        , Border.width borderWidth
        , Element.inFront (checkmark checked)
        ]
        Element.none


inputLabelEl : Options msg -> Input.Label msg
inputLabelEl options =
    case options.type_ of
        Default (LabelText labelText) ->
            Input.labelRight [] <| Element.text labelText

        Standalone ->
            Input.labelRight [] Element.none


{-| Given the custom type representation, renders as an `Element msg`.
-}
toMarkup : Checkbox msg -> Element msg
toMarkup (Checkbox options) =
    Input.checkbox [ Font.size 20 ]
        { onChange = options.onCheck
        , icon = defaultIcon options.palette
        , checked = options.checked
        , label = inputLabelEl options
        }
