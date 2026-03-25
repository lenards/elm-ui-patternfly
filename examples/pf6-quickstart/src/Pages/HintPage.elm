module Pages.HintPage exposing (view)

import Element exposing (Element)
import Element.Font as Font
import PF6.Card as Card
import PF6.Hint as Hint
import PF6.Title as Title
import PF6.Tokens as Tokens


view : Element msg
view =
    Element.column [ Element.width Element.fill, Element.spacing 24 ]
        [ Title.title "Hint" |> Title.withH1 |> Title.toMarkup
        , Element.paragraph [ Font.size 14, Font.color Tokens.colorText ]
            [ Element.text "A hint provides supplemental information or guidance with lighter styling than an alert." ]
        , exampleSection "Basic hint"
            (Hint.hint "This is a hint body. Use hints to provide supplemental information without the urgency of an alert."
                |> Hint.toMarkup
            )
        , exampleSection "With title"
            (Hint.hint "Longer descriptions can be placed in the body."
                |> Hint.withTitle "Do you know?"
                |> Hint.toMarkup
            )
        , exampleSection "With title and footer"
            (Hint.hint "Hints can contain a title, body, and footer."
                |> Hint.withTitle "Helpful hint"
                |> Hint.withFooter (Element.el [ Font.size 12, Font.color Tokens.colorTextSubtle ] (Element.text "Last updated 2 hours ago"))
                |> Hint.toMarkup
            )
        ]


exampleSection : String -> Element msg -> Element msg
exampleSection title content =
    Card.card [ content ]
        |> Card.withTitle title
        |> Card.toMarkup
