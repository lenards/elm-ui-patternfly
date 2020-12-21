module Components.Chip exposing
    ( Chip
    , chip
    , toMarkup
    , withClickMsg
    )

import Element exposing (Element)
import Element.Background as Bg
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import Element.Keyed as Keyed
import Html
import Html.Attributes exposing (style)
import Murmur3
import Svg
import Svg.Attributes as SvgAttrs


type Chip msg
    = Chip (Options msg)


type alias Options msg =
    { text : String
    , onClick : Maybe msg
    , background : Element.Color
    , foreground : Element.Color
    }


defaultClose : Element msg
defaultClose =
    Html.div [ style "color" "rgb(106, 110, 115)" ]
        [ Svg.svg
            [ SvgAttrs.fill "currentColor"
            , SvgAttrs.viewBox "0 0 1792 1792"
            , SvgAttrs.height "1em"
            , SvgAttrs.width "1em"
            ]
            [ Svg.path
                [ SvgAttrs.d
                    (String.concat
                        [ "M1490 1322q0 40-28 68l-136 136q-28 28-68 "
                        , "28t-68-28l-294-294-294 294q-28 28-68 "
                        , "28t-68-28l-136-136q-28-28-28-68t28-68l294-294-294-294q-28-28-28-68t28-68l136-136q28-28 "
                        , "68-28t68 28l294 294 294-294q28-28 68-28t68 "
                        , "28l136 136q28 28 28 68t-28 68l-294 294 294 "
                        , "294q28 28 28 68z"
                        ]
                    )
                ]
                []
            ]
        ]
        |> Element.html


chip : String -> Chip msg
chip text =
    Chip
        { text = text
        , onClick = Nothing
        , background = Element.rgb255 255 255 255
        , foreground = Element.rgb255 21 21 21
        }


withClickMsg : msg -> Chip msg -> Chip msg
withClickMsg msg (Chip options) =
    Chip { options | onClick = Just msg }


toMarkup : Chip msg -> Element msg
toMarkup (Chip options) =
    let
        key =
            Murmur3.hashString 650 options.text
                |> String.fromInt

        contentEl =
            case options.onClick of
                Just clickMsg ->
                    \attrs child ->
                        Element.row attrs <|
                            [ Element.el [] child
                            , Input.button [ Element.moveDown 2.0 ]
                                { onPress = Just clickMsg
                                , label = defaultClose
                                }
                            ]

                Nothing ->
                    \attrs child ->
                        Element.el attrs child

        attrs_ =
            [ Bg.color options.background
            , Border.color <| Element.rgb255 240 240 240
            , Border.solid
            , Border.width 1
            , Border.rounded 3
            , Element.paddingXY 8 4
            , Font.color options.foreground
            ]

        chipEl =
            contentEl attrs_ <|
                Element.text options.text
    in
    Keyed.el [] ( key, chipEl )
