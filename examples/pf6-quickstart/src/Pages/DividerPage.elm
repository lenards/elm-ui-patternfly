module Pages.DividerPage exposing (view)

import Element exposing (Element)
import Element.Font as Font
import PF6.Card as Card
import PF6.Divider as Divider
import PF6.Title as Title
import PF6.Tokens as Tokens


view : Element msg
view =
    Element.column [ Element.width Element.fill, Element.spacing 24 ]
        [ Title.title "Divider" |> Title.withH1 |> Title.toMarkup
        , Element.paragraph [ Font.size 14, Font.color Tokens.colorText ]
            [ Element.text "A horizontal or vertical rule to visually separate content." ]
        , exampleSection "Horizontal divider"
            (Element.column [ Element.width Element.fill, Element.spacing 12 ]
                [ Element.text "Content above"
                , Divider.divider |> Divider.withHorizontal |> Divider.toMarkup
                , Element.text "Content below"
                ]
            )
        , exampleSection "Vertical divider"
            (Element.row [ Element.spacing 12, Element.height (Element.px 40) ]
                [ Element.text "Left"
                , Divider.divider |> Divider.withVertical |> Divider.toMarkup
                , Element.text "Right"
                ]
            )
        , exampleSection "With inset"
            (Element.column [ Element.width Element.fill, Element.spacing 12 ]
                [ Element.text "Content above"
                , Divider.divider |> Divider.withInsetLg |> Divider.toMarkup
                , Element.text "Content below"
                ]
            )
        ]


exampleSection : String -> Element msg -> Element msg
exampleSection title content =
    Card.card [ content ]
        |> Card.withTitle title
        |> Card.toMarkup
