module Pages.ClipboardCopyPage exposing (view)

import Element exposing (Element)
import Element.Font as Font
import PF6.Card as Card
import PF6.ClipboardCopy as ClipboardCopy
import PF6.Title as Title
import PF6.Tokens as Tokens


view : msg -> Element msg
view noOp =
    Element.column [ Element.width Element.fill, Element.spacing 24 ]
        [ Title.title "Clipboard Copy" |> Title.withH1 |> Title.toMarkup
        , Element.paragraph [ Font.size 14, Font.color Tokens.colorText ]
            [ Element.text "Clipboard copy allows users to copy content to their clipboard with a button." ]
        , exampleSection "Basic"
            (ClipboardCopy.clipboardCopy "curl -O https://example.com/file.tar.gz"
                |> ClipboardCopy.withOnCopy noOp
                |> ClipboardCopy.toMarkup
            )
        , exampleSection "Inline"
            (ClipboardCopy.clipboardCopy "192.168.1.100"
                |> ClipboardCopy.withInline
                |> ClipboardCopy.withOnCopy noOp
                |> ClipboardCopy.toMarkup
            )
        , exampleSection "Block"
            (ClipboardCopy.clipboardCopy "apiVersion: v1\nkind: Pod\nmetadata:\n  name: example"
                |> ClipboardCopy.withBlock
                |> ClipboardCopy.withOnCopy noOp
                |> ClipboardCopy.toMarkup
            )
        ]


exampleSection : String -> Element msg -> Element msg
exampleSection title content =
    Card.card [ content ]
        |> Card.withTitle title
        |> Card.toMarkup
