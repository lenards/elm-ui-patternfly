module Pages.BackToTopPage exposing (view)

import Element exposing (Element)
import Element.Font as Font
import PF6.BackToTop as BackToTop
import PF6.Card as Card
import PF6.Title as Title
import PF6.Tokens as Tokens


view : msg -> Element msg
view noOp =
    Element.column [ Element.width Element.fill, Element.spacing 24 ]
        [ Title.title "Back to Top" |> Title.withH1 |> Title.toMarkup
        , Element.paragraph [ Font.size 14, Font.color Tokens.colorText ]
            [ Element.text "A floating button that scrolls the user back to the top of the page, positioned at the bottom-right corner." ]
        , exampleSection "Always visible"
            (Element.column [ Element.spacing 12 ]
                [ Element.paragraph [ Font.size 14 ]
                    [ Element.text "The Back to Top button is shown below. In production it uses fixed positioning." ]
                , BackToTop.backToTop noOp
                    |> BackToTop.withAlwaysVisible
                    |> BackToTop.toMarkup
                ]
            )
        , exampleSection "With bottom offset"
            (BackToTop.backToTop noOp
                |> BackToTop.withAlwaysVisible
                |> BackToTop.withBottomOffset 80
                |> BackToTop.toMarkup
            )
        ]


exampleSection : String -> Element msg -> Element msg
exampleSection title content =
    Card.card [ content ]
        |> Card.withTitle title
        |> Card.toMarkup
