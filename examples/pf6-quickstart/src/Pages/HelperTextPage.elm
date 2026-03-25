module Pages.HelperTextPage exposing (view)

import Element exposing (Element)
import Element.Font as Font
import PF6.Card as Card
import PF6.HelperText as HelperText
import PF6.Title as Title
import PF6.Tokens as Tokens


view : Element msg
view =
    Element.column [ Element.width Element.fill, Element.spacing 24 ]
        [ Title.title "Helper Text" |> Title.withH1 |> Title.toMarkup
        , Element.paragraph [ Font.size 14, Font.color Tokens.colorText ]
            [ Element.text "Helper text provides contextual information below form controls." ]
        , exampleSection "Variants"
            (Element.column [ Element.spacing 12, Element.width Element.fill ]
                [ HelperText.helperText "Default helper text" |> HelperText.withDefault |> HelperText.toMarkup
                , HelperText.helperText "Success! Everything looks good." |> HelperText.withSuccess |> HelperText.toMarkup
                , HelperText.helperText "Warning: this action may have consequences." |> HelperText.withWarning |> HelperText.toMarkup
                , HelperText.helperText "Error: please fix this field." |> HelperText.withError |> HelperText.toMarkup
                ]
            )
        , exampleSection "Indeterminate"
            (HelperText.helperText "Checking requirements..."
                |> HelperText.withIndeterminate
                |> HelperText.toMarkup
            )
        ]


exampleSection : String -> Element msg -> Element msg
exampleSection title content =
    Card.card [ content ]
        |> Card.withTitle title
        |> Card.toMarkup
