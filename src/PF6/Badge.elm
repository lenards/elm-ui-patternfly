module PF6.Badge exposing
    ( Badge, Status
    , badge, unreadBadge
    , withReadStatus, withUnreadStatus
    , withOverflowAt
    , isRead, isUnread
    , toMarkup
    )

{-| PF6 Badge component

Displays counts or status indicators as pill-shaped elements.

See: <https://www.patternfly.org/components/badge>


# Definition

@docs Badge, Status


# Constructor functions

@docs badge, unreadBadge


# Configuration functions

@docs withReadStatus, withUnreadStatus
@docs withOverflowAt


# Predicates

@docs isRead, isUnread


# Rendering

@docs toMarkup

-}

import Element exposing (Element)
import Element.Background as Bg
import Element.Border as Border
import Element.Font as Font
import PF6.Tokens as Tokens


{-| Opaque Badge type
-}
type Badge
    = Badge Options


{-| Read or Unread status
-}
type Status
    = Read
    | Unread


type alias Options =
    { value : Int
    , overflowAt : Int
    , status : Status
    }


{-| Construct a Badge with a read status
-}
badge : Int -> Badge
badge value =
    Badge
        { value = value
        , overflowAt = 999
        , status = Read
        }


{-| Construct a Badge with unread status
-}
unreadBadge : Int -> Badge
unreadBadge value =
    badge value |> withUnreadStatus


{-| Set status to Unread (blue background)
-}
withUnreadStatus : Badge -> Badge
withUnreadStatus (Badge opts) =
    Badge { opts | status = Unread }


{-| Set status to Read (gray background)
-}
withReadStatus : Badge -> Badge
withReadStatus (Badge opts) =
    Badge { opts | status = Read }


{-| Set the overflow threshold. Counts above this show as "N+"
-}
withOverflowAt : Int -> Badge -> Badge
withOverflowAt n (Badge opts) =
    Badge { opts | overflowAt = n }


{-| True if badge status is Read
-}
isRead : Badge -> Bool
isRead (Badge opts) =
    opts.status == Read


{-| True if badge status is Unread
-}
isUnread : Badge -> Bool
isUnread (Badge opts) =
    opts.status == Unread


{-| Render the Badge as an `Element msg`
-}
toMarkup : Badge -> Element msg
toMarkup (Badge opts) =
    let
        ( bg, fg ) =
            case opts.status of
                Read ->
                    ( Tokens.colorNeutral, Tokens.colorText )

                Unread ->
                    ( Tokens.colorPrimary, Tokens.colorTextOnDark )

        displayValue =
            if opts.value > opts.overflowAt then
                String.fromInt opts.overflowAt ++ "+"

            else
                String.fromInt opts.value
    in
    Element.el
        [ Bg.color bg
        , Font.color fg
        , Font.size Tokens.fontSizeSm
        , Font.bold
        , Border.rounded Tokens.radiusPill
        , Element.paddingXY Tokens.spacerSm Tokens.spacerXs
        ]
        (Element.text displayValue)
