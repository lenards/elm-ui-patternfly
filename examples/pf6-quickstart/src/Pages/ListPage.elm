module Pages.ListPage exposing (view)

import Element exposing (Element)
import Element.Font as Font
import PF6.Card as Card
import PF6.List as PFList
import PF6.Title as Title
import PF6.Tokens as Tokens


view : Element msg
view =
    Element.column [ Element.width Element.fill, Element.spacing 24 ]
        [ Title.title "List" |> Title.withH1 |> Title.toMarkup
        , Element.paragraph [ Font.size 14, Font.color Tokens.colorText ]
            [ Element.text "Lists render content in an ordered or unordered format." ]
        , exampleSection "Unordered list"
            (PFList.pFList
                [ Element.text "First item"
                , Element.text "Second item"
                , Element.text "Third item"
                ]
                |> PFList.toMarkup
            )
        , exampleSection "Ordered list"
            (PFList.pFList
                [ Element.text "Step one"
                , Element.text "Step two"
                , Element.text "Step three"
                ]
                |> PFList.withOrdered
                |> PFList.toMarkup
            )
        , exampleSection "Plain list"
            (PFList.pFList
                [ Element.text "No bullet item"
                , Element.text "Another plain item"
                , Element.text "Final plain item"
                ]
                |> PFList.withPlain
                |> PFList.toMarkup
            )
        ]


exampleSection : String -> Element msg -> Element msg
exampleSection title content =
    Card.card [ content ]
        |> Card.withTitle title
        |> Card.toMarkup
