module Pages.HelperTextPage exposing (view)

import Element exposing (Element)
import Element.Font as Font
import PF6.Card as Card
import PF6.HelperText as HelperText
import PF6.Theme as Theme exposing (Theme)
import PF6.Title as Title
import PF6.Tokens as Tokens


view : Theme -> Element msg
view theme =
    Element.column [ Element.width Element.fill, Element.spacing 24 ]
        [ Title.title "Helper Text" |> Title.withH1 |> Title.toMarkup theme
        , Element.paragraph [ Font.size 14, Font.color (Theme.text theme) ]
            [ Element.text "Helper text provides contextual information below form controls." ]
        , exampleSection theme "Variants"
            (Element.column [ Element.spacing 12, Element.width Element.fill ]
                [ HelperText.helperText "Default helper text" |> HelperText.withDefault |> HelperText.toMarkup theme
                , HelperText.helperText "Success! Everything looks good." |> HelperText.withSuccess |> HelperText.toMarkup theme
                , HelperText.helperText "Warning: this action may have consequences." |> HelperText.withWarning |> HelperText.toMarkup theme
                , HelperText.helperText "Error: please fix this field." |> HelperText.withError |> HelperText.toMarkup theme
                ]
            )
        , exampleSection theme "Indeterminate"
            (HelperText.helperText "Checking requirements..."
                |> HelperText.withIndeterminate
                |> HelperText.toMarkup theme
            )
        ]


exampleSection : Theme -> String -> Element msg -> Element msg
exampleSection theme title content =
    Card.card [ content ]
        |> Card.withTitle title
        |> Card.toMarkup theme
