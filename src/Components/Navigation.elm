module Components.Navigation exposing (..)

import Element exposing (Element)
import Element.Background as Bg
import Element.Border as Border
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
    , selected : Bool
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
        , selected = False
        }


withSelectedItem : String -> Navigation msg -> Navigation msg
withSelectedItem itemName (Nav options) =
    let
        matches n_ =
            n_.name == itemName

        handleOne acc_ lst_ (NavItem options_) =
            if matches options_ then
                lst_
                    |> traverse_
                        (NavItem { options_ | selected = True } :: acc_)

            else
                lst_
                    |> traverse_
                        (NavItem options_ :: acc_)

        traverse_ acc_ lst_ =
            case lst_ of
                h :: t ->
                    h |> handleOne acc_ t

                [] ->
                    acc_

        newChildren =
            options.children
                |> traverse_ []
    in
    Nav
        { options
            | children = newChildren
        }


withSelectedFirstItem : Navigation msg -> Navigation msg
withSelectedFirstItem (Nav options) =
    let
        newItems =
            case options.children of
                [] ->
                    options.children

                (NavItem opts_) :: t ->
                    NavItem { opts_ | selected = True } :: t
    in
    Nav { options | children = newItems }


{-| Traverse a list of items, and update based on criteria

This compiles, but generates a type mismatch on `items`
when used ... it's :spooky:

-}
traverse : { byName : Maybe String, byId : Maybe String } -> List (NavItem msg) -> List (NavItem msg)
traverse { byName, byId } items =
    let
        matches n_ =
            case ( byName, byId ) of
                ( Just name_, Nothing ) ->
                    n_.name == name_

                ( Nothing, Just id_ ) ->
                    n_.itemId == id_

                ( Just name_, Just id_ ) ->
                    n_.name == name_ && n_.itemId == id_

                ( Nothing, Nothing ) ->
                    False

        handleOne acc_ lst_ (NavItem options_) =
            if matches options_ then
                lst_
                    |> traverse_
                        (NavItem { options_ | selected = True } :: acc_)

            else
                lst_
                    |> traverse_
                        (NavItem options_ :: acc_)

        traverse_ acc_ lst_ =
            case lst_ of
                h :: t ->
                    h |> handleOne acc_ t

                [] ->
                    acc_
    in
    traverse_ [] items


itemMarkup : NavItem msg -> Element msg
itemMarkup (NavItem options) =
    let
        attrs_ =
            if options.selected then
                [ Bg.color <| Element.rgb255 79 82 85
                , Border.solid
                , Border.widthEach
                    { top = 0
                    , right = 0
                    , bottom = 0
                    , left = 4
                    }
                , Border.color <| Element.rgb255 115 188 247
                , Element.width Element.fill
                ]

            else
                [ Bg.color <| Element.rgb255 21 21 21
                , Element.mouseOver
                    [ Bg.color <| Element.rgb255 60 63 66
                    ]
                , Element.pointer
                , Element.width Element.fill
                ]
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
