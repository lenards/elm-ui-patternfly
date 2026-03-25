module Views.NavigationView exposing (view)

import Element exposing (Element)
import Element.Background as Bg
import Element.Border as Border
import Element.Font as Font
import PF6.Breadcrumb as Breadcrumb
import PF6.Pagination as Pagination
import PF6.Tabs as Tabs
import PF6.Theme as Theme exposing (Theme)
import PF6.Tokens as Tokens
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
            (Element.text "Navigation")

        -- BREADCRUMB
        , section theme
            "Breadcrumb"
            [ Breadcrumb.breadcrumb
                [ Breadcrumb.item { label = "Home", href = "#" }
                , Breadcrumb.item { label = "Section", href = "#" }
                , Breadcrumb.item { label = "Subsection", href = "#" }
                , Breadcrumb.currentItem "Current page"
                ]
                |> Breadcrumb.toMarkup theme
            ]

        -- TABS
        , section theme
            "Tabs"
            [ Element.column [ Element.spacing Tokens.spacerMd, Element.width Element.fill ]
                [ Tabs.tabs
                    { activeKey = model.activeTab
                    , onSelect = TabSelected
                    , tabs =
                        [ Tabs.tab "tab1" "Users"
                        , Tabs.tab "tab2" "Containers"
                        , Tabs.tab "tab3" "Database"
                        ]
                    }
                    |> Tabs.toMarkup theme
                , Tabs.tabs
                    { activeKey = model.activeBoxTab
                    , onSelect = BoxTabSelected
                    , tabs =
                        [ Tabs.tab "tab1" "Overview"
                        , Tabs.tab "tab2" "YAML"
                        , Tabs.tab "tab3" "JSON"
                        ]
                    }
                    |> Tabs.withBox
                    |> Tabs.toMarkup theme
                ]
            ]

        -- PAGINATION
        , section theme
            "Pagination"
            [ Element.column [ Element.spacing Tokens.spacerMd, Element.width Element.fill ]
                [ Pagination.pagination
                    { page = 1
                    , onPageChange = \_ -> NoOp
                    }
                    |> Pagination.withTotalItems 100
                    |> Pagination.toMarkup theme
                , Pagination.pagination
                    { page = 5
                    , onPageChange = \_ -> NoOp
                    }
                    |> Pagination.withTotalItems 200
                    |> Pagination.withPerPage 10
                    |> Pagination.toMarkup theme
                , Pagination.pagination
                    { page = 10
                    , onPageChange = \_ -> NoOp
                    }
                    |> Pagination.withTotalItems 100
                    |> Pagination.withCompact
                    |> Pagination.toMarkup theme
                ]
            ]
        ]
