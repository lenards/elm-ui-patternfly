module PF6.Table exposing
    ( Table, Column, SortDirection(..)
    , table
    , column
    , withCaption, withSortable, withStriped, withCompact, withBordered
    , withSortedBy
    , toMarkup
    )

{-| PF6 Table component

Tables organize and display data efficiently in rows and columns.

See: <https://www.patternfly.org/components/table>


# Definition

@docs Table, Column, SortDirection


# Constructor

@docs table


# Column constructor

@docs column


# Table modifiers

@docs withCaption, withSortable, withStriped, withCompact, withBordered


# Sort state

@docs withSortedBy


# Rendering

@docs toMarkup

-}

import Element exposing (Element)
import Element.Background as Bg
import Element.Border as Border
import Element.Font as Font
import PF6.Theme as Theme exposing (Theme)
import PF6.Tokens as Tokens


{-| Opaque Table type
-}
type Table row msg
    = Table (Options row msg)


{-| A table column definition
-}
type Column row msg
    = Column (ColumnOptions row msg)


{-| Sort direction
-}
type SortDirection
    = Ascending
    | Descending


type alias ColumnOptions row msg =
    { key : String
    , label : String
    , view : row -> Element msg
    , isSortable : Bool
    , onSort : Maybe (SortDirection -> msg)
    }


type alias SortState =
    { key : String
    , direction : SortDirection
    }


type alias Options row msg =
    { columns : List (Column row msg)
    , rows : List row
    , caption : Maybe String
    , isSortable : Bool
    , isStriped : Bool
    , isCompact : Bool
    , isBordered : Bool
    , sortState : Maybe SortState
    }


{-| Construct a Table

    table
        { columns = [ nameCol, emailCol, statusCol ]
        , rows = model.users
        }

-}
table : { columns : List (Column row msg), rows : List row } -> Table row msg
table config =
    Table
        { columns = config.columns
        , rows = config.rows
        , caption = Nothing
        , isSortable = False
        , isStriped = False
        , isCompact = False
        , isBordered = False
        , sortState = Nothing
        }


{-| Construct a column

    column
        { key = "name"
        , label = "Name"
        , view = \row -> Element.text row.name
        }

-}
column : { key : String, label : String, view : row -> Element msg } -> Column row msg
column config =
    Column
        { key = config.key
        , label = config.label
        , view = config.view
        , isSortable = False
        , onSort = Nothing
        }


{-| Set a table caption
-}
withCaption : String -> Table row msg -> Table row msg
withCaption cap (Table opts) =
    Table { opts | caption = Just cap }


{-| Enable sortable columns
-}
withSortable : Table row msg -> Table row msg
withSortable (Table opts) =
    Table { opts | isSortable = True }


{-| Striped rows
-}
withStriped : Table row msg -> Table row msg
withStriped (Table opts) =
    Table { opts | isStriped = True }


{-| Compact row height
-}
withCompact : Table row msg -> Table row msg
withCompact (Table opts) =
    Table { opts | isCompact = True }


{-| Add borders between rows and columns
-}
withBordered : Table row msg -> Table row msg
withBordered (Table opts) =
    Table { opts | isBordered = True }


{-| Set current sort state
-}
withSortedBy : { key : String, direction : SortDirection } -> Table row msg -> Table row msg
withSortedBy { key, direction } (Table opts) =
    Table { opts | sortState = Just { key = key, direction = direction } }


headerCell : Theme -> Options row msg -> Column row msg -> Element msg
headerCell theme opts (Column col) =
    let
        sortIndicator =
            case opts.sortState of
                Just { key, direction } ->
                    if key == col.key then
                        case direction of
                            Ascending ->
                                " ↑"

                            Descending ->
                                " ↓"

                    else
                        " ↕"

                Nothing ->
                    if opts.isSortable then
                        " ↕"

                    else
                        ""

        label =
            col.label ++ sortIndicator

        cellPad =
            if opts.isCompact then
                Element.paddingXY Tokens.spacerSm Tokens.spacerXs

            else
                Element.paddingXY Tokens.spacerMd Tokens.spacerSm
    in
    Element.el
        [ cellPad
        , Font.bold
        , Font.size Tokens.fontSizeSm
        , Font.color (Theme.text theme)
        , Bg.color (Theme.backgroundSecondary theme)
        , Element.width Element.fill
        , Border.widthEach { top = 0, right = 0, bottom = 2, left = 0 }
        , Border.color (Theme.borderDefault theme)
        ]
        (Element.text label)


bodyCell : Theme -> Options row msg -> Column row msg -> row -> Element msg
bodyCell theme opts (Column col) row =
    let
        cellPad =
            if opts.isCompact then
                Element.paddingXY Tokens.spacerSm Tokens.spacerXs

            else
                Element.paddingXY Tokens.spacerMd Tokens.spacerSm

        borderAttrs =
            if opts.isBordered then
                [ Border.widthEach { top = 0, right = 1, bottom = 1, left = 0 }
                , Border.color (Theme.borderSubtle theme)
                ]

            else
                [ Border.widthEach { top = 0, right = 0, bottom = 1, left = 0 }
                , Border.color (Theme.borderSubtle theme)
                ]
    in
    Element.el
        ([ cellPad
         , Font.size Tokens.fontSizeMd
         , Font.color (Theme.text theme)
         , Element.width Element.fill
         ]
            ++ borderAttrs
        )
        (col.view row)


bodyRow : Theme -> Options row msg -> Int -> row -> Element msg
bodyRow theme opts index row =
    let
        bg =
            if opts.isStriped && modBy 2 index == 1 then
                Theme.backgroundSecondary theme

            else
                Theme.backgroundDefault theme
    in
    Element.row
        [ Element.width Element.fill
        , Bg.color bg
        ]
        (List.map (\col -> bodyCell theme opts col row) opts.columns)


{-| Render the Table as an `Element msg`
-}
toMarkup : Theme -> Table row msg -> Element msg
toMarkup theme (Table opts) =
    let
        captionEl =
            opts.caption
                |> Maybe.map
                    (\cap ->
                        Element.el
                            [ Font.size Tokens.fontSizeSm
                            , Font.color (Theme.textSubtle theme)
                            , Element.paddingEach { top = 0, right = 0, bottom = Tokens.spacerXs, left = 0 }
                            ]
                            (Element.text cap)
                    )
                |> Maybe.withDefault Element.none

        headerRow =
            Element.row
                [ Element.width Element.fill ]
                (List.map (headerCell theme opts) opts.columns)

        bodyRows =
            List.indexedMap (bodyRow theme opts) opts.rows
    in
    Element.column
        [ Element.width Element.fill
        , Border.rounded Tokens.radiusMd
        , Border.solid
        , Border.width 1
        , Border.color (Theme.borderDefault theme)
        ]
        (captionEl :: headerRow :: bodyRows)
