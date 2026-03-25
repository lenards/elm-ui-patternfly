module Pages.TimestampPage exposing (view)

import Element exposing (Element)
import Element.Font as Font
import PF6.Card as Card
import PF6.Timestamp as Timestamp
import PF6.Title as Title
import PF6.Tokens as Tokens


view : Element msg
view =
    Element.column [ Element.width Element.fill, Element.spacing 24 ]
        [ Title.title "Timestamp" |> Title.withH1 |> Title.toMarkup
        , Element.paragraph [ Font.size 14, Font.color Tokens.colorText ]
            [ Element.text "Timestamps display a date and/or time value with optional tooltip for full details." ]
        , exampleSection "Basic timestamp"
            (Timestamp.timestamp "2 hours ago" |> Timestamp.toMarkup)
        , exampleSection "With tooltip"
            (Timestamp.timestamp "Mar 15, 2024"
                |> Timestamp.withTooltip "March 15, 2024 at 3:45:00 PM UTC"
                |> Timestamp.toMarkup
            )
        , exampleSection "With icon"
            (Element.column [ Element.spacing 8 ]
                [ Timestamp.timestamp "Just now" |> Timestamp.withIcon |> Timestamp.toMarkup
                , Timestamp.timestamp "5 minutes ago" |> Timestamp.withIcon |> Timestamp.toMarkup
                , Timestamp.timestamp "1 day ago" |> Timestamp.withIcon |> Timestamp.toMarkup
                ]
            )
        ]


exampleSection : String -> Element msg -> Element msg
exampleSection title content =
    Card.card [ content ]
        |> Card.withTitle title
        |> Card.toMarkup
