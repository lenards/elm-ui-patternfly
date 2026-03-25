module Pages.MenuPage exposing (view)

import Element exposing (Element)
import Element.Font as Font
import PF6.Card as Card
import PF6.Menu as Menu
import PF6.Theme as Theme exposing (Theme)
import PF6.Title as Title
import PF6.Tokens as Tokens


view : Theme -> msg -> Element msg
view theme noOp =
    Element.column [ Element.width Element.fill, Element.spacing 24 ]
        [ Title.title "Menu" |> Title.withH1 |> Title.toMarkup theme
        , Element.paragraph [ Font.size 14, Font.color (Theme.text theme) ]
            [ Element.text "Menus display a list of options for the user to choose from." ]
        , exampleSection theme "Basic menu"
            (Menu.menu
                [ Menu.menuItem "Action 1" noOp
                , Menu.menuItem "Action 2" noOp
                , Menu.menuItem "Action 3" noOp
                ]
                |> Menu.toMarkup theme
            )
        , exampleSection theme "With dividers and headers"
            (Menu.menu
                [ Menu.menuHeader "Group 1"
                , Menu.menuItem "Option A" noOp
                , Menu.menuItem "Option B" noOp
                , Menu.menuDivider
                , Menu.menuHeader "Group 2"
                , Menu.menuItem "Option C" noOp
                ]
                |> Menu.toMarkup theme
            )
        , exampleSection theme "With descriptions"
            (Menu.menu
                [ Menu.menuItem "Edit" noOp |> Menu.withItemDescription "Edit this item"
                , Menu.menuItem "Delete" noOp |> Menu.withItemDescription "Permanently delete" |> Menu.withItemDanger
                ]
                |> Menu.toMarkup theme
            )
        ]


exampleSection : Theme -> String -> Element msg -> Element msg
exampleSection theme title content =
    Card.card [ content ]
        |> Card.withTitle title
        |> Card.toMarkup theme
