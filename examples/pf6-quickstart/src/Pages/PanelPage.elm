module Pages.PanelPage exposing (view)

import Element exposing (Element)
import Element.Font as Font
import PF6.Card as Card
import PF6.Panel as Panel
import PF6.Title as Title
import PF6.Tokens as Tokens


view : Element msg
view =
    Element.column [ Element.width Element.fill, Element.spacing 24 ]
        [ Title.title "Panel" |> Title.withH1 |> Title.toMarkup
        , Element.paragraph [ Font.size 14, Font.color Tokens.colorText ]
            [ Element.text "A panel is a container with optional header and footer, used to group content." ]
        , exampleSection "Basic panel"
            (Panel.panel (Element.paragraph [ Font.size 14 ] [ Element.text "Panel body content goes here." ])
                |> Panel.toMarkup
            )
        , exampleSection "With header and footer"
            (Panel.panel (Element.paragraph [ Font.size 14 ] [ Element.text "This is the main body of the panel." ])
                |> Panel.withHeader (Element.el [ Font.bold, Font.size 14 ] (Element.text "Panel Header"))
                |> Panel.withFooter (Element.el [ Font.size 12, Font.color Tokens.colorTextSubtle ] (Element.text "Panel footer"))
                |> Panel.toMarkup
            )
        , exampleSection "Raised panel"
            (Panel.panel (Element.paragraph [ Font.size 14 ] [ Element.text "This panel has a raised shadow." ])
                |> Panel.withRaised
                |> Panel.toMarkup
            )
        ]


exampleSection : String -> Element msg -> Element msg
exampleSection title content =
    Card.card [ content ]
        |> Card.withTitle title
        |> Card.toMarkup
