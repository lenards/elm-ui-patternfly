module Views.DataView exposing (view)

import Element exposing (Element)
import Element.Background as Bg
import Element.Border as Border
import Element.Font as Font
import PF6.Button as Button
import PF6.DataList as DataList
import PF6.Label as Label
import PF6.Table as Table
import PF6.Theme as Theme exposing (Theme)
import PF6.Tokens as Tokens
import PF6.Toolbar as Toolbar
import Types exposing (Model, Msg(..))


section : Theme -> String -> List (Element Msg) -> Element Msg
section theme heading items =
    Element.column
        [ Element.width Element.fill
        , Element.spacing Tokens.spacerMd
        , Element.padding Tokens.spacerMd
        , Bg.color (Theme.backgroundDefault theme)
        , Border.rounded Tokens.radiusMd
        , Border.solid
        , Border.width 1
        , Border.color (Theme.borderDefault theme)
        ]
        (Element.el [ Font.bold, Font.size Tokens.fontSizeLg, Font.color (Theme.text theme) ]
            (Element.text heading)
            :: items
        )


type alias User =
    { name : String
    , role : String
    , status : String
    , lastSeen : String
    }


sampleUsers : List User
sampleUsers =
    [ { name = "Alice Smith", role = "Admin", status = "Active", lastSeen = "2 hours ago" }
    , { name = "Bob Jones", role = "Editor", status = "Active", lastSeen = "1 day ago" }
    , { name = "Carol White", role = "Viewer", status = "Inactive", lastSeen = "2 weeks ago" }
    , { name = "Dave Brown", role = "Editor", status = "Active", lastSeen = "5 minutes ago" }
    ]


statusLabel : String -> Element Msg
statusLabel status =
    if status == "Active" then
        Label.label status |> Label.withGreenColor |> Label.toMarkup

    else
        Label.label status |> Label.toMarkup


view : Model -> Element Msg
view model =
    let
        theme =
            Theme.fromMode model.themeMode
    in
    Element.column
        [ Element.width Element.fill
        , Element.spacing Tokens.spacerLg
        ]
        [ Element.el [ Font.size Tokens.fontSize2xl, Font.bold, Font.color (Theme.text theme) ]
            (Element.text "Data")

        -- TOOLBAR
        , section theme
            "Toolbar"
            [ Toolbar.toolbar
                [ Toolbar.toolbarItem
                    (Button.secondary { label = "Filter", onPress = Nothing }
                        |> Button.withSmallSize
                        |> Button.toMarkup
                    )
                , Toolbar.toolbarItem
                    (Button.secondary { label = "Sort", onPress = Nothing }
                        |> Button.withSmallSize
                        |> Button.toMarkup
                    )
                , Toolbar.toolbarSeparator
                , Toolbar.toolbarGroup
                    [ Toolbar.toolbarItem
                        (Button.primary { label = "Create", onPress = Nothing }
                            |> Button.withSmallSize
                            |> Button.toMarkup
                        )
                    , Toolbar.toolbarItem
                        (Button.secondary { label = "Export", onPress = Nothing }
                            |> Button.withSmallSize
                            |> Button.toMarkup
                        )
                    ]
                ]
                |> Toolbar.withItemCount "4 items"
                |> Toolbar.withClearAll NoOp
                |> Toolbar.toMarkup
            ]

        -- TABLE
        , section theme
            "Table"
            [ Element.column [ Element.spacing Tokens.spacerSm, Element.width Element.fill ]
                [ let
                    baseTable =
                        Table.table
                            { columns =
                                [ Table.column
                                    { key = "name"
                                    , label = "Name"
                                    , view = \u -> Element.el [ Font.color (Theme.text theme) ] (Element.text u.name)
                                    }
                                , Table.column
                                    { key = "role"
                                    , label = "Role"
                                    , view = \u -> Element.el [ Font.color (Theme.textSubtle theme) ] (Element.text u.role)
                                    }
                                , Table.column
                                    { key = "status"
                                    , label = "Status"
                                    , view = \u -> statusLabel u.status
                                    }
                                , Table.column
                                    { key = "lastSeen"
                                    , label = "Last seen"
                                    , view = \u -> Element.el [ Font.color (Theme.textSubtle theme) ] (Element.text u.lastSeen)
                                    }
                                ]
                            , rows = sampleUsers
                            }
                            |> Table.withSortable
                            |> Table.withCaption "Users"

                    sortedTable =
                        case model.tableSort of
                            Just s ->
                                baseTable
                                    |> Table.withSortedBy
                                        { key = s.key
                                        , direction =
                                            if s.descending then
                                                Table.Descending

                                            else
                                                Table.Ascending
                                        }

                            Nothing ->
                                baseTable
                  in
                  sortedTable |> Table.toMarkup
                , Table.table
                    { columns =
                        [ Table.column
                            { key = "name"
                            , label = "Name"
                            , view = \u -> Element.el [ Font.color (Theme.text theme) ] (Element.text u.name)
                            }
                        , Table.column
                            { key = "role"
                            , label = "Role"
                            , view = \u -> Element.el [ Font.color (Theme.textSubtle theme) ] (Element.text u.role)
                            }
                        ]
                    , rows = sampleUsers
                    }
                    |> Table.withCompact
                    |> Table.withStriped
                    |> Table.withCaption "Compact striped"
                    |> Table.toMarkup
                ]
            ]

        -- DATA LIST
        , section theme
            "DataList"
            [ DataList.dataList
                (List.indexedMap
                    (\i u ->
                        DataList.item
                            [ DataList.cell (Element.el [ Font.bold, Font.color (Theme.text theme) ] (Element.text u.name))
                            , DataList.cell (Element.el [ Font.color (Theme.textSubtle theme) ] (Element.text u.role))
                            , DataList.cell (statusLabel u.status)
                            ]
                            |> DataList.withCheckable (\_ -> DataListCheckToggled i)
                            |> DataList.withChecked (List.member i model.dataListChecked)
                    )
                    sampleUsers
                )
                |> DataList.toMarkup
            ]
        ]
