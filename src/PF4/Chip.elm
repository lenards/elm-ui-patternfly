module PF4.Chip exposing
    ( Chip
    , chip
    , withCloseMsg, withForeground
    , toMarkup
    )

{-| A component for displaying items that are involved in selection or filtering
out of an overall group.

See also, `PF4.ChipGroup`


# Definition

@docs Chip


# Constructor function

@docs chip


# Configuration functions

@docs withCloseMsg, withForeground


# Rendering element

@docs toMarkup

<https://www.patternfly.org/v4/components/chip>

-}

import Element exposing (Element)
import Element.Background as Bg
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import Element.Keyed as Keyed
import Murmur3
import PF4.Icons as Icons


{-| Opaque `Chip` element that can produce `msg` messages
-}
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


{-| Constructs a `Chip` from the text
-}
chip : String -> Chip msg
chip text =
    Chip
        { text = text
        , onClose = Nothing
        , background = Element.rgb255 255 255 255
        , foreground = Element.rgb255 21 21 21
        }


{-| Configures what `msg` is produced `onClick` by `Chip`
-}
withCloseMsg : msg -> Chip msg -> Chip msg
withCloseMsg msg (Chip options) =
    Chip { options | onClose = Just msg }


{-| Configures the foreground color, in RGB
-}
withForeground : ( Int, Int, Int ) -> Chip msg -> Chip msg
withForeground ( r, g, b ) (Chip options) =
    Chip
        { options
            | foreground =
                Element.rgb255 r g b
        }


{-| Given the custom type representation, renders as an `Element msg`.
-}
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
