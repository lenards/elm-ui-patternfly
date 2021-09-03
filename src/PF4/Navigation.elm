module PF4.Navigation exposing
    ( Navigation
    , nav
    , navItem
    , selectItem
    , toMarkup
    , withHorizontalVariant
    , withSelectedFirstItem
    , withSelectedItem
    , withTerinaryVariant
    )

import Dict exposing (Dict)
import Element exposing (Element)
import Element.Background as Bg
import Element.Border as Border
import Element.Events as Events
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
    , children : NavItems msg
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


type alias NavItems msg =
    { items : Dict String ( Int, NavItem msg )
    , selected : Maybe String
    }


nav : List ( String, msg ) -> Navigation msg
nav items =
    let
        navItems =
            { selected = Nothing
            , items =
                items
                    |> List.indexedMap Tuple.pair
                    |> List.map
                        (\( idx, ( name, msg ) ) ->
                            ( idx
                            , navItem
                                { name = name
                                , onPress = Just msg
                                }
                            )
                        )
                    |> List.foldr
                        (\( k, NavItem opts ) ->
                            Dict.insert opts.name ( k, NavItem opts )
                        )
                        Dict.empty
            }
    in
    Nav
        { variant = Default
        , background = Element.rgb255 21 21 21
        , foreground = Element.rgb255 255 255 255
        , children = navItems
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


asNavItemsIn : Options msg -> NavItems msg -> Options msg
asNavItemsIn options newNavItems =
    { options | children = newNavItems }


setSelected : Maybe String -> NavItems msg -> NavItems msg
setSelected mItemName navItems =
    { navItems | selected = mItemName }


withSelectedItem : String -> Navigation msg -> Navigation msg
withSelectedItem itemName (Nav options) =
    Nav
        (options.children
            |> setSelected (Just itemName)
            |> asNavItemsIn options
        )


withSelectedFirstItem : Navigation msg -> Navigation msg
withSelectedFirstItem (Nav options) =
    let
        firstName =
            options.children.items
                |> Dict.values
                |> List.sortBy Tuple.first
                |> List.head
                |> Maybe.map
                    (\( _, NavItem first ) ->
                        Just first.name
                    )
                |> Maybe.withDefault
                    Nothing
    in
    Nav
        (options.children
            |> setSelected firstName
            |> asNavItemsIn options
        )


selectItem : String -> Navigation msg -> Navigation msg
selectItem itemName nav_ =
    -- alias for the builder function
    withSelectedItem itemName nav_


withHorizontalVariant : Navigation msg -> Navigation msg
withHorizontalVariant (Nav options) =
    Nav { options | variant = Horizontal }


withTerinaryVariant : Navigation msg -> Navigation msg
withTerinaryVariant (Nav options) =
    Nav { options | variant = Terinary }


itemMarkup : Maybe String -> NavItem msg -> Element msg
itemMarkup mItemName (NavItem options) =
    let
        selected_ name_ =
            mItemName
                |> Maybe.map (\n -> n == name_)
                |> Maybe.withDefault False

        attrs_ =
            if selected_ options.name then
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

        baseChildAttrs =
            [ Element.padding 8 ]

        childAttrs_ =
            options.onPress
                |> Maybe.map
                    (\pressMsg ->
                        Events.onClick pressMsg
                            :: baseChildAttrs
                    )
                |> Maybe.withDefault
                    baseChildAttrs
    in
    Element.row attrs_ <|
        [ Element.el childAttrs_ <|
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

        items =
            options.children.items
                |> Dict.values
                |> List.sortBy Tuple.first
                |> List.map Tuple.second

        itemMarkup_ =
            itemMarkup options.children.selected
    in
    Element.column attrs_ <|
        (items |> List.map itemMarkup_)
