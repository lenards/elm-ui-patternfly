module Pages.DropdownPage exposing (view)

import Element exposing (Element)
import Element.Font as Font
import PF6.Card as Card
import PF6.Dropdown as Dropdown
import PF6.Title as Title
import PF6.Tokens as Tokens


view :
    { dropdownOpen : Bool
    , onToggle : Bool -> msg
    , noOp : msg
    }
    -> Element msg
view config =
    Element.column [ Element.width Element.fill, Element.spacing 24 ]
        [ Title.title "Dropdown" |> Title.withH1 |> Title.toMarkup
        , Element.paragraph [ Font.size 14, Font.color Tokens.colorText ]
            [ Element.text "Dropdowns present a list of actions or links in a constrained space." ]
        , exampleSection "Basic dropdown"
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
                |> Dropdown.toMarkup
            )
        , exampleSection "Dropdown with header"
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
                |> Dropdown.toMarkup
            )
        ]


exampleSection : String -> Element msg -> Element msg
exampleSection title content =
    Card.card [ content ]
        |> Card.withTitle title
        |> Card.toMarkup
