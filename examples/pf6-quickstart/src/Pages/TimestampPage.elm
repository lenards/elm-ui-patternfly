module Pages.TimestampPage exposing (view)

import Element exposing (Element)
import Element.Font as Font
import PF6.Card as Card
import PF6.Theme as Theme exposing (Theme)
import PF6.Timestamp as Timestamp
import PF6.Title as Title
import PF6.Tokens as Tokens


view : Theme -> Element msg
view theme =
    Element.column [ Element.width Element.fill, Element.spacing 24 ]
        [ Title.title "Timestamp" |> Title.withH1 |> Title.toMarkup theme
        , Element.paragraph [ Font.size 14, Font.color (Theme.text theme) ]
            [ Element.text "Timestamps display a date and/or time value with optional tooltip for full details." ]
        , exampleSection theme "Basic timestamp"
            (Timestamp.timestamp "2 hours ago" |> Timestamp.toMarkup theme)
        , exampleSection theme "With tooltip"
            (Timestamp.timestamp "Mar 15, 2024"
                |> Timestamp.withTooltip "March 15, 2024 at 3:45:00 PM UTC"
                |> Timestamp.toMarkup theme
            )
        , exampleSection theme "With icon"
            (Element.column [ Element.spacing 8 ]
                [ Timestamp.timestamp "Just now" |> Timestamp.withIcon |> Timestamp.toMarkup theme
                , Timestamp.timestamp "5 minutes ago" |> Timestamp.withIcon |> Timestamp.toMarkup theme
                , Timestamp.timestamp "1 day ago" |> Timestamp.withIcon |> Timestamp.toMarkup theme
                ]
            )
        ]


exampleSection : Theme -> String -> Element msg -> Element msg
exampleSection theme title content =
    Card.card [ content ]
        |> Card.withTitle title
        |> Card.toMarkup theme
