module Pages.TitlePage exposing (view)

import Element exposing (Element)
import Element.Font as Font
import PF6.Card as Card
import PF6.Theme as Theme exposing (Theme)
import PF6.Title as Title
import PF6.Tokens as Tokens


view : Theme -> Element msg
view theme =
    Element.column [ Element.width Element.fill, Element.spacing 24 ]
        [ Title.title "Title" |> Title.withH1 |> Title.toMarkup theme
        , Element.paragraph [ Font.size 14, Font.color (Theme.text theme) ]
            [ Element.text "Title components render heading text at different levels with appropriate sizing." ]
        , exampleSection theme "Heading levels"
            (Element.column [ Element.spacing 12 ]
                [ Title.title "Heading 1 (4xl)" |> Title.withH1 |> Title.toMarkup theme
                , Title.title "Heading 2 (3xl)" |> Title.withH2 |> Title.toMarkup theme
                , Title.title "Heading 3 (2xl)" |> Title.withH3 |> Title.toMarkup theme
                , Title.title "Heading 4 (xl)" |> Title.withH4 |> Title.toMarkup theme
                , Title.title "Heading 5 (lg)" |> Title.withH5 |> Title.toMarkup theme
                , Title.title "Heading 6 (md)" |> Title.withH6 |> Title.toMarkup theme
                ]
            )
        ]


exampleSection : Theme -> String -> Element msg -> Element msg
exampleSection theme title content =
    Card.card [ content ]
        |> Card.withTitle title
        |> Card.toMarkup theme
