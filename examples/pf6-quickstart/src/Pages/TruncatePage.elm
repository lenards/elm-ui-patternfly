module Pages.TruncatePage exposing (view)

import Element exposing (Element)
import Element.Font as Font
import PF6.Card as Card
import PF6.Theme as Theme exposing (Theme)
import PF6.Title as Title
import PF6.Tokens as Tokens
import PF6.Truncate as Truncate


view : Theme -> Element msg
view theme =
    Element.column [ Element.width Element.fill, Element.spacing 24 ]
        [ Title.title "Truncate" |> Title.withH1 |> Title.toMarkup theme
        , Element.paragraph [ Font.size 14, Font.color (Theme.text theme) ]
            [ Element.text "Truncate shortens long text with an ellipsis, supporting end and middle truncation." ]
        , exampleSection theme "End truncation (default)"
            (Truncate.truncate "This is a very long string of text that will be truncated at the end to fit within the available space."
                |> Truncate.withMaxChars 40
                |> Truncate.toMarkup theme
            )
        , exampleSection theme "Middle truncation"
            (Truncate.truncate "very-long-filename-that-should-be-truncated-in-the-middle.tar.gz"
                |> Truncate.withMaxChars 30
                |> Truncate.withMiddleTruncation
                |> Truncate.toMarkup theme
            )
        , exampleSection theme "No truncation needed"
            (Truncate.truncate "Short text"
                |> Truncate.withMaxChars 40
                |> Truncate.toMarkup theme
            )
        ]


exampleSection : Theme -> String -> Element msg -> Element msg
exampleSection theme title content =
    Card.card [ content ]
        |> Card.withTitle title
        |> Card.toMarkup theme
