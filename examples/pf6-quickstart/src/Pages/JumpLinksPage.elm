module Pages.JumpLinksPage exposing (view)

import Element exposing (Element)
import Element.Font as Font
import PF6.Card as Card
import PF6.JumpLinks as JumpLinks
import PF6.Title as Title
import PF6.Tokens as Tokens


view : Element msg
view =
    Element.column [ Element.width Element.fill, Element.spacing 24 ]
        [ Title.title "Jump Links" |> Title.withH1 |> Title.toMarkup
        , Element.paragraph [ Font.size 14, Font.color Tokens.colorText ]
            [ Element.text "Jump links provide anchor navigation within a page, typically displayed as a table of contents." ]
        , exampleSection "Horizontal jump links"
            (JumpLinks.jumpLinks
                [ JumpLinks.link "Overview" "#overview"
                , JumpLinks.link "Getting started" "#getting-started"
                , JumpLinks.link "Configuration" "#configuration"
                , JumpLinks.link "Examples" "#examples"
                ]
                |> JumpLinks.toMarkup
            )
        , exampleSection "Vertical with label"
            (JumpLinks.jumpLinks
                [ JumpLinks.link "Section 1" "#section-1"
                , JumpLinks.link "Section 2" "#section-2"
                , JumpLinks.link "Section 3" "#section-3"
                ]
                |> JumpLinks.withVertical
                |> JumpLinks.withLabel "Table of contents"
                |> JumpLinks.toMarkup
            )
        ]


exampleSection : String -> Element msg -> Element msg
exampleSection title content =
    Card.card [ content ]
        |> Card.withTitle title
        |> Card.toMarkup
