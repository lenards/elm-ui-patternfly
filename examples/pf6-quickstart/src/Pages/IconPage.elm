module Pages.IconPage exposing (view)

import Element exposing (Element)
import Element.Font as Font
import PF6.Card as Card
import PF6.Icon as Icon
import PF6.Theme as Theme exposing (Theme)
import PF6.Title as Title
import PF6.Tokens as Tokens


view : Theme -> Element msg
view theme =
    Element.column [ Element.width Element.fill, Element.spacing 24 ]
        [ Title.title "Icon" |> Title.withH1 |> Title.toMarkup theme
        , Element.paragraph [ Font.size 14, Font.color (Theme.text theme) ]
            [ Element.text "Icons wrap inline SVG or text-based icons with semantic color status support." ]
        , exampleSection theme "Sizes"
            (Element.wrappedRow [ Element.spacing 16 ]
                [ Icon.icon (Element.text "i") |> Icon.withSmallSize |> Icon.toMarkup theme
                , Icon.icon (Element.text "i") |> Icon.withMediumSize |> Icon.toMarkup theme
                , Icon.icon (Element.text "i") |> Icon.withLargeSize |> Icon.toMarkup theme
                , Icon.icon (Element.text "i") |> Icon.withXLargeSize |> Icon.toMarkup theme
                ]
            )
        , exampleSection theme "Status variants"
            (Element.wrappedRow [ Element.spacing 16 ]
                [ Icon.icon (Element.text "OK") |> Icon.withSuccessStatus |> Icon.toMarkup theme
                , Icon.icon (Element.text "!!") |> Icon.withDangerStatus |> Icon.toMarkup theme
                , Icon.icon (Element.text "!") |> Icon.withWarningStatus |> Icon.toMarkup theme
                , Icon.icon (Element.text "i") |> Icon.withInfoStatus |> Icon.toMarkup theme
                ]
            )
        ]


exampleSection : Theme -> String -> Element msg -> Element msg
exampleSection theme title content =
    Card.card [ content ]
        |> Card.withTitle title
        |> Card.toMarkup theme
