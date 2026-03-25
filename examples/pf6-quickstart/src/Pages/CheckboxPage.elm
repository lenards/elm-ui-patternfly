module Pages.CheckboxPage exposing (view)

import Element exposing (Element)
import Element.Font as Font
import PF6.Card as Card
import PF6.Checkbox as Checkbox
import PF6.Theme as Theme exposing (Theme)
import PF6.Title as Title
import PF6.Tokens as Tokens


view :
    Theme
    ->
        { checkboxChecked : Bool
        , onCheckboxToggle : Bool -> msg
        }
    -> Element msg
view theme config =
    Element.column [ Element.width Element.fill, Element.spacing 24 ]
        [ Title.title "Checkbox" |> Title.withH1 |> Title.toMarkup theme
        , Element.paragraph [ Font.size 14, Font.color (Theme.text theme) ]
            [ Element.text "Checkboxes allow users to select one or more items from a list." ]
        , exampleSection theme "Basic checkbox"
            (Element.column [ Element.spacing 12 ]
                [ Checkbox.checkbox { id = "check-1", onChange = config.onCheckboxToggle }
                    |> Checkbox.withLabel "Default checkbox"
                    |> Checkbox.withChecked config.checkboxChecked
                    |> Checkbox.toMarkup theme
                , Checkbox.checkbox { id = "check-2", onChange = \_ -> config.onCheckboxToggle config.checkboxChecked }
                    |> Checkbox.withLabel "Checked checkbox"
                    |> Checkbox.withChecked True
                    |> Checkbox.toMarkup theme
                ]
            )
        , exampleSection theme "With description"
            (Checkbox.checkbox { id = "check-desc", onChange = config.onCheckboxToggle }
                |> Checkbox.withLabel "Checkbox with description"
                |> Checkbox.withDescription "This is a description of the checkbox option."
                |> Checkbox.withChecked config.checkboxChecked
                |> Checkbox.toMarkup theme
            )
        , exampleSection theme "Disabled"
            (Checkbox.checkbox { id = "check-disabled", onChange = \_ -> config.onCheckboxToggle config.checkboxChecked }
                |> Checkbox.withLabel "Disabled checkbox"
                |> Checkbox.withDisabled
                |> Checkbox.toMarkup theme
            )
        ]


exampleSection : Theme -> String -> Element msg -> Element msg
exampleSection theme title content =
    Card.card [ content ]
        |> Card.withTitle title
        |> Card.toMarkup theme
