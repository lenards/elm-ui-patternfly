module Components.Chip exposing
    ( Chip
    , chip
    , toMarkup
    , withCloseMsg
    , withForeground
    )

import Components.Icons as Icons
import Element exposing (Element)
import Element.Background as Bg
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import Element.Keyed as Keyed
import Murmur3


type Chip msg
    = Chip (Options msg)


type alias Options msg =
    { text : String
    , onClose : Maybe msg
    , background : Element.Color
    , foreground : Element.Color
    }


defaultClose : Element msg
defaultClose =
    Icons.close


chip : String -> Chip msg
chip text =
    Chip
        { text = text
        , onClose = Nothing
        , background = Element.rgb255 255 255 255
        , foreground = Element.rgb255 21 21 21
        }


withCloseMsg : msg -> Chip msg -> Chip msg
withCloseMsg msg (Chip options) =
    Chip { options | onClose = Just msg }


withForeground : ( Int, Int, Int ) -> Chip msg -> Chip msg
withForeground ( r, g, b ) (Chip options) =
    Chip
        { options
            | foreground =
                Element.rgb255 r g b
        }


toMarkup : Chip msg -> Element msg
toMarkup (Chip options) =
    let
        key =
            Murmur3.hashString 650 options.text
                |> String.fromInt

        parentEl =
            case options.onClose of
                Just closeMsg ->
                    \attrs child ->
                        Element.row attrs <|
                            [ Element.el [] child
                            , Input.button [ Element.moveDown 2.0 ]
                                { onPress = Just closeMsg
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
            parentEl attrs_ <|
                Element.text options.text
    in
    Keyed.el [] ( key, chipEl )
