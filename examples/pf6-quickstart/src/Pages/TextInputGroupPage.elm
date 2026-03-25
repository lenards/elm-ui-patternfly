module Pages.TextInputGroupPage exposing (view)

import Element exposing (Element)
import Element.Font as Font
import PF6.Card as Card
import PF6.TextInputGroup as TextInputGroup
import PF6.Theme as Theme exposing (Theme)
import PF6.Title as Title
import PF6.Tokens as Tokens


view :
    Theme
    ->
        { value : String
        , onChange : String -> msg
        }
    -> Element msg
view theme config =
    Element.column [ Element.width Element.fill, Element.spacing 24 ]
        [ Title.title "Text Input Group" |> Title.withH1 |> Title.toMarkup theme
        , Element.paragraph [ Font.size 14, Font.color (Theme.text theme) ]
            [ Element.text "Text input groups combine a text input with prefix/suffix elements." ]
        , exampleSection theme "Basic"
            (TextInputGroup.textInputGroup { value = config.value, onChange = config.onChange }
                |> TextInputGroup.withLabel "URL"
                |> TextInputGroup.withPlaceholder "example.com"
                |> TextInputGroup.toMarkup theme
            )
        , exampleSection theme "With prefix and suffix"
            (TextInputGroup.textInputGroup { value = config.value, onChange = config.onChange }
                |> TextInputGroup.withLabel "Website"
                |> TextInputGroup.withPrefix (Element.el [ Font.size 14, Font.color (Theme.textSubtle theme) ] (Element.text "https://"))
                |> TextInputGroup.withSuffix (Element.el [ Font.size 14, Font.color (Theme.textSubtle theme) ] (Element.text ".com"))
                |> TextInputGroup.withPlaceholder "domain"
                |> TextInputGroup.toMarkup theme
            )
        ]


exampleSection : Theme -> String -> Element msg -> Element msg
exampleSection theme title content =
    Card.card [ content ]
        |> Card.withTitle title
        |> Card.toMarkup theme
