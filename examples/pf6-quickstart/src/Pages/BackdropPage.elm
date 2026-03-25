module Pages.BackdropPage exposing (view)

import Element exposing (Element)
import Element.Background as Bg
import Element.Font as Font
import PF6.Card as Card
import PF6.Theme as Theme exposing (Theme)
import PF6.Title as Title
import PF6.Tokens as Tokens


view : Theme -> Element msg
view theme =
    Element.column [ Element.width Element.fill, Element.spacing 24 ]
        [ Title.title "Backdrop" |> Title.withH1 |> Title.toMarkup theme
        , Element.paragraph [ Font.size 14, Font.color (Theme.text theme) ]
            [ Element.text "A backdrop is a semi-transparent overlay used behind modals and other overlays to focus user attention." ]
        , exampleSection theme "Backdrop preview"
            (Element.el
                [ Element.width Element.fill
                , Element.height (Element.px 200)
                , Bg.color (Element.rgba 0 0 0 0.5)
                , Element.padding 24
                ]
                (Element.el
                    [ Element.centerX
                    , Element.centerY
                    , Bg.color (Theme.backgroundDefault theme)
                    , Element.padding 24
                    , Font.size 14
                    ]
                    (Element.text "Content above the backdrop")
                )
            )
        , exampleSection theme "Usage note"
            (Element.paragraph [ Font.size 14, Font.color (Theme.text theme) ]
                [ Element.text "Backdrops are typically used with the Modal component. The backdrop accepts an onClick msg to dismiss the overlay." ]
            )
        ]


exampleSection : Theme -> String -> Element msg -> Element msg
exampleSection theme title content =
    Card.card [ content ]
        |> Card.withTitle title
        |> Card.toMarkup theme
