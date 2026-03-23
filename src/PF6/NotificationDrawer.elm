module PF6.NotificationDrawer exposing
    ( NotificationDrawer, NotificationItem, Variant
    , notificationDrawer
    , notificationItem
    , withTitle, withTimestamp, withRead, withUnread, withVariant
    , withSuccess, withWarning, withDanger, withInfo
    , withOnRead, withOnClear, withOnMarkAllRead
    , withCustomHeader
    , toMarkup
    )

{-| PF6 NotificationDrawer component

The notification drawer is a slide-out panel that displays a list of
notifications, alerts, and messages. Typically triggered by a bell icon
in the masthead.

See: <https://www.patternfly.org/components/notification-drawer>


# Definition

@docs NotificationDrawer, NotificationItem, Variant


# Constructor

@docs notificationDrawer


# Item constructor

@docs notificationItem


# Item modifiers

@docs withTitle, withTimestamp, withRead, withUnread, withVariant
@docs withSuccess, withWarning, withDanger, withInfo


# Behavior

@docs withOnRead, withOnClear, withOnMarkAllRead


# Header

@docs withCustomHeader


# Rendering

@docs toMarkup

-}

import Element exposing (Element)
import Element.Background as Bg
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import PF6.Tokens as Tokens


{-| Opaque NotificationDrawer type
-}
type NotificationDrawer msg
    = NotificationDrawer (Options msg)


{-| A single notification entry
-}
type NotificationItem msg
    = NotificationItem (ItemOptions msg)


{-| Notification severity variant
-}
type Variant
    = Default
    | Success
    | Warning
    | Danger
    | Info


type alias ItemOptions msg =
    { title : String
    , body : Maybe (Element msg)
    , timestamp : Maybe String
    , isRead : Bool
    , variant : Variant
    , onRead : Maybe msg
    , onClear : Maybe msg
    }


type alias Options msg =
    { isOpen : Bool
    , items : List (NotificationItem msg)
    , heading : String
    , onMarkAllRead : Maybe msg
    , onClose : Maybe msg
    , customHeader : Maybe (Element msg)
    }


{-| Construct a NotificationDrawer

    notificationDrawer
        { isOpen = model.notifDrawerOpen
        , items = [ item1, item2 ]
        , onClose = NotifDrawerClose
        }

-}
notificationDrawer :
    { isOpen : Bool
    , items : List (NotificationItem msg)
    , onClose : msg
    }
    -> NotificationDrawer msg
notificationDrawer config =
    NotificationDrawer
        { isOpen = config.isOpen
        , items = config.items
        , heading = "Notifications"
        , onMarkAllRead = Nothing
        , onClose = Just config.onClose
        , customHeader = Nothing
        }


{-| Construct a notification item

    notificationItem "Deployment complete"

-}
notificationItem : String -> NotificationItem msg
notificationItem title =
    NotificationItem
        { title = title
        , body = Nothing
        , timestamp = Nothing
        , isRead = False
        , variant = Default
        , onRead = Nothing
        , onClear = Nothing
        }


{-| Set the notification item title
-}
withTitle : String -> NotificationItem msg -> NotificationItem msg
withTitle t (NotificationItem opts) =
    NotificationItem { opts | title = t }


{-| Set a timestamp string
-}
withTimestamp : String -> NotificationItem msg -> NotificationItem msg
withTimestamp ts (NotificationItem opts) =
    NotificationItem { opts | timestamp = Just ts }


{-| Mark the item as read
-}
withRead : NotificationItem msg -> NotificationItem msg
withRead (NotificationItem opts) =
    NotificationItem { opts | isRead = True }


{-| Mark the item as unread (default)
-}
withUnread : NotificationItem msg -> NotificationItem msg
withUnread (NotificationItem opts) =
    NotificationItem { opts | isRead = False }


{-| Set the severity variant explicitly
-}
withVariant : Variant -> NotificationItem msg -> NotificationItem msg
withVariant v (NotificationItem opts) =
    NotificationItem { opts | variant = v }


{-| Success variant
-}
withSuccess : NotificationItem msg -> NotificationItem msg
withSuccess =
    withVariant Success


{-| Warning variant
-}
withWarning : NotificationItem msg -> NotificationItem msg
withWarning =
    withVariant Warning


{-| Danger variant
-}
withDanger : NotificationItem msg -> NotificationItem msg
withDanger =
    withVariant Danger


{-| Info variant
-}
withInfo : NotificationItem msg -> NotificationItem msg
withInfo =
    withVariant Info


{-| Set a message to send when the item is marked as read
-}
withOnRead : msg -> NotificationItem msg -> NotificationItem msg
withOnRead msg (NotificationItem opts) =
    NotificationItem { opts | onRead = Just msg }


{-| Set a message to send when the item is cleared/dismissed
-}
withOnClear : msg -> NotificationItem msg -> NotificationItem msg
withOnClear msg (NotificationItem opts) =
    NotificationItem { opts | onClear = Just msg }


{-| Set a message to send when "Mark all read" is clicked
-}
withOnMarkAllRead : msg -> NotificationDrawer msg -> NotificationDrawer msg
withOnMarkAllRead msg (NotificationDrawer opts) =
    NotificationDrawer { opts | onMarkAllRead = Just msg }


{-| Replace the default header with a custom element
-}
withCustomHeader : Element msg -> NotificationDrawer msg -> NotificationDrawer msg
withCustomHeader el (NotificationDrawer opts) =
    NotificationDrawer { opts | customHeader = Just el }


