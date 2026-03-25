module Pages.NotificationBadgePage exposing (view)

import Element exposing (Element)
import Element.Font as Font
import PF6.Card as Card
import PF6.NotificationBadge as NotificationBadge
import PF6.Title as Title
import PF6.Tokens as Tokens


view : msg -> Element msg
view noOp =
    Element.column [ Element.width Element.fill, Element.spacing 24 ]
        [ Title.title "Notification Badge" |> Title.withH1 |> Title.toMarkup
        , Element.paragraph [ Font.size 14, Font.color Tokens.colorText ]
            [ Element.text "Notification badges display a count of unread notifications." ]
        , exampleSection "Unread"
            (Element.wrappedRow [ Element.spacing 16 ]
                [ NotificationBadge.notificationBadge { count = 5, onClick = noOp } |> NotificationBadge.toMarkup
                , NotificationBadge.notificationBadge { count = 99, onClick = noOp } |> NotificationBadge.toMarkup
                ]
            )
        , exampleSection "Read"
            (NotificationBadge.notificationBadge { count = 3, onClick = noOp }
                |> NotificationBadge.withRead
                |> NotificationBadge.toMarkup
            )
        , exampleSection "Attention variant"
            (NotificationBadge.notificationBadge { count = 12, onClick = noOp }
                |> NotificationBadge.withAttentionVariant
                |> NotificationBadge.toMarkup
            )
        ]


exampleSection : String -> Element msg -> Element msg
exampleSection title content =
    Card.card [ content ]
        |> Card.withTitle title
        |> Card.toMarkup
