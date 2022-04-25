module PF4.Radio exposing
    ( Radio
    , radio
    , OptionStatePalette, withOptionStatePalette, asRow, asColumn
    , withOptionExtraAttributes, withLabelAttributes
    , toMarkup
    )

{-| A component for presenting mutually exclusive choices


# Definition

@docs Radio


# Constructor function

@docs radio


# Configuration functions

@docs OptionStatePalette, withOptionStatePalette, asRow, asColumn


# Extra Attributes functions

@docs withOptionExtraAttributes, withLabelAttributes


# Rendering element

@docs toMarkup

-}

import Element exposing (Element)
import Element.Background as Background
import Element.Border as Border
import Element.Input as Input exposing (Option)


{-| Opaque `Radio` element that can produce `msg` messages from a mutually exclusive choices of `option`
-}
type Radio option msg
    = Radio (Options option msg)


type LabelText msg
    = LabelText String (List (Element.Attribute msg))


type alias Options option msg =
    { selected : Maybe option
    , options : List (ItemOption option)
    , position : Position
    , flow : Flow
    , label : LabelText msg
    , optionStatePalette : OptionStatePalette
    , optionExtraAttributes : List (Element.Attribute msg)
    , onChange : option -> msg
    }


type alias ItemOption option =
    { value : option, text : String }


{-| A palette rendering the color of the radio button given the possible
[OptionState](https://package.elm-lang.org/packages/mdgriffith/elm-ui/latest/Element-Input#OptionState)
defined in `elm-ui`.
-}
type alias OptionStatePalette =
    { idle : Element.Color
    , focused : Element.Color
    , selected : Element.Color
    }


type Position
    = Default
    | Reversed


type Flow
    = Column
    | Row


defaultOptionStatePalette : OptionStatePalette
defaultOptionStatePalette =
    { idle = Element.rgb255 0xFF 0xFF 0xFF
    , focused = Element.rgb255 0xE0 0xE0 0xE0
    , selected = Element.rgb255 0x00 0x66 0xCC
    }


{-| Constructs a `Radio` from the arguments

Default configuration is to:

  - position of the radio button is to the left
  - the options are rendered "stacked", as a column

Argument Info:

  - `label` is for given _context_ to all of the `option`

For example, if a user is choosing between some type of "resources", like
the Volumes attached to a virtual machine, the `label` would be rendered
above chooses related to _Volumes_.

-}
radio :
    { onChange : option -> msg
    , selected : Maybe option
    , label : String
    , options : List { value : option, text : String }
    }
    -> Radio option msg
radio args =
    Radio
        { selected = args.selected
        , label = LabelText args.label []
        , position = Default
        , flow = Column
        , optionStatePalette = defaultOptionStatePalette
        , optionExtraAttributes = []
        , options = args.options
        , onChange = args.onChange
        }


{-| Render with a custom palette
-}
withOptionStatePalette :
    { idle : Element.Color
    , focused : Element.Color
    , selected : Element.Color
    }
    -> Radio option msg
    -> Radio option msg
withOptionStatePalette customPalette (Radio options) =
    Radio { options | optionStatePalette = customPalette }


{-| Provide a list of attributes to include on **option** label elements.

This will not impact the `label` rendered above the `Radio` button options.

Use `withLabelAttributes` to impact that element.

-}
withOptionExtraAttributes :
    List (Element.Attribute msg)
    -> Radio option msg
    -> Radio option msg
withOptionExtraAttributes attrs (Radio options) =
    Radio { options | optionExtraAttributes = attrs }


{-| Provide a list of attributes to include on the label over the entire element.

If you're looking to add attributes to the Radio buttons options, use `withOptionExtraAttributes`.

-}
withLabelAttributes : List (Element.Attribute msg) -> Radio option msg -> Radio option msg
withLabelAttributes attrs (Radio options) =
    let
        (LabelText labelText _) =
            options.label
    in
    Radio { options | label = LabelText labelText attrs }


{-| Configure to render options in a row, left-to-right
-}
asRow : Radio option msg -> Radio option msg
asRow (Radio options) =
    Radio { options | flow = Row }


{-| Configure to render options in a column, **_stacked_**
-}
asColumn : Radio option msg -> Radio option msg
asColumn (Radio options) =
    Radio { options | flow = Column }


backgroundForState : Options option msg -> Input.OptionState -> Element.Attribute msg
backgroundForState args state =
    let
        color =
            case state of
                Input.Idle ->
                    args.optionStatePalette.idle

                Input.Focused ->
                    args.optionStatePalette.focused

                Input.Selected ->
                    args.optionStatePalette.selected
    in
    Background.color color


outlineForState : Options option msg -> Input.OptionState -> Element.Attribute msg
outlineForState args state =
    let
        outlineColor =
            if state == Input.Selected then
                args.optionStatePalette.selected

            else
                args.optionStatePalette.focused
    in
    Border.color outlineColor


customOption : Options option msg -> String -> Input.OptionState -> Element msg
customOption args text state =
    let
        radioOptionEl =
            Element.el
                [ Element.width <| Element.px 16
                , Element.height <| Element.px 16
                , Element.centerY
                , Element.padding 2
                , Border.rounded 16
                , Border.width 2
                , outlineForState args state
                ]
                (Element.el
                    [ Element.width Element.fill
                    , Element.height Element.fill
                    , Border.rounded 14
                    , backgroundForState args state
                    ]
                    Element.none
                )

        optionLabelEl =
            Element.text text

        children =
            case args.position of
                Default ->
                    [ radioOptionEl, optionLabelEl ]

                Reversed ->
                    [ optionLabelEl, radioOptionEl ]
    in
    Element.row
        (Element.spacing 10 :: args.optionExtraAttributes)
        children


inputLabelEl : LabelText msg -> Input.Label msg
inputLabelEl (LabelText labelText attrs) =
    Input.labelAbove
        (Element.alignLeft :: attrs)
        (Element.text labelText)


{-| Given the custom type representation, renders as an `Element msg`.
-}
toMarkup : Radio option msg -> Element msg
toMarkup (Radio args) =
    let
        radioF_ =
            case args.flow of
                Column ->
                    Input.radio

                Row ->
                    Input.radioRow

        radioOptions =
            args.options
                |> List.map
                    (\{ value, text } ->
                        Input.optionWith
                            value
                            (customOption args text)
                    )
    in
    radioF_
        [ Element.padding 10
        , Element.spacing 20
        ]
        { onChange = args.onChange
        , selected = args.selected
        , label = inputLabelEl args.label
        , options = radioOptions
        }
