module Pages.TruncatePage exposing (view)

import Element exposing (Element)
import Element.Font as Font
import PF6.Card as Card
import PF6.Title as Title
import PF6.Tokens as Tokens
import PF6.Truncate as Truncate


view : Element msg
view =
    Element.column [ Element.width Element.fill, Element.spacing 24 ]
        [ Title.title "Truncate" |> Title.withH1 |> Title.toMarkup
        , Element.paragraph [ Font.size 14, Font.color Tokens.colorText ]
            [ Element.text "Truncate shortens long text with an ellipsis, supporting end and middle truncation." ]
        , exampleSection "End truncation (default)"
            (Truncate.truncate "This is a very long string of text that will be truncated at the end to fit within the available space."
                |> Truncate.withMaxChars 40
                |> Truncate.toMarkup
            )
        , exampleSection "Middle truncation"
            (Truncate.truncate "very-long-filename-that-should-be-truncated-in-the-middle.tar.gz"
                |> Truncate.withMaxChars 30
                |> Truncate.withMiddleTruncation
                |> Truncate.toMarkup
            )
        , exampleSection "No truncation needed"
            (Truncate.truncate "Short text"
                |> Truncate.withMaxChars 40
                |> Truncate.toMarkup
            )
        ]


exampleSection : String -> Element msg -> Element msg
exampleSection title content =
    Card.card [ content ]
        |> Card.withTitle title
        |> Card.toMarkup
