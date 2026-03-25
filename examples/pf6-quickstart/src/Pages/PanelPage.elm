module Pages.PanelPage exposing (view)

import Element exposing (Element)
import Element.Font as Font
import PF6.Card as Card
import PF6.Panel as Panel
import PF6.Theme as Theme exposing (Theme)
import PF6.Title as Title
import PF6.Tokens as Tokens


view : Theme -> Element msg
view theme =
    Element.column [ Element.width Element.fill, Element.spacing 24 ]
        [ Title.title "Panel" |> Title.withH1 |> Title.toMarkup theme
        , Element.paragraph [ Font.size 14, Font.color (Theme.text theme) ]
            [ Element.text "A panel is a container with optional header and footer, used to group content." ]
        , exampleSection theme "Basic panel"
            (Panel.panel (Element.paragraph [ Font.size 14 ] [ Element.text "Panel body content goes here." ])
                |> Panel.toMarkup theme
            )
        , exampleSection theme "With header and footer"
            (Panel.panel (Element.paragraph [ Font.size 14 ] [ Element.text "This is the main body of the panel." ])
                |> Panel.withHeader (Element.el [ Font.bold, Font.size 14 ] (Element.text "Panel Header"))
                |> Panel.withFooter (Element.el [ Font.size 12, Font.color (Theme.textSubtle theme) ] (Element.text "Panel footer"))
                |> Panel.toMarkup theme
            )
        , exampleSection theme "Raised panel"
            (Panel.panel (Element.paragraph [ Font.size 14 ] [ Element.text "This panel has a raised shadow." ])
                |> Panel.withRaised
                |> Panel.toMarkup theme
            )
        ]


exampleSection : Theme -> String -> Element msg -> Element msg
exampleSection theme title content =
    Card.card [ content ]
        |> Card.withTitle title
        |> Card.toMarkup theme
