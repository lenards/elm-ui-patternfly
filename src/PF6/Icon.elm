module PF6.Icon exposing
    ( Icon, Size, Status
    , icon
    , withSmallSize, withMediumSize, withLargeSize, withXLargeSize
    , withDefaultStatus, withSuccessStatus, withDangerStatus, withWarningStatus, withInfoStatus
    , withAriaLabel, withAriaHidden
    , toMarkup
    )

{-| PF6 Icon component

A wrapper for inline SVG or text-based icons with semantic color status support.

See: <https://www.patternfly.org/components/icon>


# Definition

@docs Icon, Size, Status


# Constructor

@docs icon


# Size modifiers

@docs withSmallSize, withMediumSize, withLargeSize, withXLargeSize


# Status modifiers

@docs withDefaultStatus, withSuccessStatus, withDangerStatus, withWarningStatus, withInfoStatus


# Accessibility modifiers

@docs withAriaLabel, withAriaHidden


# Rendering

@docs toMarkup

-}

import Element exposing (Element)
import Element.Font as Font
import PF6.Tokens as Tokens


{-| Opaque Icon type
-}
type Icon msg
    = Icon (Options msg)


{-| Icon display size
-}
type Size
    = Small
    | Medium
    | Large
    | XLarge


{-| Icon semantic status (controls color)
-}
type Status
    = Default
    | Success
    | Danger
    | Warning
    | Info


type alias Options msg =
    { content : Element msg
    , size : Size
    , status : Status
    , ariaLabel : Maybe String
    , ariaHidden : Bool
    }


{-| Construct an Icon from any elm-ui Element (SVG, text, etc.)
-}
icon : Element msg -> Icon msg
icon content =
    Icon
        { content = content
        , size = Medium
        , status = Default
        , ariaLabel = Nothing
        , ariaHidden = False
        }


{-| Small icon
-}
withSmallSize : Icon msg -> Icon msg
withSmallSize (Icon opts) =
    Icon { opts | size = Small }


{-| Medium icon (default)
-}
withMediumSize : Icon msg -> Icon msg
withMediumSize (Icon opts) =
    Icon { opts | size = Medium }


{-| Large icon
-}
withLargeSize : Icon msg -> Icon msg
withLargeSize (Icon opts) =
    Icon { opts | size = Large }


{-| XLarge icon
-}
withXLargeSize : Icon msg -> Icon msg
withXLargeSize (Icon opts) =
    Icon { opts | size = XLarge }


{-| Default (text) color
-}
withDefaultStatus : Icon msg -> Icon msg
withDefaultStatus (Icon opts) =
    Icon { opts | status = Default }


{-| Success (green) color
-}
withSuccessStatus : Icon msg -> Icon msg
withSuccessStatus (Icon opts) =
    Icon { opts | status = Success }


{-| Danger (red) color
-}
withDangerStatus : Icon msg -> Icon msg
withDangerStatus (Icon opts) =
    Icon { opts | status = Danger }


{-| Warning (yellow) color
-}
withWarningStatus : Icon msg -> Icon msg
withWarningStatus (Icon opts) =
    Icon { opts | status = Warning }


{-| Info (purple) color
-}
withInfoStatus : Icon msg -> Icon msg
withInfoStatus (Icon opts) =
    Icon { opts | status = Info }


{-| Set an accessible label (adds aria-label)
-}
withAriaLabel : String -> Icon msg -> Icon msg
withAriaLabel label (Icon opts) =
    Icon { opts | ariaLabel = Just label }


{-| Hide from screen readers (aria-hidden)
-}
withAriaHidden : Icon msg -> Icon msg
withAriaHidden (Icon opts) =
    Icon { opts | ariaHidden = True }


statusColor : Status -> Element.Color
statusColor status =
    case status of
        Default ->
            Tokens.colorText

        Success ->
            Tokens.colorSuccess

        Danger ->
            Tokens.colorDanger

        Warning ->
            Tokens.colorWarning

        Info ->
            Tokens.colorInfo


sizePx : Size -> Int
sizePx size =
    case size of
        Small ->
            14

        Medium ->
            20

        Large ->
            28

        XLarge ->
            40


{-| Render the Icon as an `Element msg`
-}
toMarkup : Icon msg -> Element msg
toMarkup (Icon opts) =
    let
        px =
            sizePx opts.size
    in
    Element.el
        [ Font.color (statusColor opts.status)
        , Font.size px
        , Element.width (Element.px px)
        , Element.height (Element.px px)
        ]
        opts.content
