module Pages.DropdownPage exposing (view)

import Element exposing (Element)
import Element.Font as Font
import PF6.Card as Card
import PF6.Dropdown as Dropdown
import PF6.Theme as Theme exposing (Theme)
import PF6.Title as Title
import PF6.Tokens as Tokens


view :
    Theme
    ->
        { dropdownOpen : Bool
        , onToggle : Bool -> msg
        , noOp : msg
        }
    -> Element msg
view theme config =
    Element.column [ Element.width Element.fill, Element.spacing 24 ]
        [ Title.title "Dropdown" |> Title.withH1 |> Title.toMarkup theme
        , Element.paragraph [ Font.size 14, Font.color (Theme.text theme) ]
            [ Element.text "Dropdowns present a list of actions or links in a constrained space." ]
        , exampleSection theme "Basic dropdown"
            (Dropdown.dropdown
                { toggleLabel = "Actions"
                , isOpen = config.dropdownOpen
                , onToggle = config.onToggle
                , items =
                    [ Dropdown.dropdownItem "Edit" config.noOp
                    , Dropdown.dropdownItem "Clone" config.noOp
                    , Dropdown.dropdownDivider
                    , Dropdown.dropdownItem "Delete" config.noOp
                    ]
                }
                |> Dropdown.toMarkup theme
            )
        , exampleSection theme "Dropdown with header"
            (Dropdown.dropdown
                { toggleLabel = "Options"
                , isOpen = False
                , onToggle = config.onToggle
                , items =
                    [ Dropdown.dropdownHeader "Group 1"
                    , Dropdown.dropdownItem "Option A" config.noOp
                    , Dropdown.dropdownItem "Option B" config.noOp
                    , Dropdown.dropdownDivider
                    , Dropdown.dropdownHeader "Group 2"
                    , Dropdown.dropdownItem "Option C" config.noOp
                    ]
                }
                |> Dropdown.toMarkup theme
            )
        ]


exampleSection : Theme -> String -> Element msg -> Element msg
exampleSection theme title content =
    Card.card [ content ]
        |> Card.withTitle title
        |> Card.toMarkup theme
