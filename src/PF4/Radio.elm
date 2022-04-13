module PF4.Radio exposing
    ( Radio
    , radio
    , OptionStatePalette, withOptionStatePalette, asRow, asColumn
    , toMarkup
    )

{-| A component for presenting mutually exclusive choices


# Definition

@docs Radio


# Constructo function

@docs radio


# Configuration functions

@docs OptionStatePalette, withOptionStatePalette, asRow, asColumn


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


type alias Options option msg =
    { selected : Maybe option
    , options : List (ItemOption option)
    , position : Position
    , flow : Flow
    , label : String
    , optionStatePalette : OptionStatePalette
    , onChange : option -> msg
    }


type alias ItemOption option =
    { value : option, text : String }


{-| A palette rendering the color of the radio button given the possible
[OptionState](https://package.elm-lang.org/packages/mdgriffith/elm-ui/latest/Element-Input#OptionState)
definited in `elm-ui`.
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
        , label = args.label
        , position = Default
        , flow = Column
        , optionStatePalette = defaultOptionStatePalette
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


{-| Configure to render options in a row, left-to-right
-}
asRow : Radio option msg -> Radio option msg
asRow (Radio options) =
    Radio { options | flow = Row }


{-| Configure to render otpions in a column, **_stacked_**
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
        [ Element.spacing 10 ]
        children


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

        inputLabel =
            Input.labelAbove [ Element.alignLeft ] <|
                Element.text args.label
    in
    radioF_
        [ Element.padding 10
        , Element.spacing 20
        ]
        { onChange = args.onChange
        , selected = args.selected
        , label = inputLabel
        , options = radioOptions
        }
