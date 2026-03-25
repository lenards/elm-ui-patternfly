module Pages.FormPage exposing (view)

import Element exposing (Element)
import Element.Font as Font
import PF6.Card as Card
import PF6.Checkbox as Checkbox
import PF6.Form as Form
import PF6.TextInput as TextInput
import PF6.Theme as Theme exposing (Theme)
import PF6.Title as Title
import PF6.Tokens as Tokens


view :
    Theme
    ->
        { formText : String
        , onTextChange : String -> msg
        , checkboxChecked : Bool
        , onCheckboxToggle : Bool -> msg
        }
    -> Element msg
view theme config =
    Element.column [ Element.width Element.fill, Element.spacing 24 ]
        [ Title.title "Form" |> Title.withH1 |> Title.toMarkup theme
        , Element.paragraph [ Font.size 14, Font.color (Theme.text theme) ]
            [ Element.text "Forms collect, validate, and submit user input." ]
        , exampleSection theme "Basic form"
            (Form.form
                [ Form.formGroup
                    (TextInput.textInput
                        { value = config.formText
                        , onChange = config.onTextChange
                        }
                        |> TextInput.withPlaceholder "Enter your name"
                        |> TextInput.toMarkup theme
                    )
                    |> Form.withLabel "Full name"
                    |> Form.withRequired
                    |> Form.groupToMarkup theme
                , Form.formGroup
                    (TextInput.textInput
                        { value = ""
                        , onChange = \_ -> config.onTextChange config.formText
                        }
                        |> TextInput.withPlaceholder "you@example.com"
                        |> TextInput.withEmailType
                        |> TextInput.toMarkup theme
                    )
                    |> Form.withLabel "Email"
                    |> Form.withHelperText "We will never share your email."
                    |> Form.groupToMarkup theme
                , Form.formGroup
                    (Checkbox.checkbox
                        { id = "agree-checkbox"
                        , onChange = config.onCheckboxToggle
                        }
                        |> Checkbox.withChecked config.checkboxChecked
                        |> Checkbox.withLabel "I agree to the terms and conditions"
                        |> Checkbox.toMarkup theme
                    )
                    |> Form.groupToMarkup theme
                ]
                |> Form.toMarkup theme
            )
        , exampleSection theme "Horizontal form"
            (Form.form
                [ Form.formGroup
                    (TextInput.textInput
                        { value = config.formText
                        , onChange = config.onTextChange
                        }
                        |> TextInput.withPlaceholder "Username"
                        |> TextInput.toMarkup theme
                    )
                    |> Form.withLabel "Username"
                    |> Form.groupToMarkup theme
                ]
                |> Form.withHorizontal
                |> Form.toMarkup theme
            )
        ]


exampleSection : Theme -> String -> Element msg -> Element msg
exampleSection theme title content =
    Card.card [ content ]
        |> Card.withTitle title
        |> Card.toMarkup theme
