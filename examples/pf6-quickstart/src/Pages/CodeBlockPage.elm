module Pages.CodeBlockPage exposing (view)

import Element exposing (Element)
import Element.Font as Font
import PF6.Card as Card
import PF6.CodeBlock as CodeBlock
import PF6.Theme as Theme exposing (Theme)
import PF6.Title as Title
import PF6.Tokens as Tokens


view : Theme -> Element msg
view theme =
    Element.column [ Element.width Element.fill, Element.spacing 24 ]
        [ Title.title "Code Block" |> Title.withH1 |> Title.toMarkup theme
        , Element.paragraph [ Font.size 14, Font.color (Theme.text theme) ]
            [ Element.text "Code blocks display read-only code in a formatted, accessible container." ]
        , exampleSection theme "Basic code block"
            (CodeBlock.codeBlock "apiVersion: apps/v1\nkind: Deployment\nmetadata:\n  name: hello-world\nspec:\n  replicas: 3"
                |> CodeBlock.toMarkup theme
            )
        , exampleSection theme "Short snippet"
            (CodeBlock.codeBlock "elm make src/Main.elm --output=main.js"
                |> CodeBlock.toMarkup theme
            )
        ]


exampleSection : Theme -> String -> Element msg -> Element msg
exampleSection theme title content =
    Card.card [ content ]
        |> Card.withTitle title
        |> Card.toMarkup theme
