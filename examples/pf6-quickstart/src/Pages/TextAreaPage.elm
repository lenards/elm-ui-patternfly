module Pages.TextAreaPage exposing (view)

import Element exposing (Element)
import Element.Font as Font
import PF6.Card as Card
import PF6.TextArea as TextArea
import PF6.Title as Title
import PF6.Tokens as Tokens


view :
    { textAreaValue : String
    , onTextAreaChange : String -> msg
    }
    -> Element msg
view config =
    Element.column [ Element.width Element.fill, Element.spacing 24 ]
        [ Title.title "Text Area" |> Title.withH1 |> Title.toMarkup
        , Element.paragraph [ Font.size 14, Font.color Tokens.colorText ]
            [ Element.text "Text areas allow users to enter multi-line text." ]
        , exampleSection "Basic text area"
            (TextArea.textArea { value = config.textAreaValue, onChange = config.onTextAreaChange }
                |> TextArea.withLabel "Description"
                |> TextArea.withPlaceholder "Enter a description..."
                |> TextArea.withRows 4
                |> TextArea.toMarkup
            )
        , exampleSection "Required with helper text"
            (TextArea.textArea { value = config.textAreaValue, onChange = config.onTextAreaChange }
                |> TextArea.withLabel "Comments"
                |> TextArea.withRequired
                |> TextArea.withHelperText "Please provide your feedback"
                |> TextArea.withRows 3
                |> TextArea.toMarkup
            )
        , exampleSection "Disabled"
            (TextArea.textArea { value = "Read-only content", onChange = config.onTextAreaChange }
                |> TextArea.withLabel "Notes"
                |> TextArea.withDisabled
                |> TextArea.toMarkup
            )
        ]


exampleSection : String -> Element msg -> Element msg
exampleSection title content =
    Card.card [ content ]
        |> Card.withTitle title
        |> Card.toMarkup
