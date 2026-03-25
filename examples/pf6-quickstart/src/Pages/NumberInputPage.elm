module Pages.NumberInputPage exposing (view)

import Element exposing (Element)
import Element.Font as Font
import PF6.Card as Card
import PF6.NumberInput as NumberInput
import PF6.Theme as Theme exposing (Theme)
import PF6.Title as Title
import PF6.Tokens as Tokens


view :
    Theme
    ->
        { numberValue : Float
        , onNumberChange : Float -> msg
        }
    -> Element msg
view theme config =
    Element.column [ Element.width Element.fill, Element.spacing 24 ]
        [ Title.title "Number Input" |> Title.withH1 |> Title.toMarkup theme
        , Element.paragraph [ Font.size 14, Font.color (Theme.text theme) ]
            [ Element.text "Number inputs allow users to input and adjust numeric values with increment/decrement buttons." ]
        , exampleSection theme "Basic"
            (NumberInput.numberInput { value = config.numberValue, onChange = config.onNumberChange }
                |> NumberInput.withLabel "Quantity"
                |> NumberInput.toMarkup theme
            )
        , exampleSection theme "With min, max, and step"
            (NumberInput.numberInput { value = config.numberValue, onChange = config.onNumberChange }
                |> NumberInput.withLabel "Percentage"
                |> NumberInput.withMin 0
                |> NumberInput.withMax 100
                |> NumberInput.withStep 5
                |> NumberInput.withUnit "%"
                |> NumberInput.toMarkup theme
            )
        , exampleSection theme "Disabled"
            (NumberInput.numberInput { value = 42, onChange = config.onNumberChange }
                |> NumberInput.withLabel "Fixed value"
                |> NumberInput.withDisabled
                |> NumberInput.toMarkup theme
            )
        ]


exampleSection : Theme -> String -> Element msg -> Element msg
exampleSection theme title content =
    Card.card [ content ]
        |> Card.withTitle title
        |> Card.toMarkup theme
