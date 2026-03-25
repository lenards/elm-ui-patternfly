module PF6.DataList exposing
    ( DataList, DataListItem, DataListCell
    , dataList
    , item, cell
    , withActions, withCheckable, withChecked, withExpandable, withExpanded
    , withCompact, withStriped
    , toMarkup
    )

{-| PF6 DataList component

DataList displays data in a list format — more flexible than Table,
suitable for data with varied display needs.

See: <https://www.patternfly.org/components/data-list>


# Definition

@docs DataList, DataListItem, DataListCell


# Constructor

@docs dataList


# Item constructors

@docs item, cell


# Item modifiers

@docs withActions, withCheckable, withChecked, withExpandable, withExpanded


# List modifiers

@docs withCompact, withStriped


# Rendering

@docs toMarkup

-}

import Element exposing (Element)
import Element.Background as Bg
import Element.Border as Border
import Element.Input as Input
import PF6.Theme as Theme exposing (Theme)
import PF6.Tokens as Tokens


{-| Opaque DataList type
-}
type DataList msg
    = DataList (Options msg)


{-| A data list item (a row)
-}
type DataListItem msg
    = DataListItem (ItemOptions msg)


{-| A data list cell (a column within a row)
-}
type DataListCell msg
    = DataListCell (CellOptions msg)


type alias CellOptions msg =
    { content : Element msg
    , width : Element.Length
    , isTruncated : Bool
    }


type alias ItemOptions msg =
    { cells : List (DataListCell msg)
    , actions : Maybe (Element msg)
    , isCheckable : Bool
    , isChecked : Bool
    , onCheck : Maybe (Bool -> msg)
    , isExpandable : Bool
    , isExpanded : Bool
    , expandedContent : Maybe (Element msg)
    , onExpand : Maybe (Bool -> msg)
    }


type alias Options msg =
    { items : List (DataListItem msg)
    , isCompact : Bool
    , isStriped : Bool
    }


{-| Construct a DataList from items
-}
dataList : List (DataListItem msg) -> DataList msg
dataList items =
    DataList
        { items = items
        , isCompact = False
        , isStriped = False
        }


{-| Construct a DataListItem from cells
-}
item : List (DataListCell msg) -> DataListItem msg
item cells =
    DataListItem
        { cells = cells
        , actions = Nothing
        , isCheckable = False
        , isChecked = False
        , onCheck = Nothing
        , isExpandable = False
        , isExpanded = False
        , expandedContent = Nothing
        , onExpand = Nothing
        }


{-| Construct a DataListCell from an element
-}
cell : Element msg -> DataListCell msg
cell content =
    DataListCell
        { content = content
        , width = Element.fill
        , isTruncated = False
        }


{-| Add action buttons to the item
-}
withActions : Element msg -> DataListItem msg -> DataListItem msg
withActions el (DataListItem opts) =
    DataListItem { opts | actions = Just el }


{-| Make the item checkable
-}
withCheckable : (Bool -> msg) -> DataListItem msg -> DataListItem msg
withCheckable onCheck (DataListItem opts) =
    DataListItem { opts | isCheckable = True, onCheck = Just onCheck }


{-| Set checked state
-}
withChecked : Bool -> DataListItem msg -> DataListItem msg
withChecked checked (DataListItem opts) =
    DataListItem { opts | isChecked = checked }


{-| Make the item expandable (shows extra content when expanded)
-}
withExpandable : Element msg -> (Bool -> msg) -> DataListItem msg -> DataListItem msg
withExpandable content onExpand (DataListItem opts) =
    DataListItem
        { opts
            | isExpandable = True
            , expandedContent = Just content
            , onExpand = Just onExpand
        }


{-| Set expanded state
-}
withExpanded : Bool -> DataListItem msg -> DataListItem msg
withExpanded expanded (DataListItem opts) =
    DataListItem { opts | isExpanded = expanded }


{-| Compact row height
-}
withCompact : DataList msg -> DataList msg
withCompact (DataList opts) =
    DataList { opts | isCompact = True }


{-| Striped rows
-}
withStriped : DataList msg -> DataList msg
withStriped (DataList opts) =
    DataList { opts | isStriped = True }


renderCell : DataListCell msg -> Element msg
renderCell (DataListCell cellOpts) =
    Element.el
        [ Element.width cellOpts.width ]
        cellOpts.content


renderItem : Theme -> Options msg -> Int -> DataListItem msg -> Element msg
renderItem theme opts index (DataListItem itemOpts) =
    let
        padding =
            if opts.isCompact then
                Tokens.spacerSm

            else
                Tokens.spacerMd

        bg =
            if opts.isStriped && modBy 2 index == 1 then
                Theme.backgroundSecondary theme

            else
                Theme.backgroundDefault theme

        checkEl =
            if itemOpts.isCheckable then
                case itemOpts.onCheck of
                    Just onCheck ->
                        Input.checkbox
                            [ Element.paddingEach { top = 0, right = Tokens.spacerSm, bottom = 0, left = 0 } ]
                            { onChange = onCheck
                            , icon = Input.defaultCheckbox
                            , checked = itemOpts.isChecked
                            , label = Input.labelHidden "select item"
                            }

                    Nothing ->
                        Element.none

            else
                Element.none

        expandBtn =
            if itemOpts.isExpandable then
                case itemOpts.onExpand of
                    Just onExpand ->
                        Input.button
                            [ Element.paddingEach { top = 0, right = Tokens.spacerSm, bottom = 0, left = 0 } ]
                            { onPress = Just (onExpand (not itemOpts.isExpanded))
                            , label =
                                Element.text
                                    (if itemOpts.isExpanded then
                                        "▲"

                                     else
                                        "▼"
                                    )
                            }

                    Nothing ->
                        Element.none

            else
                Element.none

        actionsEl =
            itemOpts.actions |> Maybe.withDefault Element.none

        mainRow =
            Element.row
                [ Element.width Element.fill
                , Element.padding padding
                , Element.spacing Tokens.spacerSm
                , Bg.color bg
                , Border.widthEach { top = 0, right = 0, bottom = 1, left = 0 }
                , Border.color (Theme.borderSubtle theme)
                ]
                ([ checkEl, expandBtn ]
                    ++ List.map renderCell itemOpts.cells
                    ++ [ Element.el [ Element.alignRight ] actionsEl ]
                )

        expandedRow =
            if itemOpts.isExpanded && itemOpts.isExpandable then
                case itemOpts.expandedContent of
                    Just content ->
                        Element.el
                            [ Element.width Element.fill
                            , Element.padding padding
                            , Bg.color bg
                            , Border.widthEach { top = 0, right = 0, bottom = 1, left = 0 }
                            , Border.color (Theme.borderSubtle theme)
                            ]
                            content

                    Nothing ->
                        Element.none

            else
                Element.none
    in
    Element.column
        [ Element.width Element.fill ]
        [ mainRow, expandedRow ]


{-| Render the DataList as an `Element msg`
-}
toMarkup : Theme -> DataList msg -> Element msg
toMarkup theme (DataList opts) =
    Element.column
        [ Element.width Element.fill
        , Border.rounded Tokens.radiusMd
        , Border.solid
        , Border.width 1
        , Border.color (Theme.borderDefault theme)
        ]
        (List.indexedMap (renderItem theme opts) opts.items)
