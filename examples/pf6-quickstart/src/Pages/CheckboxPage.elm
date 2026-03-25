module Pages.CheckboxPage exposing (view)

import Element exposing (Element)
import Element.Font as Font
import PF6.Card as Card
import PF6.Checkbox as Checkbox
import PF6.Title as Title
import PF6.Tokens as Tokens


view :
    { checkboxChecked : Bool
    , onCheckboxToggle : Bool -> msg
    }
    -> Element msg
view config =
    Element.column [ Element.width Element.fill, Element.spacing 24 ]
        [ Title.title "Checkbox" |> Title.withH1 |> Title.toMarkup
        , Element.paragraph [ Font.size 14, Font.color Tokens.colorText ]
            [ Element.text "Checkboxes allow users to select one or more items from a list." ]
        , exampleSection "Basic checkbox"
            (Element.column [ Element.spacing 12 ]
                [ Checkbox.checkbox { id = "check-1", onChange = config.onCheckboxToggle }
                    |> Checkbox.withLabel "Default checkbox"
                    |> Checkbox.withChecked config.checkboxChecked
                    |> Checkbox.toMarkup
                , Checkbox.checkbox { id = "check-2", onChange = \_ -> config.onCheckboxToggle config.checkboxChecked }
                    |> Checkbox.withLabel "Checked checkbox"
                    |> Checkbox.withChecked True
                    |> Checkbox.toMarkup
                ]
            )
        , exampleSection "With description"
            (Checkbox.checkbox { id = "check-desc", onChange = config.onCheckboxToggle }
                |> Checkbox.withLabel "Checkbox with description"
                |> Checkbox.withDescription "This is a description of the checkbox option."
                |> Checkbox.withChecked config.checkboxChecked
                |> Checkbox.toMarkup
            )
        , exampleSection "Disabled"
            (Checkbox.checkbox { id = "check-disabled", onChange = \_ -> config.onCheckboxToggle config.checkboxChecked }
                |> Checkbox.withLabel "Disabled checkbox"
                |> Checkbox.withDisabled
                |> Checkbox.toMarkup
            )
        ]


exampleSection : String -> Element msg -> Element msg
exampleSection title content =
    Card.card [ content ]
        |> Card.withTitle title
        |> Card.toMarkup
