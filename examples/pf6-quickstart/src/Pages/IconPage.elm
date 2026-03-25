module Pages.IconPage exposing (view)

import Element exposing (Element)
import Element.Font as Font
import PF6.Card as Card
import PF6.Icon as Icon
import PF6.Title as Title
import PF6.Tokens as Tokens


view : Element msg
view =
    Element.column [ Element.width Element.fill, Element.spacing 24 ]
        [ Title.title "Icon" |> Title.withH1 |> Title.toMarkup
        , Element.paragraph [ Font.size 14, Font.color Tokens.colorText ]
            [ Element.text "Icons wrap inline SVG or text-based icons with semantic color status support." ]
        , exampleSection "Sizes"
            (Element.wrappedRow [ Element.spacing 16 ]
                [ Icon.icon (Element.text "i") |> Icon.withSmallSize |> Icon.toMarkup
                , Icon.icon (Element.text "i") |> Icon.withMediumSize |> Icon.toMarkup
                , Icon.icon (Element.text "i") |> Icon.withLargeSize |> Icon.toMarkup
                , Icon.icon (Element.text "i") |> Icon.withXLargeSize |> Icon.toMarkup
                ]
            )
        , exampleSection "Status variants"
            (Element.wrappedRow [ Element.spacing 16 ]
                [ Icon.icon (Element.text "OK") |> Icon.withSuccessStatus |> Icon.toMarkup
                , Icon.icon (Element.text "!!") |> Icon.withDangerStatus |> Icon.toMarkup
                , Icon.icon (Element.text "!") |> Icon.withWarningStatus |> Icon.toMarkup
                , Icon.icon (Element.text "i") |> Icon.withInfoStatus |> Icon.toMarkup
                ]
            )
        ]


exampleSection : String -> Element msg -> Element msg
exampleSection title content =
    Card.card [ content ]
        |> Card.withTitle title
        |> Card.toMarkup
