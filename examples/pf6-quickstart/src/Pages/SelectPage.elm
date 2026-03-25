module Pages.SelectPage exposing (view)

import Element exposing (Element)
import Element.Font as Font
import PF6.Card as Card
import PF6.Select as Select
import PF6.Title as Title
import PF6.Tokens as Tokens


view :
    { selectOpen : Bool
    , selectValue : Maybe String
    , onSelectToggle : Bool -> msg
    , onSelectChange : String -> msg
    }
    -> Element msg
view config =
    Element.column [ Element.width Element.fill, Element.spacing 24 ]
        [ Title.title "Select" |> Title.withH1 |> Title.toMarkup
        , Element.paragraph [ Font.size 14, Font.color Tokens.colorText ]
            [ Element.text "Select menus let users choose from a list of options." ]
        , exampleSection "Basic select"
            (Select.select
                { isOpen = config.selectOpen
                , selected = config.selectValue
                , onToggle = config.onSelectToggle
                , onSelect = config.onSelectChange
                , options =
                    [ Select.option "opt1" "Option 1"
                    , Select.option "opt2" "Option 2"
                    , Select.option "opt3" "Option 3"
                    ]
                }
                |> Select.withPlaceholder "Choose an option"
                |> Select.withLabel "Favorite"
                |> Select.toMarkup
            )
        , exampleSection "With helper text"
            (Select.select
                { isOpen = False
                , selected = Nothing
                , onToggle = config.onSelectToggle
                , onSelect = config.onSelectChange
                , options =
                    [ Select.option "sm" "Small"
                    , Select.option "md" "Medium"
                    , Select.option "lg" "Large"
                    ]
                }
                |> Select.withPlaceholder "Select size"
                |> Select.withLabel "Size"
                |> Select.withHelperText "Choose the deployment size"
                |> Select.toMarkup
            )
        ]


exampleSection : String -> Element msg -> Element msg
exampleSection title content =
    Card.card [ content ]
        |> Card.withTitle title
        |> Card.toMarkup
