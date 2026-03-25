module Pages.InputGroupPage exposing (view)

import Element exposing (Element)
import Element.Font as Font
import PF6.Card as Card
import PF6.InputGroup as InputGroup
import PF6.Title as Title
import PF6.Tokens as Tokens


view : Element msg
view =
    Element.column [ Element.width Element.fill, Element.spacing 24 ]
        [ Title.title "Input Group" |> Title.withH1 |> Title.toMarkup
        , Element.paragraph [ Font.size 14, Font.color Tokens.colorText ]
            [ Element.text "Input groups combine multiple form controls with shared borders." ]
        , exampleSection "Basic input group"
            (InputGroup.inputGroup
                [ InputGroup.inputGroupText "$"
                , InputGroup.inputGroupItem (Element.el [ Element.padding 8, Font.size 14 ] (Element.text "0.00"))
                ]
                |> InputGroup.toMarkup
            )
        , exampleSection "With prefix and suffix"
            (InputGroup.inputGroup
                [ InputGroup.inputGroupText "https://"
                , InputGroup.inputGroupItem (Element.el [ Element.padding 8, Font.size 14 ] (Element.text "example.com"))
                , InputGroup.inputGroupText "/path"
                ]
                |> InputGroup.toMarkup
            )
        ]


exampleSection : String -> Element msg -> Element msg
exampleSection title content =
    Card.card [ content ]
        |> Card.withTitle title
        |> Card.toMarkup