variantColor : Variant -> Element.Color
variantColor variant =
    case variant of
        Default ->
            Tokens.colorText

        Success ->
            Tokens.colorSuccess

        Warning ->
            Tokens.colorWarning

        Danger ->
            Tokens.colorDanger

        Info ->
            Tokens.colorInfo


variantIcon : Variant -> String
variantIcon variant =
    case variant of
        Default ->
            "●"

        Success ->
            "✓"

        Warning ->
            "⚠"

        Danger ->
            "✕"

        Info ->
            "ℹ"


renderItem : NotificationItem msg -> Element msg
renderItem (NotificationItem opts) =
    Element.row
        [ Element.width Element.fill
        , Element.padding Tokens.spacerMd
        , Element.spacing Tokens.spacerSm
        , Bg.color
            (if opts.isRead then
                Tokens.colorBackgroundDefault

             else
                Element.rgb255 240 247 255
            )
        , Border.widthEach { top = 0, right = 0, bottom = 1, left = 0 }
        , Border.color Tokens.colorBorderDefault
        ]
        [ -- Variant icon
          Element.el
            [ Font.color (variantColor opts.variant)
            , Font.size Tokens.fontSizeMd
            , Element.alignTop
            ]
            (Element.text (variantIcon opts.variant))

        -- Content
        , Element.column
            [ Element.width Element.fill
            , Element.spacing Tokens.spacerXs
            ]
            [ -- Title row
              Element.row [ Element.width Element.fill, Element.spacing Tokens.spacerSm ]
                [ Element.el
                    [ Font.size Tokens.fontSizeMd
                    , Font.color Tokens.colorText
                    , if opts.isRead then
                        Font.regular

                      else
                        Font.bold
                    , Element.width Element.fill
                    ]
                    (Element.text opts.title)
                , case opts.onClear of
                    Just clearMsg ->
                        Input.button
                            [ Font.color Tokens.colorTextSubtle
                            , Font.size Tokens.fontSizeSm
                            ]
                            { onPress = Just clearMsg
                            , label = Element.text "×"
                            }

                    Nothing ->
                        Element.none
                ]

            -- Timestamp
            , case opts.timestamp of
                Just ts ->
                    Element.el
                        [ Font.size Tokens.fontSizeSm
                        , Font.color Tokens.colorTextSubtle
                        ]
                        (Element.text ts)

                Nothing ->
                    Element.none

            -- Body
            , case opts.body of
                Just bodyEl ->
                    bodyEl

                Nothing ->
                    Element.none
            ]
        ]


drawerHeader : Options msg -> Element msg
drawerHeader opts =
    case opts.customHeader of
        Just el ->
            el

        Nothing ->
            Element.row
                [ Element.width Element.fill
                , Element.paddingXY Tokens.spacerMd Tokens.spacerSm
                , Border.widthEach { top = 0, right = 0, bottom = 1, left = 0 }
                , Border.color Tokens.colorBorderDefault
                , Bg.color Tokens.colorBackgroundSecondary
                ]
                [ Element.el
                    [ Font.bold
                    , Font.size Tokens.fontSizeLg
                    , Font.color Tokens.colorText
                    , Element.width Element.fill
                    ]
                    (Element.text opts.heading)
                , Element.row [ Element.spacing Tokens.spacerSm ]
                    [ case opts.onMarkAllRead of
                        Just markMsg ->
                            Input.button
                                [ Font.size Tokens.fontSizeSm
                                , Font.color Tokens.colorPrimary
                                ]
                                { onPress = Just markMsg
                                , label = Element.text "Mark all read"
                                }

                        Nothing ->
                            Element.none
                    , case opts.onClose of
                        Just closeMsg ->
                            Input.button
                                [ Font.size Tokens.fontSizeMd
                                , Font.color Tokens.colorTextSubtle
                                ]
                                { onPress = Just closeMsg
                                , label = Element.text "×"
                                }

                        Nothing ->
                            Element.none
                    ]
                ]


{-| Render the NotificationDrawer as an `Element msg`

When `isOpen` is `False`, nothing is rendered. When `True`, a fixed-width
panel is rendered on the right side. Use `Element.inFront` or a layout
column to position it alongside your main content.

-}
toMarkup : NotificationDrawer msg -> Element msg
toMarkup (NotificationDrawer opts) =
    if not opts.isOpen then
        Element.none

    else
        Element.column
            [ Element.width (Element.px 400)
            , Element.height Element.fill
            , Bg.color Tokens.colorBackgroundDefault
            , Border.widthEach { top = 0, right = 0, bottom = 0, left = 1 }
            , Border.color Tokens.colorBorderDefault
            , Border.shadow
                { offset = ( -4, 0 )
                , size = 0
                , blur = 16
                , color = Element.rgba 0 0 0 0.1
                }
            ]
            [ drawerHeader opts
            , Element.column
                [ Element.width Element.fill
                , Element.height Element.fill
                , Element.scrollbarY
                ]
                (if List.isEmpty opts.items then
                    [ Element.el
                        [ Element.centerX
                        , Element.centerY
                        , Element.padding Tokens.spacerXl
                        , Font.color Tokens.colorTextSubtle
                        , Font.size Tokens.fontSizeMd
                        ]
                        (Element.text "No notifications")
                    ]

                 else
                    List.map renderItem opts.items
                )
            ]
