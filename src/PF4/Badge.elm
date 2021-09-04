module PF4.Badge exposing
    ( Badge
    , Status
    , badge
    , isRead
    , isUnread
    , readCombo
    , toMarkup
    , unreadBadge
    , unreadCombo
    , withReadStatus
    , withUnreadStatus
    )

import Element exposing (Element)
import Element.Background as Bg
import Element.Border as Border
import Element.Font as Font


type Badge
    = Badge Options


type Status
    = Read
    | Unread


type alias Options =
    { value : Int
    , overflowAt : Int
    , status : Status
    , background : Element.Color
    , foreground : Element.Color
    }


type alias ColorCombo =
    { background : Element.Color
    , foreground : Element.Color
    }


readCombo : ColorCombo
readCombo =
    { background = Element.rgb255 240 240 240
    , foreground = Element.rgb255 21 21 21
    }


unreadCombo : ColorCombo
unreadCombo =
    { background = Element.rgb255 0 102 204
    , foreground = Element.rgb255 255 255 255
    }


defaultOverflowAt : Int
defaultOverflowAt =
    999


badge : Int -> Badge
badge value =
    Badge
        { value = value
        , overflowAt = defaultOverflowAt
        , status = Read
        , background = readCombo.background
        , foreground = readCombo.foreground
        }


unreadBadge : Int -> Badge
unreadBadge value =
    badge value
        |> withUnreadStatus


withUnreadStatus : Badge -> Badge
withUnreadStatus (Badge options) =
    Badge
        { options
            | status = Unread
            , background = unreadCombo.background
            , foreground = unreadCombo.foreground
        }


withReadStatus : Badge -> Badge
withReadStatus (Badge options) =
    Badge
        { options
            | status = Read
            , background = readCombo.background
            , foreground = readCombo.foreground
        }


isRead : Badge -> Bool
isRead (Badge options) =
    options.status == Read


isUnread : Badge -> Bool
isUnread (Badge options) =
    options.status == Unread


toMarkup : Badge -> Element msg
toMarkup (Badge options) =
    let
        attrs_ =
            [ Element.paddingXY 8 2
            , Border.rounded 30
            , Bg.color options.background
            , Font.color options.foreground
            ]

        val =
            if options.value > options.overflowAt then
                "999+"

            else
                String.fromInt options.value
    in
    Element.el attrs_ <| Element.text val
