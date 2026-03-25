module Pages.BackToTopPage exposing (view)

import Element exposing (Element)
import Element.Font as Font
import PF6.BackToTop as BackToTop
import PF6.Card as Card
import PF6.Theme as Theme exposing (Theme)
import PF6.Title as Title
import PF6.Tokens as Tokens


view : Theme -> msg -> Element msg
view theme noOp =
    Element.column [ Element.width Element.fill, Element.spacing 24 ]
        [ Title.title "Back to Top" |> Title.withH1 |> Title.toMarkup theme
        , Element.paragraph [ Font.size 14, Font.color (Theme.text theme) ]
            [ Element.text "A floating button that scrolls the user back to the top of the page, positioned at the bottom-right corner." ]
        , exampleSection theme "Always visible"
            (Element.column [ Element.spacing 12 ]
                [ Element.paragraph [ Font.size 14 ]
                    [ Element.text "The Back to Top button is shown below. In production it uses fixed positioning." ]
                , BackToTop.backToTop noOp
                    |> BackToTop.withAlwaysVisible
                    |> BackToTop.toMarkup theme
                ]
            )
        , exampleSection theme "With bottom offset"
            (BackToTop.backToTop noOp
                |> BackToTop.withAlwaysVisible
                |> BackToTop.withBottomOffset 80
                |> BackToTop.toMarkup theme
            )
        ]


exampleSection : Theme -> String -> Element msg -> Element msg
exampleSection theme title content =
    Card.card [ content ]
        |> Card.withTitle title
        |> Card.toMarkup theme
