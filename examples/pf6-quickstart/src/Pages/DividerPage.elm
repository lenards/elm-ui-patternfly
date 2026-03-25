module Pages.DividerPage exposing (view)

import Element exposing (Element)
import Element.Font as Font
import PF6.Card as Card
import PF6.Divider as Divider
import PF6.Theme as Theme exposing (Theme)
import PF6.Title as Title
import PF6.Tokens as Tokens


view : Theme -> Element msg
view theme =
    Element.column [ Element.width Element.fill, Element.spacing 24 ]
        [ Title.title "Divider" |> Title.withH1 |> Title.toMarkup theme
        , Element.paragraph [ Font.size 14, Font.color (Theme.text theme) ]
            [ Element.text "A horizontal or vertical rule to visually separate content." ]
        , exampleSection theme "Horizontal divider"
            (Element.column [ Element.width Element.fill, Element.spacing 12 ]
                [ Element.text "Content above"
                , Divider.divider |> Divider.withHorizontal |> Divider.toMarkup theme
                , Element.text "Content below"
                ]
            )
        , exampleSection theme "Vertical divider"
            (Element.row [ Element.spacing 12, Element.height (Element.px 40) ]
                [ Element.text "Left"
                , Divider.divider |> Divider.withVertical |> Divider.toMarkup theme
                , Element.text "Right"
                ]
            )
        , exampleSection theme "With inset"
            (Element.column [ Element.width Element.fill, Element.spacing 12 ]
                [ Element.text "Content above"
                , Divider.divider |> Divider.withInsetLg |> Divider.toMarkup theme
                , Element.text "Content below"
                ]
            )
        ]


exampleSection : Theme -> String -> Element msg -> Element msg
exampleSection theme title content =
    Card.card [ content ]
        |> Card.withTitle title
        |> Card.toMarkup theme
