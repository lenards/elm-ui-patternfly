module PF6.NotificationBadge exposing
    ( NotificationBadge
    , notificationBadge
    , withRead, withAttentionVariant, withExpanded
    , toMarkup
    )

{-| PF6 NotificationBadge component

A bell icon with an unread count overlay, used in toolbars and mastheads
to indicate new notifications.

See: <https://www.patternfly.org/components/notification-badge>


# Definition

@docs NotificationBadge


# Constructor

@docs notificationBadge


# Modifiers

@docs withRead, withAttentionVariant, withExpanded


# Rendering

@docs toMarkup

-}

import Element exposing (Element)
import Element.Background as Bg
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import PF6.Tokens as Tokens


{-| Opaque NotificationBadge type
-}
type NotificationBadge msg
    = NotificationBadge (Options msg)


type Variant
    = Unread
    | Read
    | Attention


type alias Options msg =
    { count : Int
    , onClick : msg
    , variant : Variant
    , expanded : Bool
    }


{-| Construct a NotificationBadge

    notificationBadge { count = 5, onClick = ToggleNotifications }

-}
notificationBadge : { count : Int, onClick : msg } -> NotificationBadge msg
notificationBadge { count, onClick } =
    NotificationBadge
        { count = count
        , onClick = onClick
        , variant = Unread
        , expanded = False
        }


{-| Mark notifications as read (no badge highlight)
-}
withRead : NotificationBadge msg -> NotificationBadge msg
withRead (NotificationBadge opts) =
    NotificationBadge { opts | variant = Read }


{-| Use attention variant (danger color for urgent notifications)
-}
withAttentionVariant : NotificationBadge msg -> NotificationBadge msg
withAttentionVariant (NotificationBadge opts) =
    NotificationBadge { opts | variant = Attention }


{-| Set the expanded state (e.g. when notification panel is open)
-}
withExpanded : Bool -> NotificationBadge msg -> NotificationBadge msg
withExpanded isExpanded (NotificationBadge opts) =
    NotificationBadge { opts | expanded = isExpanded }


badgeColor : Variant -> Element.Color
badgeColor variant =
    case variant of
        Unread ->
            Tokens.colorPrimary

        Read ->
            Tokens.colorTextSubtle

        Attention ->
            Tokens.colorDanger


{-| Render the NotificationBadge as an `Element msg`
-}
toMarkup : NotificationBadge msg -> Element msg
toMarkup (NotificationBadge opts) =
    let
        bellIcon =
            Element.el
                [ Font.size Tokens.fontSizeXl
                , Font.color
                    (if opts.expanded then
                        Tokens.colorPrimary

                     else
                        Tokens.colorText
                    )
                ]
                (Element.text "\u{1F514}")

        countBadge =
            if opts.count > 0 then
                Element.el
                    [ Bg.color (badgeColor opts.variant)
                    , Font.color Tokens.colorTextOnDark
                    , Font.size Tokens.fontSizeSm
                    , Font.bold
                    , Border.rounded Tokens.radiusPill
                    , Element.paddingXY 5 2
                    , Element.moveUp 8
                    , Element.moveLeft 8
                    ]
                    (Element.text
                        (if opts.count > 99 then
                            "99+"

                         else
                            String.fromInt opts.count
                        )
                    )

            else
                Element.none
    in
    Input.button
        [ Element.padding Tokens.spacerXs
        , Border.rounded Tokens.radiusMd
        , Border.width 0
        , Bg.color
            (if opts.expanded then
                Tokens.colorBackgroundSecondary

             else
                Element.rgba 0 0 0 0
            )
        ]
        { onPress = Just opts.onClick
        , label =
            Element.row []
                [ bellIcon
                , countBadge
                ]
        }
