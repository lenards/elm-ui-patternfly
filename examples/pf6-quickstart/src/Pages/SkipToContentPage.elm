module Pages.SkipToContentPage exposing (view)

import Element exposing (Element)
import Element.Font as Font
import PF6.Card as Card
import PF6.SkipToContent as SkipToContent
import PF6.Theme as Theme exposing (Theme)
import PF6.Title as Title
import PF6.Tokens as Tokens


view : Theme -> Element msg
view theme =
    Element.column [ Element.width Element.fill, Element.spacing 24 ]
        [ Title.title "Skip to Content" |> Title.withH1 |> Title.toMarkup theme
        , Element.paragraph [ Font.size 14, Font.color (Theme.text theme) ]
            [ Element.text "Skip to content links allow keyboard users to bypass navigation and jump to the main content area." ]
        , exampleSection theme "Basic skip to content"
            (SkipToContent.skipToContent { href = "#main-content", label = "Skip to main content" }
                |> SkipToContent.toMarkup theme
            )
        , exampleSection theme "Usage note"
            (Element.paragraph [ Font.size 14, Font.color (Theme.text theme) ]
                [ Element.text "The skip to content link is visually hidden until focused via keyboard Tab. It appears as the very first focusable element on the page." ]
            )
        ]


exampleSection : Theme -> String -> Element msg -> Element msg
exampleSection theme title content =
    Card.card [ content ]
        |> Card.withTitle title
        |> Card.toMarkup theme
