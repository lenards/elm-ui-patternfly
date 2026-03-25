module Pages.TitlePage exposing (view)

import Element exposing (Element)
import Element.Font as Font
import PF6.Card as Card
import PF6.Title as Title
import PF6.Tokens as Tokens


view : Element msg
view =
    Element.column [ Element.width Element.fill, Element.spacing 24 ]
        [ Title.title "Title" |> Title.withH1 |> Title.toMarkup
        , Element.paragraph [ Font.size 14, Font.color Tokens.colorText ]
            [ Element.text "Title components render heading text at different levels with appropriate sizing." ]
        , exampleSection "Heading levels"
            (Element.column [ Element.spacing 12 ]
                [ Title.title "Heading 1 (4xl)" |> Title.withH1 |> Title.toMarkup
                , Title.title "Heading 2 (3xl)" |> Title.withH2 |> Title.toMarkup
                , Title.title "Heading 3 (2xl)" |> Title.withH3 |> Title.toMarkup
                , Title.title "Heading 4 (xl)" |> Title.withH4 |> Title.toMarkup
                , Title.title "Heading 5 (lg)" |> Title.withH5 |> Title.toMarkup
                , Title.title "Heading 6 (md)" |> Title.withH6 |> Title.toMarkup
                ]
            )
        ]


exampleSection : String -> Element msg -> Element msg
exampleSection title content =
    Card.card [ content ]
        |> Card.withTitle title
        |> Card.toMarkup
