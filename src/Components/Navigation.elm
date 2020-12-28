module Components.Navigation exposing (..)

import Element exposing (Element)
import Element.Background as Bg
import Element.Font as Font
import Element.Region as Region
import Murmur3


type Variant
    = Default
    | Horizontal
    | Terinary


type Navigation msg
    = Nav (Options msg)


type alias Options msg =
    { variant : Variant
    , children : List (NavItem msg)
    , background : Element.Color
    , foreground : Element.Color
    }


type NavItem msg
    = NavItem (ItemOptions msg)


type alias ItemOptions msg =
    { itemId : String
    , name : String
    , to : Maybe String
    , onPress : Maybe msg
    }


nav : List ( String, msg ) -> Navigation msg
nav items =
    Nav
        { variant = Default
        , background = Element.rgb255 21 21 21
        , foreground = Element.rgb255 255 255 255
        , children =
            items
                |> List.map
                    (\( name, msg ) ->
                        navItem
                            { name = name
                            , onPress = Just msg
                            }
                    )
        }


navItem : { name : String, onPress : Maybe msg } -> NavItem msg
navItem { name, onPress } =
    let
        genId =
            Murmur3.hashString 650 name
                |> String.fromInt
    in
    NavItem
        { itemId = genId
        , name = name
        , to = Nothing
        , onPress = onPress
        }


itemMarkup : NavItem msg -> Element msg
itemMarkup (NavItem options) =
    let
        attrs_ =
            []
    in
    Element.row attrs_ <|
        [ Element.el [ Element.padding 8 ] <|
            Element.text options.name
        ]


toMarkup : Navigation msg -> Element msg
toMarkup (Nav options) =
    let
        attrs_ =
            [ Bg.color options.background
            , Element.padding 8
            , Font.color options.foreground
            , Region.navigation
            , Element.height Element.fill
            ]
    in
    Element.column attrs_ <|
        (options.children
            |> List.map itemMarkup
        )
