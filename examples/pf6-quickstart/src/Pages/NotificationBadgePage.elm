module Pages.NotificationBadgePage exposing (view)

import Element exposing (Element)
import Element.Font as Font
import PF6.Card as Card
import PF6.NotificationBadge as NotificationBadge
import PF6.Theme as Theme exposing (Theme)
import PF6.Title as Title
import PF6.Tokens as Tokens


view : Theme -> msg -> Element msg
view theme noOp =
    Element.column [ Element.width Element.fill, Element.spacing 24 ]
        [ Title.title "Notification Badge" |> Title.withH1 |> Title.toMarkup theme
        , Element.paragraph [ Font.size 14, Font.color (Theme.text theme) ]
            [ Element.text "Notification badges display a count of unread notifications." ]
        , exampleSection theme "Unread"
            (Element.wrappedRow [ Element.spacing 16 ]
                [ NotificationBadge.notificationBadge { count = 5, onClick = noOp } |> NotificationBadge.toMarkup theme
                , NotificationBadge.notificationBadge { count = 99, onClick = noOp } |> NotificationBadge.toMarkup theme
                ]
            )
        , exampleSection theme "Read"
            (NotificationBadge.notificationBadge { count = 3, onClick = noOp }
                |> NotificationBadge.withRead
                |> NotificationBadge.toMarkup theme
            )
        , exampleSection theme "Attention variant"
            (NotificationBadge.notificationBadge { count = 12, onClick = noOp }
                |> NotificationBadge.withAttentionVariant
                |> NotificationBadge.toMarkup theme
            )
        ]


exampleSection : Theme -> String -> Element msg -> Element msg
exampleSection theme title content =
    Card.card [ content ]
        |> Card.withTitle title
        |> Card.toMarkup theme
