module Pages.ClipboardCopyPage exposing (view)

import Element exposing (Element)
import Element.Font as Font
import PF6.Card as Card
import PF6.ClipboardCopy as ClipboardCopy
import PF6.Theme as Theme exposing (Theme)
import PF6.Title as Title
import PF6.Tokens as Tokens


view : Theme -> (String -> msg) -> Element msg
view theme copyMsg =
    Element.column [ Element.width Element.fill, Element.spacing 24 ]
        [ Title.title "Clipboard Copy" |> Title.withH1 |> Title.toMarkup theme
        , Element.paragraph [ Font.size 14, Font.color (Theme.text theme) ]
            [ Element.text "Clipboard copy allows users to copy content to their clipboard with a button." ]
        , exampleSection theme "Basic"
            (ClipboardCopy.clipboardCopy "curl -O https://example.com/file.tar.gz"
                |> ClipboardCopy.withOnCopy (copyMsg "curl -O https://example.com/file.tar.gz")
                |> ClipboardCopy.toMarkup theme
            )
        , exampleSection theme "Inline"
            (ClipboardCopy.clipboardCopy "192.168.1.100"
                |> ClipboardCopy.withInline
                |> ClipboardCopy.withOnCopy (copyMsg "192.168.1.100")
                |> ClipboardCopy.toMarkup theme
            )
        , exampleSection theme "Block"
            (ClipboardCopy.clipboardCopy "apiVersion: v1\nkind: Pod\nmetadata:\n  name: example"
                |> ClipboardCopy.withBlock
                |> ClipboardCopy.withOnCopy (copyMsg "apiVersion: v1\nkind: Pod\nmetadata:\n  name: example")
                |> ClipboardCopy.toMarkup theme
            )
        ]


exampleSection : Theme -> String -> Element msg -> Element msg
exampleSection theme title content =
    Card.card [ content ]
        |> Card.withTitle title
        |> Card.toMarkup theme
