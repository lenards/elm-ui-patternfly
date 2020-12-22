module Components.ChipGroup exposing
    ( ChipGroup
    , group
    , toMarkup
    , withCategory
    , withClickMsg
    )

import Components.Chip as Chip exposing (Chip)
import Element exposing (Element)
import Element.Background as Bg
import Element.Border as Border
import Element.Input as Input
import Html
import Html.Attributes exposing (style)
import Svg
import Svg.Attributes as SvgAttrs


type ChipGroup msg
    = ChipGroup (Options msg)


type ChipsShown
    = All
    | Show Int


defaultNumChips : Int
defaultNumChips =
    3


type alias Options msg =
    { chips : List (Chip msg)
    , category : Maybe String
    , numChips : ChipsShown
    , onClick : Maybe msg
    }


expandedText : Int -> String
expandedText remaining =
    String.fromInt remaining
        ++ "more"


defaultClose : Element msg
defaultClose =
    Html.div [ style "color" "rgb(106, 110, 115)" ]
        [ Svg.svg
            [ SvgAttrs.fill "currentColor"
            , SvgAttrs.viewBox "0 0 512 512"
            , SvgAttrs.height "1em"
            , SvgAttrs.width "1em"
            ]
            [ Svg.path
                [ SvgAttrs.d
                    (String.concat
                        [ "M256 8C119 8 8 119 8 256s111 248 248 248 "
                        , "248-111 248-248S393 8 256 8zm121.6 313.1c4.7 "
                        , "4.7 4.7 12.3 0 17L338 377.6c-4.7 4.7-12.3 "
                        , "4.7-17 0L256 312l-65.1 65.6c-4.7 4.7-12.3 "
                        , "4.7-17 0L134.4 338c-4.7-4.7-4.7-12.3 "
                        , "0-17l65.6-65-65.6-65.1c-4.7-4.7-4.7-12.3 "
                        , "0-17l39.6-39.6c4.7-4.7 12.3-4.7 17 0l65 65.7 "
                        , "65.1-65.6c4.7-4.7 12.3-4.7 17 0l39.6 39.6c4.7 "
                        , "4.7 4.7 12.3 0 17L312 256l65.6 65.1z"
                        ]
                    )
                ]
                []
            ]
        ]
        |> Element.html


group : List String -> (String -> msg) -> ChipGroup msg
group chipList chipClickMsg =
    let
        chips =
            chipList
                |> List.map
                    (\c ->
                        Chip.chip c
                            |> Chip.withClickMsg (chipClickMsg c)
                    )
    in
    ChipGroup
        { chips = chips
        , category = Nothing
        , numChips = Show defaultNumChips
        , onClick = Nothing
        }


withCategory : String -> ChipGroup msg -> ChipGroup msg
withCategory category (ChipGroup options) =
    ChipGroup { options | category = Just category }


withClickMsg : msg -> ChipGroup msg -> ChipGroup msg
withClickMsg clickMsg (ChipGroup options) =
    ChipGroup { options | onClick = Just clickMsg }


toMarkup : ChipGroup msg -> Element msg
toMarkup (ChipGroup options) =
    let
        parentEl =
            case options.category of
                Just categoryName ->
                    \attrs children ->
                        Element.el [] <|
                            Element.row (attrs ++ categoryAttrs_) <|
                                [ Element.el [] <|
                                    Element.text categoryName
                                , Element.row [] children
                                , Input.button
                                    [ Element.moveDown 2.0 ]
                                    { onPress = options.onClick
                                    , label = defaultClose
                                    }
                                ]

                Nothing ->
                    \attrs children ->
                        Element.el [] <|
                            Element.row attrs children

        categoryAttrs_ =
            [ Bg.color <| Element.rgb255 240 240 240
            , Border.rounded 3
            , Element.paddingEach
                { top = 4
                , right = 4
                , bottom = 4
                , left = 8
                }
            ]

        attrs_ =
            [ Element.spaceEvenly
            , Element.spacing 8
            ]
    in
    parentEl attrs_ <|
        (options.chips
            |> List.map Chip.toMarkup
        )
