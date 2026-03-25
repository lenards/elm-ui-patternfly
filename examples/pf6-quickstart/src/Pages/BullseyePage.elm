module Pages.BullseyePage exposing (view)

import Element exposing (Element)
import Element.Background as Bg
import Element.Border as Border
import Element.Font as Font
import PF6.Bullseye as Bullseye
import PF6.Card as Card
import PF6.Theme as Theme exposing (Theme)
import PF6.Title as Title
import PF6.Tokens as Tokens


view : Theme -> Element msg
view theme =
    Element.column [ Element.width Element.fill, Element.spacing 24 ]
        [ Title.title "Bullseye" |> Title.withH1 |> Title.toMarkup theme
        , Element.paragraph [ Font.size 14, Font.color (Theme.text theme) ]
            [ Element.text "Bullseye centers content vertically and horizontally in a container." ]
        , exampleSection theme "Basic bullseye"
            (Element.el
                [ Element.width Element.fill
                , Element.height (Element.px 200)
                , Bg.color (Element.rgb255 240 240 240)
                , Border.width 1
                , Border.color (Theme.borderDefault theme)
                , Border.dashed
                ]
                (Bullseye.bullseye
                    (Element.el
                        [ Bg.color (Theme.backgroundDefault theme)
                        , Element.padding 24
                        , Border.rounded 8
                        , Border.shadow { offset = ( 0, 2 ), size = 0, blur = 8, color = Element.rgba 0 0 0 0.1 }
                        ]
                        (Element.text "Centered content")
                    )
                    |> Bullseye.toMarkup theme
                )
            )
        , exampleSection theme "Bullseye with padding"
            (Element.el
                [ Element.width Element.fill
                , Element.height (Element.px 200)
                , Bg.color (Element.rgb255 240 240 240)
                , Border.width 1
                , Border.color (Theme.borderDefault theme)
                , Border.dashed
                ]
                (Bullseye.bullseye
                    (Element.column [ Element.spacing 8 ]
                        [ Element.el [ Font.bold ] (Element.text "Centered with padding")
                        , Element.el [ Font.size 14, Font.color (Theme.textSubtle theme) ]
                            (Element.text "The bullseye layout adds padding around the centered content.")
                        ]
                    )
                    |> Bullseye.withPadding 32
                    |> Bullseye.toMarkup theme
                )
            )
        ]


exampleSection : Theme -> String -> Element msg -> Element msg
exampleSection theme title content =
    Card.card [ content ]
        |> Card.withTitle title
        |> Card.toMarkup theme
