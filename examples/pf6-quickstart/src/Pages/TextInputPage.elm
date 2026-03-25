module Pages.TextInputPage exposing (view)

import Element exposing (Element)
import Element.Font as Font
import PF6.Card as Card
import PF6.TextInput as TextInput
import PF6.Theme as Theme exposing (Theme)
import PF6.Title as Title
import PF6.Tokens as Tokens


view :
    Theme
    ->
        { textInputValue : String
        , onTextInputChange : String -> msg
        }
    -> Element msg
view theme config =
    Element.column [ Element.width Element.fill, Element.spacing 24 ]
        [ Title.title "Text Input" |> Title.withH1 |> Title.toMarkup theme
        , Element.paragraph [ Font.size 14, Font.color (Theme.text theme) ]
            [ Element.text "Text inputs allow users to enter a single line of text." ]
        , exampleSection theme "Basic"
            (TextInput.textInput { value = config.textInputValue, onChange = config.onTextInputChange }
                |> TextInput.withLabel "Name"
                |> TextInput.withPlaceholder "Enter your name"
                |> TextInput.toMarkup theme
            )
        , exampleSection theme "Input types"
            (Element.column [ Element.spacing 12, Element.width Element.fill ]
                [ TextInput.textInput { value = "", onChange = config.onTextInputChange }
                    |> TextInput.withLabel "Email"
                    |> TextInput.withEmailType
                    |> TextInput.withPlaceholder "you@example.com"
                    |> TextInput.toMarkup theme
                , TextInput.textInput { value = "", onChange = config.onTextInputChange }
                    |> TextInput.withLabel "Password"
                    |> TextInput.withPasswordType
                    |> TextInput.withPlaceholder "Enter password"
                    |> TextInput.toMarkup theme
                ]
            )
        , exampleSection theme "Validation states"
            (Element.column [ Element.spacing 12, Element.width Element.fill ]
                [ TextInput.textInput { value = "Valid input", onChange = config.onTextInputChange }
                    |> TextInput.withLabel "Success"
                    |> TextInput.withSuccess
                    |> TextInput.withHelperText "Looks good!"
                    |> TextInput.toMarkup theme
                , TextInput.textInput { value = "", onChange = config.onTextInputChange }
                    |> TextInput.withLabel "Error"
                    |> TextInput.withDanger
                    |> TextInput.withHelperText "This field is required"
                    |> TextInput.toMarkup theme
                ]
            )
        , exampleSection theme "Disabled and read-only"
            (Element.column [ Element.spacing 12, Element.width Element.fill ]
                [ TextInput.textInput { value = "Disabled value", onChange = config.onTextInputChange }
                    |> TextInput.withLabel "Disabled"
                    |> TextInput.withDisabled
                    |> TextInput.toMarkup theme
                , TextInput.textInput { value = "Read-only value", onChange = config.onTextInputChange }
                    |> TextInput.withLabel "Read only"
                    |> TextInput.withReadOnly
                    |> TextInput.toMarkup theme
                ]
            )
        ]


exampleSection : Theme -> String -> Element msg -> Element msg
exampleSection theme title content =
    Card.card [ content ]
        |> Card.withTitle title
        |> Card.toMarkup theme
