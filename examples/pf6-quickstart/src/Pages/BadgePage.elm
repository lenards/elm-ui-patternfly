module Pages.BadgePage exposing (view)

import Element exposing (Element)
import Element.Font as Font
import PF6.Badge as Badge
import PF6.Card as Card
import PF6.Title as Title
import PF6.Tokens as Tokens


view : Element msg
view =
    Element.column [ Element.width Element.fill, Element.spacing 24 ]
        [ Title.title "Badge" |> Title.withH1 |> Title.toMarkup
        , Element.paragraph [ Font.size 14, Font.color Tokens.colorText ]
            [ Element.text "Badges display counts or status indicators as pill-shaped elements." ]
        , exampleSection "Read badges"
            (Element.wrappedRow [ Element.spacing 12 ]
                [ Badge.badge 7 |> Badge.withReadStatus |> Badge.toMarkup
                , Badge.badge 24 |> Badge.withReadStatus |> Badge.toMarkup
                , Badge.badge 152 |> Badge.withReadStatus |> Badge.toMarkup
                ]
            )
        , exampleSection "Unread badges"
            (Element.wrappedRow [ Element.spacing 12 ]
                [ Badge.unreadBadge 1 |> Badge.toMarkup
                , Badge.unreadBadge 12 |> Badge.toMarkup
                , Badge.unreadBadge 99 |> Badge.toMarkup
                ]
            )
        , exampleSection "Overflow"
            (Element.wrappedRow [ Element.spacing 12 ]
                [ Badge.badge 150 |> Badge.withOverflowAt 99 |> Badge.toMarkup
                , Badge.unreadBadge 1000 |> Badge.withOverflowAt 999 |> Badge.toMarkup
                ]
            )
        ]


exampleSection : String -> Element msg -> Element msg
exampleSection title content =
    Card.card [ content ]
        |> Card.withTitle title
        |> Card.toMarkup
