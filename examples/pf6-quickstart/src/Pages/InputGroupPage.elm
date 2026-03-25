module Pages.InputGroupPage exposing (view)

import Element exposing (Element)
import Element.Font as Font
import PF6.Card as Card
import PF6.InputGroup as InputGroup
import PF6.Theme as Theme exposing (Theme)
import PF6.Title as Title
import PF6.Tokens as Tokens


view : Theme -> Element msg
view theme =
    Element.column [ Element.width Element.fill, Element.spacing 24 ]
        [ Title.title "Input Group" |> Title.withH1 |> Title.toMarkup theme
        , Element.paragraph [ Font.size 14, Font.color (Theme.text theme) ]
            [ Element.text "Input groups combine multiple form controls with shared borders." ]
        , exampleSection theme "Basic input group"
            (InputGroup.inputGroup
                [ InputGroup.inputGroupText "$"
                , InputGroup.inputGroupItem (Element.el [ Element.padding 8, Font.size 14 ] (Element.text "0.00"))
                ]
                |> InputGroup.toMarkup theme
            )
        , exampleSection theme "With prefix and suffix"
            (InputGroup.inputGroup
                [ InputGroup.inputGroupText "https://"
                , InputGroup.inputGroupItem (Element.el [ Element.padding 8, Font.size 14 ] (Element.text "example.com"))
                , InputGroup.inputGroupText "/path"
                ]
                |> InputGroup.toMarkup theme
            )
        ]


exampleSection : Theme -> String -> Element msg -> Element msg
exampleSection theme title content =
    Card.card [ content ]
        |> Card.withTitle title
        |> Card.toMarkup theme
