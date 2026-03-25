module Pages.CodeBlockPage exposing (view)

import Element exposing (Element)
import Element.Font as Font
import PF6.Card as Card
import PF6.CodeBlock as CodeBlock
import PF6.Title as Title
import PF6.Tokens as Tokens


view : Element msg
view =
    Element.column [ Element.width Element.fill, Element.spacing 24 ]
        [ Title.title "Code Block" |> Title.withH1 |> Title.toMarkup
        , Element.paragraph [ Font.size 14, Font.color Tokens.colorText ]
            [ Element.text "Code blocks display read-only code in a formatted, accessible container." ]
        , exampleSection "Basic code block"
            (CodeBlock.codeBlock "apiVersion: apps/v1\nkind: Deployment\nmetadata:\n  name: hello-world\nspec:\n  replicas: 3"
                |> CodeBlock.toMarkup
            )
        , exampleSection "Short snippet"
            (CodeBlock.codeBlock "elm make src/Main.elm --output=main.js"
                |> CodeBlock.toMarkup
            )
        ]


exampleSection : String -> Element msg -> Element msg
exampleSection title content =
    Card.card [ content ]
        |> Card.withTitle title
        |> Card.toMarkup
