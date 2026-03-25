module Pages.NumberInputPage exposing (view)

import Element exposing (Element)
import Element.Font as Font
import PF6.Card as Card
import PF6.NumberInput as NumberInput
import PF6.Title as Title
import PF6.Tokens as Tokens


view :
    { numberValue : Float
    , onNumberChange : Float -> msg
    }
    -> Element msg
view config =
    Element.column [ Element.width Element.fill, Element.spacing 24 ]
        [ Title.title "Number Input" |> Title.withH1 |> Title.toMarkup
        , Element.paragraph [ Font.size 14, Font.color Tokens.colorText ]
            [ Element.text "Number inputs allow users to input and adjust numeric values with increment/decrement buttons." ]
        , exampleSection "Basic"
            (NumberInput.numberInput { value = config.numberValue, onChange = config.onNumberChange }
                |> NumberInput.withLabel "Quantity"
                |> NumberInput.toMarkup
            )
        , exampleSection "With min, max, and step"
            (NumberInput.numberInput { value = config.numberValue, onChange = config.onNumberChange }
                |> NumberInput.withLabel "Percentage"
                |> NumberInput.withMin 0
                |> NumberInput.withMax 100
                |> NumberInput.withStep 5
                |> NumberInput.withUnit "%"
                |> NumberInput.toMarkup
            )
        , exampleSection "Disabled"
            (NumberInput.numberInput { value = 42, onChange = config.onNumberChange }
                |> NumberInput.withLabel "Fixed value"
                |> NumberInput.withDisabled
                |> NumberInput.toMarkup
            )
        ]


exampleSection : String -> Element msg -> Element msg
exampleSection title content =
    Card.card [ content ]
        |> Card.withTitle title
        |> Card.toMarkup
