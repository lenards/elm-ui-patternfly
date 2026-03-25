module Pages.FormPage exposing (view)

import Element exposing (Element)
import Element.Font as Font
import PF6.Card as Card
import PF6.Checkbox as Checkbox
import PF6.Form as Form
import PF6.TextInput as TextInput
import PF6.Title as Title
import PF6.Tokens as Tokens


view :
    { formText : String
    , onTextChange : String -> msg
    , checkboxChecked : Bool
    , onCheckboxToggle : Bool -> msg
    }
    -> Element msg
view config =
    Element.column [ Element.width Element.fill, Element.spacing 24 ]
        [ Title.title "Form" |> Title.withH1 |> Title.toMarkup
        , Element.paragraph [ Font.size 14, Font.color Tokens.colorText ]
            [ Element.text "Forms collect, validate, and submit user input." ]
        , exampleSection "Basic form"
            (Form.form
                [ Form.formGroup
                    (TextInput.textInput
                        { value = config.formText
                        , onChange = config.onTextChange
                        }
                        |> TextInput.withPlaceholder "Enter your name"
                        |> TextInput.toMarkup
                    )
                    |> Form.withLabel "Full name"
                    |> Form.withRequired
                    |> Form.groupToMarkup
                , Form.formGroup
                    (TextInput.textInput
                        { value = ""
                        , onChange = \_ -> config.onTextChange config.formText
                        }
                        |> TextInput.withPlaceholder "you@example.com"
                        |> TextInput.withEmailType
                        |> TextInput.toMarkup
                    )
                    |> Form.withLabel "Email"
                    |> Form.withHelperText "We will never share your email."
                    |> Form.groupToMarkup
                , Form.formGroup
                    (Checkbox.checkbox
                        { id = "agree-checkbox"
                        , onChange = config.onCheckboxToggle
                        }
                        |> Checkbox.withChecked config.checkboxChecked
                        |> Checkbox.withLabel "I agree to the terms and conditions"
                        |> Checkbox.toMarkup
                    )
                    |> Form.groupToMarkup
                ]
                |> Form.toMarkup
            )
        , exampleSection "Horizontal form"
            (Form.form
                [ Form.formGroup
                    (TextInput.textInput
                        { value = config.formText
                        , onChange = config.onTextChange
                        }
                        |> TextInput.withPlaceholder "Username"
                        |> TextInput.toMarkup
                    )
                    |> Form.withLabel "Username"
                    |> Form.groupToMarkup
                ]
                |> Form.withHorizontal
                |> Form.toMarkup
            )
        ]


exampleSection : String -> Element msg -> Element msg
exampleSection title content =
    Card.card [ content ]
        |> Card.withTitle title
        |> Card.toMarkup
