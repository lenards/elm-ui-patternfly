module PF4.Navigation exposing
    ( Navigation
    , nav, navItem
    , selectItem
    , withSelectedItem, withSelectedFirstItem
    , withHorizontalVariant, withTerinaryVariant
    , toMarkup
    )

{-| A stateless component for application navigation

Intended to have its state "driven" by the Elm application using it.

Uses the `Element.Region.navigation` to indicate semantic intent.

<https://www.patternfly.org/v4/components/navigation>


# Definition

@docs Navigation


# Constructor functions

@docs nav, navItem


# Perform State Change

@docs selectItem


# Selection functions

@docs withSelectedItem, withSelectedFirstItem


# Configuration functions

@docs withHorizontalVariant, withTerinaryVariant


# Rendering stateless element

@docs toMarkup

-}

import Dict exposing (Dict)
import Element exposing (Element)
import Element.Background as Bg
import Element.Border as Border
import Element.Events as Events
import Element.Font as Font
import Element.Region as Region
import Murmur3


{-| Opaque `Navigation` element that can produce `msg` messages
-}
type Navigation msg
    = Nav (Options msg)


type alias Options msg =
    { variant : Variant
    , children : NavItems msg
    , background : Element.Color
    , foreground : Element.Color
    }


type Variant
    = Default
    | Horizontal
    | Terinary


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


{-| Constructs a `Navigation msg` given a list of items

You could render a `Navigation msg` with the following

    [ "Badge"
    , "Chip"
    , "ChipGroup"
    , "Icons"
    , "Info"
    , "Label"
    , "Navigation"
    , "Title"
    , "Tooltip"
    ]
        |> List.map
            (\item ->
                ( item, NavSelected item )
            )
        |> Navigation.nav

However, you will need want to have the `navItems` available for
application code. It would make more sense to likely render using
values that are stored your `Model`:

    model.navItems
        |> List.map
            (\item ->
                ( item, NavSelected item )
            )
        |> Navigation.nav
        |> Navigation.withSelectedItem
            model.selectedNav

Currently, `Navigation msg` is implemented in a stateless manner,
assuming the Elm application will want to _drive_ the transitions
from data that is in the model.

-}
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
                        (\( i, NavItem opts ) ->
                            Dict.insert opts.name ( i, NavItem opts )
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


{-| Constructs a `NavItem msg` given a `name` and `msg` to produce `onPress`

For a `NavItem msg` that is disabled or not clickable, you can provide
`Nothing` for `onPress`.

Note: `name` is assumed to be unique among all items

-}
navItem : { name : String, onPress : Maybe msg } -> NavItem msg
navItem { name, onPress } =
    let
        generatedId =
            Murmur3.hashString 650 name
                |> String.fromInt
    in
    NavItem
        { itemId = generatedId
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


{-| Configures the selected item to be `itemName`
-}
withSelectedItem : String -> Navigation msg -> Navigation msg
withSelectedItem itemName (Nav options) =
    Nav
        (options.children
            |> setSelected (Just itemName)
            |> asNavItemsIn options
        )


{-| Configures that navigation to have the first `NavItem msg` as selected
-}
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


{-| Selects an item by `itemName`

For duplicates, the handling of selection would be predictable given
the underlying representation.

-}
selectItem : String -> Navigation msg -> Navigation msg
selectItem itemName nav_ =
    -- alias for the builder function
    withSelectedItem itemName nav_


{-| Configures the orientation for rendering to be horizontal
-}
withHorizontalVariant : Navigation msg -> Navigation msg
withHorizontalVariant (Nav options) =
    Nav { options | variant = Horizontal }


{-| Configures the orientation for rendering
-}
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


{-| Given the custom type representation, renders as an `Element msg`.
-}
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
