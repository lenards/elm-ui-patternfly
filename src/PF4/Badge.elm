module PF4.Badge exposing
    ( Badge
    , badge, unreadBadge
    , Status, withReadStatus, withUnreadStatus
    , isRead, isUnread
    , toMarkup
    )

{-| An element for showing off numbers in various scenarios

The `PF4.Badge` comes in handy when rendering notifications or alerts
that have been "read" or "unread" in the form of a "pill" element
since in other design systems.


# Definition

@docs Badge


# Constructor functions

@docs badge, unreadBadge


# Configuration functions

@docs Status, withReadStatus, withUnreadStatus


# Checking value

@docs isRead, isUnread


# Rendering stateless element

@docs toMarkup

<https://www.patternfly.org/v4/components/badge>

-}

import Element exposing (Element)
import Element.Background as Bg
import Element.Border as Border
import Element.Font as Font


{-| Opaque `Badge` element
-}
type Badge
    = Badge Options


{-| Defines `Status` to be one of two values: `Read` or `Unread`
-}
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


{-| Constructs a `Badge`

Default `status` of the `Badge` will be `Read`.

-}
badge : Int -> Badge
badge value =
    Badge
        { value = value
        , overflowAt = defaultOverflowAt
        , status = Read
        , background = readCombo.background
        , foreground = readCombo.foreground
        }


{-| Configures the `Badge` to have an `Unread` status
-}
unreadBadge : Int -> Badge
unreadBadge value =
    badge value
        |> withUnreadStatus


{-| Configures `Badge` to have a `Unread` status
-}
withUnreadStatus : Badge -> Badge
withUnreadStatus (Badge options) =
    Badge
        { options
            | status = Unread
            , background = unreadCombo.background
            , foreground = unreadCombo.foreground
        }


{-| Configures `Badge` to have a `Read` status
-}
withReadStatus : Badge -> Badge
withReadStatus (Badge options) =
    Badge
        { options
            | status = Read
            , background = readCombo.background
            , foreground = readCombo.foreground
        }


{-| Indicates if the status of the `Badge` is `Read`
-}
isRead : Badge -> Bool
isRead (Badge options) =
    options.status == Read


{-| Indicates if the status of the `Badge` is `Unread`
-}
isUnread : Badge -> Bool
isUnread (Badge options) =
    options.status == Unread


{-| Given the custom type representation, renders as an `Element msg`.
-}
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
