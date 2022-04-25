module PF4.Checkbox exposing
    ( Checkbox
    , checkbox
    , Palette, withPalette, withLabelAttributes
    , toMarkup
    )

{-| A component for presenting an option to select (either single item or multiple items);
typically this is a choose to do an action or reflects an "on/off" or binary setting.


# Definition

@docs Checkbox


# Constructor function

@docs checkbox


# Configuration functions

@docs Palette, withPalette, withLabelAttributes


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


type LabelAttributes msg
    = LabelAttrs (List (Element.Attribute msg))


type CheckboxType msg
    = Default LabelText (LabelAttributes msg)
    | Standalone


type alias Options msg =
    { checked : Bool
    , onCheck : Bool -> msg
    , palette : Palette
    , type_ : CheckboxType msg
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
        , type_ =
            Default
                (LabelText args.label)
                (LabelAttrs [])
        }


{-| Render with a custom palette
-}
withPalette : Palette -> Checkbox msg -> Checkbox msg
withPalette newPalette (Checkbox options) =
    Checkbox { options | palette = newPalette }


{-| Provide a list of attributes to include on the label element.

In `Standalone` mode, the attributes won't have any impact because there is no label.

Yes, that sure seems like an impossible state! I haven't quite grokked how I might
disallow this. I realize that the Phantom Builder would be one way; but I'm not
totally comfortable about that.

Perhaps it makes more sense for "Standalone" to be a wholly different type.

-}
withLabelAttributes : List (Element.Attribute msg) -> Checkbox msg -> Checkbox msg
withLabelAttributes attrs (Checkbox options) =
    case options.type_ of
        Default labelText _ ->
            Checkbox
                { options
                    | type_ =
                        Default labelText (LabelAttrs attrs)
                }

        Standalone ->
            -- no label in standalone, ignore
            Checkbox options


white : Element.Color
white =
    Element.rgb 1 1 1


checkmark : Bool -> Element msg
checkmark checked =
    -- based off of rendering `defaultCheckbox` in elm-ui's
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
    -- based off of rendering `defaultCheckbox` in elm-ui's
    let
        borderColor =
            if checked then
                palette.checked

            else
                palette.focused

        borderWidth =
            if checked then
                0

            else
                1

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
        , Background.color backgroundColor
        , Border.width borderWidth
        , Element.inFront (checkmark checked)
        ]
        Element.none


inputLabelEl : Options msg -> Input.Label msg
inputLabelEl options =
    case options.type_ of
        Default (LabelText labelText) (LabelAttrs attrs) ->
            Input.labelRight attrs <| Element.text labelText

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
