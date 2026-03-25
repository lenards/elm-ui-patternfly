module Pages.BullseyePage exposing (view)

import Element exposing (Element)
import Element.Background as Bg
import Element.Border as Border
import Element.Font as Font
import PF6.Bullseye as Bullseye
import PF6.Card as Card
import PF6.Title as Title
import PF6.Tokens as Tokens


view : Element msg
view =
    Element.column [ Element.width Element.fill, Element.spacing 24 ]
        [ Title.title "Bullseye" |> Title.withH1 |> Title.toMarkup
        , Element.paragraph [ Font.size 14, Font.color Tokens.colorText ]
            [ Element.text "Bullseye centers content vertically and horizontally in a container." ]
        , exampleSection "Basic bullseye"
            (Element.el
                [ Element.width Element.fill
                , Element.height (Element.px 200)
                , Bg.color (Element.rgb255 240 240 240)
                , Border.width 1
                , Border.color Tokens.colorBorderDefault
                , Border.dashed
                ]
                (Bullseye.bullseye
                    (Element.el
                        [ Bg.color Tokens.colorBackgroundDefault
                        , Element.padding 24
                        , Border.rounded 8
                        , Border.shadow { offset = ( 0, 2 ), size = 0, blur = 8, color = Element.rgba 0 0 0 0.1 }
                        ]
                        (Element.text "Centered content")
                    )
                    |> Bullseye.toMarkup
                )
            )
        , exampleSection "Bullseye with padding"
            (Element.el
                [ Element.width Element.fill
                , Element.height (Element.px 200)
                , Bg.color (Element.rgb255 240 240 240)
                , Border.width 1
                , Border.color Tokens.colorBorderDefault
                , Border.dashed
                ]
                (Bullseye.bullseye
                    (Element.column [ Element.spacing 8 ]
                        [ Element.el [ Font.bold ] (Element.text "Centered with padding")
                        , Element.el [ Font.size 14, Font.color Tokens.colorTextSubtle ]
                            (Element.text "The bullseye layout adds padding around the centered content.")
                        ]
                    )
                    |> Bullseye.withPadding 32
                    |> Bullseye.toMarkup
                )
            )
        ]


exampleSection : String -> Element msg -> Element msg
exampleSection title content =
    Card.card [ content ]
        |> Card.withTitle title
        |> Card.toMarkup
