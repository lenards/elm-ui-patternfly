module Pages.ListPage exposing (view)

import Element exposing (Element)
import Element.Font as Font
import PF6.Card as Card
import PF6.List as PFList
import PF6.Theme as Theme exposing (Theme)
import PF6.Title as Title
import PF6.Tokens as Tokens


view : Theme -> Element msg
view theme =
    Element.column [ Element.width Element.fill, Element.spacing 24 ]
        [ Title.title "List" |> Title.withH1 |> Title.toMarkup theme
        , Element.paragraph [ Font.size 14, Font.color (Theme.text theme) ]
            [ Element.text "Lists render content in an ordered or unordered format." ]
        , exampleSection theme "Unordered list"
            (PFList.pFList
                [ Element.text "First item"
                , Element.text "Second item"
                , Element.text "Third item"
                ]
                |> PFList.toMarkup theme
            )
        , exampleSection theme "Ordered list"
            (PFList.pFList
                [ Element.text "Step one"
                , Element.text "Step two"
                , Element.text "Step three"
                ]
                |> PFList.withOrdered
                |> PFList.toMarkup theme
            )
        , exampleSection theme "Plain list"
            (PFList.pFList
                [ Element.text "No bullet item"
                , Element.text "Another plain item"
                , Element.text "Final plain item"
                ]
                |> PFList.withPlain
                |> PFList.toMarkup theme
            )
        ]


exampleSection : Theme -> String -> Element msg -> Element msg
exampleSection theme title content =
    Card.card [ content ]
        |> Card.withTitle title
        |> Card.toMarkup theme
