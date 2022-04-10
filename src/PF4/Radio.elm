module PF4.Radio exposing (..)

import Element exposing (Element)
import Element.Background as Background
import Element.Border as Border
import Element.Input as Input exposing (Option)


type Radio option msg
    = Radio (Options option msg)


type alias Options option msg =
    { selected : Maybe option
    , options : List (ItemOption option)
    , position : Position
    , label : String
    , onChange : option -> msg
    }


type alias ItemOption option =
    { value : option, text : String }


type Position
    = Default
    | Reversed


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
        , options = args.options
        , onChange = args.onChange
        }


backgroundForState state =
    let
        color =
            case state of
                Input.Idle ->
                    Element.rgb255 0xFF 0xFF 0xFF

                Input.Focused ->
                    Element.rgb255 0xE0 0xE0 0xE0

                Input.Selected ->
                    Element.rgb255 0x72 0x9F 0xCF
    in
    Background.color color


customOption : String -> Input.OptionState -> Element msg
customOption text state =
    let
        _ =
            Debug.log ("state " ++ text ++ " -> ") state
    in
    Element.row [ Element.spacing 10 ]
        [ Element.el
            [ Element.width <| Element.px 16
            , Element.height <| Element.px 16
            , Element.centerY
            , Element.padding 2
            , Border.rounded 16
            , Border.width 2
            , Border.color <| Element.rgb255 0x72 0x9F 0xCF
            ]
            (Element.el
                [ Element.width Element.fill
                , Element.height Element.fill
                , Border.rounded 14
                , backgroundForState state
                ]
                Element.none
            )
        , Element.text text
        ]


toMarkup : Radio option msg -> Element msg
toMarkup (Radio options) =
    let
        radioOptions =
            options.options
                |> List.map
                    (\{ value, text } ->
                        Input.optionWith value (customOption text)
                    )

        inputLabel =
            Input.labelAbove [ Element.alignLeft ] <| Element.text options.label
    in
    Input.radio
        [ Element.padding 10
        , Element.spacing 20
        ]
        { onChange = options.onChange
        , selected = options.selected
        , label = inputLabel
        , options = radioOptions
        }
