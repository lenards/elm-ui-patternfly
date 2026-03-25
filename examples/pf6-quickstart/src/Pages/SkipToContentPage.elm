module Pages.SkipToContentPage exposing (view)

import Element exposing (Element)
import Element.Font as Font
import PF6.Card as Card
import PF6.SkipToContent as SkipToContent
import PF6.Title as Title
import PF6.Tokens as Tokens


view : Element msg
view =
    Element.column [ Element.width Element.fill, Element.spacing 24 ]
        [ Title.title "Skip to Content" |> Title.withH1 |> Title.toMarkup
        , Element.paragraph [ Font.size 14, Font.color Tokens.colorText ]
            [ Element.text "Skip to content links allow keyboard users to bypass navigation and jump to the main content area." ]
        , exampleSection "Basic skip to content"
            (SkipToContent.skipToContent { href = "#main-content", label = "Skip to main content" }
                |> SkipToContent.toMarkup
            )
        , exampleSection "Usage note"
            (Element.paragraph [ Font.size 14, Font.color Tokens.colorText ]
                [ Element.text "The skip to content link is visually hidden until focused via keyboard Tab. It appears as the very first focusable element on the page." ]
            )
        ]


exampleSection : String -> Element msg -> Element msg
exampleSection title content =
    Card.card [ content ]
        |> Card.withTitle title
        |> Card.toMarkup
