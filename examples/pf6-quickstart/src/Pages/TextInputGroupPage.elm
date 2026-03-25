module Pages.TextInputGroupPage exposing (view)

import Element exposing (Element)
import Element.Font as Font
import PF6.Card as Card
import PF6.TextInputGroup as TextInputGroup
import PF6.Title as Title
import PF6.Tokens as Tokens


view :
    { value : String
    , onChange : String -> msg
    }
    -> Element msg
view config =
    Element.column [ Element.width Element.fill, Element.spacing 24 ]
        [ Title.title "Text Input Group" |> Title.withH1 |> Title.toMarkup
        , Element.paragraph [ Font.size 14, Font.color Tokens.colorText ]
            [ Element.text "Text input groups combine a text input with prefix/suffix elements." ]
        , exampleSection "Basic"
            (TextInputGroup.textInputGroup { value = config.value, onChange = config.onChange }
                |> TextInputGroup.withLabel "URL"
                |> TextInputGroup.withPlaceholder "example.com"
                |> TextInputGroup.toMarkup
            )
        , exampleSection "With prefix and suffix"
            (TextInputGroup.textInputGroup { value = config.value, onChange = config.onChange }
                |> TextInputGroup.withLabel "Website"
                |> TextInputGroup.withPrefix (Element.el [ Font.size 14, Font.color Tokens.colorTextSubtle ] (Element.text "https://"))
                |> TextInputGroup.withSuffix (Element.el [ Font.size 14, Font.color Tokens.colorTextSubtle ] (Element.text ".com"))
                |> TextInputGroup.withPlaceholder "domain"
                |> TextInputGroup.toMarkup
            )
        ]


exampleSection : String -> Element msg -> Element msg
exampleSection title content =
    Card.card [ content ]
        |> Card.withTitle title
        |> Card.toMarkup
