module Pages.BackdropPage exposing (view)

import Element exposing (Element)
import Element.Background as Bg
import Element.Font as Font
import PF6.Card as Card
import PF6.Title as Title
import PF6.Tokens as Tokens


view : Element msg
view =
    Element.column [ Element.width Element.fill, Element.spacing 24 ]
        [ Title.title "Backdrop" |> Title.withH1 |> Title.toMarkup
        , Element.paragraph [ Font.size 14, Font.color Tokens.colorText ]
            [ Element.text "A backdrop is a semi-transparent overlay used behind modals and other overlays to focus user attention." ]
        , exampleSection "Backdrop preview"
            (Element.el
                [ Element.width Element.fill
                , Element.height (Element.px 200)
                , Bg.color (Element.rgba 0 0 0 0.5)
                , Element.padding 24
                ]
                (Element.el
                    [ Element.centerX
                    , Element.centerY
                    , Bg.color Tokens.colorBackgroundDefault
                    , Element.padding 24
                    , Font.size 14
                    ]
                    (Element.text "Content above the backdrop")
                )
            )
        , exampleSection "Usage note"
            (Element.paragraph [ Font.size 14, Font.color Tokens.colorText ]
                [ Element.text "Backdrops are typically used with the Modal component. The backdrop accepts an onClick msg to dismiss the overlay." ]
            )
        ]


exampleSection : String -> Element msg -> Element msg
exampleSection title content =
    Card.card [ content ]
        |> Card.withTitle title
        |> Card.toMarkup
