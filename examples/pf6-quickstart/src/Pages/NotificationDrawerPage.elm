module Pages.NotificationDrawerPage exposing (view)

import Element exposing (Element)
import Element.Font as Font
import PF6.Card as Card
import PF6.NotificationDrawer as NotificationDrawer
import PF6.Title as Title
import PF6.Tokens as Tokens


view : msg -> Element msg
view noOp =
    Element.column [ Element.width Element.fill, Element.spacing 24 ]
        [ Title.title "Notification Drawer" |> Title.withH1 |> Title.toMarkup
        , Element.paragraph [ Font.size 14, Font.color Tokens.colorText ]
            [ Element.text "A notification drawer surfaces a list of notifications to the user." ]
        , exampleSection "Basic notification drawer"
            (NotificationDrawer.notificationDrawer
                { isOpen = True
                , onClose = noOp
                , items =
                    [ NotificationDrawer.notificationItem "Your build completed successfully."
                        |> NotificationDrawer.withTitle "Build complete"
                        |> NotificationDrawer.withTimestamp "2 minutes ago"
                        |> NotificationDrawer.withSuccess
                    , NotificationDrawer.notificationItem "Deployment is pending approval."
                        |> NotificationDrawer.withTitle "Deployment pending"
                        |> NotificationDrawer.withTimestamp "10 minutes ago"
                        |> NotificationDrawer.withWarning
                        |> NotificationDrawer.withUnread
                    , NotificationDrawer.notificationItem "Server health check failed."
                        |> NotificationDrawer.withTitle "Health check failed"
                        |> NotificationDrawer.withTimestamp "1 hour ago"
                        |> NotificationDrawer.withDanger
                        |> NotificationDrawer.withUnread
                    ]
                }
                |> NotificationDrawer.toMarkup
            )
        ]


exampleSection : String -> Element msg -> Element msg
exampleSection title content =
    Card.card [ content ]
        |> Card.withTitle title
        |> Card.toMarkup
