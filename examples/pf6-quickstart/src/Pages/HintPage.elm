module Pages.HintPage exposing (view)

import Element exposing (Element)
import Element.Font as Font
import PF6.Card as Card
import PF6.Hint as Hint
import PF6.Theme as Theme exposing (Theme)
import PF6.Title as Title
import PF6.Tokens as Tokens


view : Theme -> Element msg
view theme =
    Element.column [ Element.width Element.fill, Element.spacing 24 ]
        [ Title.title "Hint" |> Title.withH1 |> Title.toMarkup theme
        , Element.paragraph [ Font.size 14, Font.color (Theme.text theme) ]
            [ Element.text "A hint provides supplemental information or guidance with lighter styling than an alert." ]
        , exampleSection theme "Basic hint"
            (Hint.hint "This is a hint body. Use hints to provide supplemental information without the urgency of an alert."
                |> Hint.toMarkup theme
            )
        , exampleSection theme "With title"
            (Hint.hint "Longer descriptions can be placed in the body."
                |> Hint.withTitle "Do you know?"
                |> Hint.toMarkup theme
            )
        , exampleSection theme "With title and footer"
            (Hint.hint "Hints can contain a title, body, and footer."
                |> Hint.withTitle "Helpful hint"
                |> Hint.withFooter (Element.el [ Font.size 12, Font.color (Theme.textSubtle theme) ] (Element.text "Last updated 2 hours ago"))
                |> Hint.toMarkup theme
            )
        ]


exampleSection : Theme -> String -> Element msg -> Element msg
exampleSection theme title content =
    Card.card [ content ]
        |> Card.withTitle title
        |> Card.toMarkup theme
