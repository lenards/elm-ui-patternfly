module Pages.ToggleGroupPage exposing (view)

import Element exposing (Element)
import Element.Font as Font
import PF6.Card as Card
import PF6.Theme as Theme exposing (Theme)
import PF6.Title as Title
import PF6.ToggleGroup as ToggleGroup
import PF6.Tokens as Tokens


view :
    Theme
    ->
        { selected : String
        , onSelect : String -> msg
        }
    -> Element msg
view theme config =
    Element.column [ Element.width Element.fill, Element.spacing 24 ]
        [ Title.title "Toggle Group" |> Title.withH1 |> Title.toMarkup theme
        , Element.paragraph [ Font.size 14, Font.color (Theme.text theme) ]
            [ Element.text "Toggle groups allow users to select one or more options from a set of buttons." ]
        , exampleSection theme "Single select"
            (ToggleGroup.toggleGroup
                { items =
                    [ ToggleGroup.toggleItem { label = "Month", isSelected = config.selected == "month", onToggle = config.onSelect "month" }
                    , ToggleGroup.toggleItem { label = "Week", isSelected = config.selected == "week", onToggle = config.onSelect "week" }
                    , ToggleGroup.toggleItem { label = "Day", isSelected = config.selected == "day", onToggle = config.onSelect "day" }
                    ]
                }
                |> ToggleGroup.toMarkup theme
            )
        , exampleSection theme "Compact"
            (ToggleGroup.toggleGroup
                { items =
                    [ ToggleGroup.toggleItem { label = "List", isSelected = True, onToggle = config.onSelect "list" }
                    , ToggleGroup.toggleItem { label = "Grid", isSelected = False, onToggle = config.onSelect "grid" }
                    ]
                }
                |> ToggleGroup.withCompact
                |> ToggleGroup.toMarkup theme
            )
        ]


exampleSection : Theme -> String -> Element msg -> Element msg
exampleSection theme title content =
    Card.card [ content ]
        |> Card.withTitle title
        |> Card.toMarkup theme
