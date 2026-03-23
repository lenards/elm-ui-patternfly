module PF6.Toolbar exposing
    ( Toolbar, ToolbarItem, ToolbarGroup
    , toolbar
    , toolbarItem, toolbarGroup, toolbarSeparator
    , withClearAll, withItemCount
    , toMarkup
    )

{-| PF6 Toolbar component

Toolbars allow users to manage and manipulate a data set, providing filter
and sort controls above the data.

See: <https://www.patternfly.org/components/toolbar>


# Definition

@docs Toolbar, ToolbarItem, ToolbarGroup


# Constructor

@docs toolbar


# Item constructors

@docs toolbarItem, toolbarGroup, toolbarSeparator


# Modifier functions

@docs withClearAll, withItemCount


# Rendering

@docs toMarkup

-}

import Element exposing (Element)
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import PF6.Tokens as Tokens


{-| Opaque Toolbar type
-}
type Toolbar msg
    = Toolbar (Options msg)


{-| A toolbar item (wraps a single control)
-}
type ToolbarItem msg
    = ToolbarEl (Element msg)
    | ToolbarSep
    | ToolbarGrp (ToolbarGroup msg)


{-| A toolbar group (set of related items)
-}
type ToolbarGroup msg
    = ToolbarGroup (List (ToolbarItem msg))


type alias Options msg =
    { items : List (ToolbarItem msg)
    , itemCount : Maybe String
    , onClearAll : Maybe msg
    }


{-| Construct a Toolbar from a list of items
-}
toolbar : List (ToolbarItem msg) -> Toolbar msg
toolbar items =
    Toolbar
        { items = items
        , itemCount = Nothing
        , onClearAll = Nothing
        }


{-| Wrap an element as a toolbar item
-}
toolbarItem : Element msg -> ToolbarItem msg
toolbarItem el =
    ToolbarEl el


{-| Group toolbar items together
-}
toolbarGroup : List (ToolbarItem msg) -> ToolbarItem msg
toolbarGroup items =
    ToolbarGrp (ToolbarGroup items)


{-| A vertical separator between toolbar items
-}
toolbarSeparator : ToolbarItem msg
toolbarSeparator =
    ToolbarSep


{-| Add a "Clear all filters" button
-}
withClearAll : msg -> Toolbar msg -> Toolbar msg
withClearAll msg (Toolbar opts) =
    Toolbar { opts | onClearAll = Just msg }


{-| Display an item count label
-}
withItemCount : String -> Toolbar msg -> Toolbar msg
withItemCount count (Toolbar opts) =
    Toolbar { opts | itemCount = Just count }


renderItem : ToolbarItem msg -> Element msg
renderItem item =
    case item of
        ToolbarEl el ->
            Element.el [ Element.paddingXY Tokens.spacerXs 0 ] el

        ToolbarSep ->
            Element.el
                [ Element.width (Element.px 1)
                , Element.height (Element.px 24)
                , Element.alignLeft
                , Border.widthEach { top = 0, right = 1, bottom = 0, left = 0 }
                , Border.color Tokens.colorBorderDefault
                , Element.paddingXY 0 0
                ]
                Element.none

        ToolbarGrp (ToolbarGroup items) ->
            Element.row
                [ Element.spacing Tokens.spacerXs ]
                (List.map renderItem items)


{-| Render the Toolbar as an `Element msg`
-}
toMarkup : Toolbar msg -> Element msg
toMarkup (Toolbar opts) =
    let
        itemEls =
            List.map renderItem opts.items

        countEl =
            opts.itemCount
                |> Maybe.map
                    (\count ->
                        Element.el
                            [ Font.size Tokens.fontSizeSm
                            , Font.color Tokens.colorTextSubtle
                            , Element.paddingXY Tokens.spacerSm 0
                            ]
                            (Element.text count)
                    )
                |> Maybe.withDefault Element.none

        clearEl =
            opts.onClearAll
                |> Maybe.map
                    (\msg ->
                        Input.button
                            [ Font.size Tokens.fontSizeSm
                            , Font.color Tokens.colorPrimary
                            ]
                            { onPress = Just msg
                            , label = Element.text "Clear all filters"
                            }
                    )
                |> Maybe.withDefault Element.none
    in
    Element.row
        [ Element.width Element.fill
        , Element.paddingXY 0 Tokens.spacerSm
        , Element.spacing Tokens.spacerXs
        ]
        (itemEls
            ++ [ Element.el [ Element.alignRight ]
                    (Element.row [ Element.spacing Tokens.spacerSm ]
                        [ countEl, clearEl ]
                    )
               ]
        )
