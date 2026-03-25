module Pages.TabsPage exposing (view)

import Element exposing (Element)
import Element.Font as Font
import PF6.Card as Card
import PF6.Tabs as Tabs
import PF6.Title as Title
import PF6.Tokens as Tokens


view : { activeTab : String, onTabSelect : String -> msg } -> Element msg
view config =
    Element.column [ Element.width Element.fill, Element.spacing 24 ]
        [ Title.title "Tabs" |> Title.withH1 |> Title.toMarkup
        , Element.paragraph [ Font.size 14, Font.color Tokens.colorText ]
            [ Element.text "Tabs allow users to navigate between views within the same context." ]
        , exampleSection "Default tabs"
            (Element.column [ Element.width Element.fill, Element.spacing 16 ]
                [ Tabs.tabs
                    { activeKey = config.activeTab
                    , onSelect = config.onTabSelect
                    , tabs =
                        [ Tabs.tab "tab1" "Users"
                        , Tabs.tab "tab2" "Containers"
                        , Tabs.tab "tab3" "Database"
                        ]
                    }
                    |> Tabs.toMarkup
                , Element.paragraph [ Font.size 14 ]
                    [ Element.text ("Active tab: " ++ config.activeTab) ]
                ]
            )
        , exampleSection "Box tabs"
            (Tabs.tabs
                { activeKey = config.activeTab
                , onSelect = config.onTabSelect
                , tabs =
                    [ Tabs.tab "tab1" "Users"
                    , Tabs.tab "tab2" "Containers"
                    , Tabs.tab "tab3" "Database"
                    ]
                }
                |> Tabs.withBox
                |> Tabs.toMarkup
            )
        , exampleSection "Filled tabs"
            (Tabs.tabs
                { activeKey = config.activeTab
                , onSelect = config.onTabSelect
                , tabs =
                    [ Tabs.tab "tab1" "Users"
                    , Tabs.tab "tab2" "Containers"
                    , Tabs.tab "tab3" "Database"
                    ]
                }
                |> Tabs.withFilled
                |> Tabs.toMarkup
            )
        ]


exampleSection : String -> Element msg -> Element msg
exampleSection title content =
    Card.card [ content ]
        |> Card.withTitle title
        |> Card.toMarkup
