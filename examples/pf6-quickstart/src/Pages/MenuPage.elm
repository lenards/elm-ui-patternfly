module Pages.MenuPage exposing (view)

import Element exposing (Element)
import Element.Font as Font
import PF6.Card as Card
import PF6.Menu as Menu
import PF6.Title as Title
import PF6.Tokens as Tokens


view : msg -> Element msg
view noOp =
    Element.column [ Element.width Element.fill, Element.spacing 24 ]
        [ Title.title "Menu" |> Title.withH1 |> Title.toMarkup
        , Element.paragraph [ Font.size 14, Font.color Tokens.colorText ]
            [ Element.text "Menus display a list of options for the user to choose from." ]
        , exampleSection "Basic menu"
            (Menu.menu
                [ Menu.menuItem "Action 1" noOp
                , Menu.menuItem "Action 2" noOp
                , Menu.menuItem "Action 3" noOp
                ]
                |> Menu.toMarkup
            )
        , exampleSection "With dividers and headers"
            (Menu.menu
                [ Menu.menuHeader "Group 1"
                , Menu.menuItem "Option A" noOp
                , Menu.menuItem "Option B" noOp
                , Menu.menuDivider
                , Menu.menuHeader "Group 2"
                , Menu.menuItem "Option C" noOp
                ]
                |> Menu.toMarkup
            )
        , exampleSection "With descriptions"
            (Menu.menu
                [ Menu.menuItem "Edit" noOp |> Menu.withItemDescription "Edit this item"
                , Menu.menuItem "Delete" noOp |> Menu.withItemDescription "Permanently delete" |> Menu.withItemDanger
                ]
                |> Menu.toMarkup
            )
        ]


exampleSection : String -> Element msg -> Element msg
exampleSection title content =
    Card.card [ content ]
        |> Card.withTitle title
        |> Card.toMarkup
