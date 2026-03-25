module PF6.Progress exposing
    ( Progress, Size, Status
    , progress
    , withTitle, withHelperText
    , withSmallSize, withLargeSize
    , withSuccess, withDanger, withWarning, withInfo
    , withInside, withOutside, withNone
    , toMarkup
    )

{-| PF6 Progress component

Progress bars communicate the status of an ongoing process.

See: <https://www.patternfly.org/components/progress>


# Definition

@docs Progress, Size, Status


# Constructor

@docs progress


# Label modifiers

@docs withTitle, withHelperText


# Size modifiers

@docs withSmallSize, withLargeSize


# Status modifiers

@docs withSuccess, withDanger, withWarning, withInfo


# Measure label position

@docs withInside, withOutside, withNone


# Rendering

@docs toMarkup

-}

import Element exposing (Element)
import Element.Background as Bg
import Element.Border as Border
import Element.Font as Font
import PF6.Theme as Theme exposing (Theme)
import PF6.Tokens as Tokens


{-| Opaque Progress type
-}
type Progress
    = Progress Options


{-| Bar size
-}
type Size
    = SmallBar
    | DefaultBar
    | LargeBar


{-| Status variant affects bar color
-}
type Status
    = StatusDefault
    | Success
    | Danger
    | Warning
    | Info


type MeasureLocation
    = Outside
    | Inside
    | NoMeasure


type alias Options =
    { value : Float
    , title : Maybe String
    , helperText : Maybe String
    , barSize : Size
    , status : Status
    , measureLocation : MeasureLocation
    }


{-| Construct a Progress bar with a value 0–100
-}
progress : Float -> Progress
progress value =
    Progress
        { value = clamp 0 100 value
        , title = Nothing
        , helperText = Nothing
        , barSize = DefaultBar
        , status = StatusDefault
        , measureLocation = Outside
        }


{-| Set a title above the bar
-}
withTitle : String -> Progress -> Progress
withTitle t (Progress opts) =
    Progress { opts | title = Just t }


{-| Set helper text below the bar
-}
withHelperText : String -> Progress -> Progress
withHelperText t (Progress opts) =
    Progress { opts | helperText = Just t }


{-| Small bar height
-}
withSmallSize : Progress -> Progress
withSmallSize (Progress opts) =
    Progress { opts | barSize = SmallBar }


{-| Large bar height
-}
withLargeSize : Progress -> Progress
withLargeSize (Progress opts) =
    Progress { opts | barSize = LargeBar }


{-| Success status (green bar)
-}
withSuccess : Progress -> Progress
withSuccess (Progress opts) =
    Progress { opts | status = Success }


{-| Danger status (red bar)
-}
withDanger : Progress -> Progress
withDanger (Progress opts) =
    Progress { opts | status = Danger }


{-| Warning status (yellow bar)
-}
withWarning : Progress -> Progress
withWarning (Progress opts) =
    Progress { opts | status = Warning }


{-| Info status (purple bar)
-}
withInfo : Progress -> Progress
withInfo (Progress opts) =
    Progress { opts | status = Info }


{-| Show percentage inside the bar
-}
withInside : Progress -> Progress
withInside (Progress opts) =
    Progress { opts | measureLocation = Inside }


{-| Show percentage outside (above-right) the bar
-}
withOutside : Progress -> Progress
withOutside (Progress opts) =
    Progress { opts | measureLocation = Outside }


{-| Hide the percentage label
-}
withNone : Progress -> Progress
withNone (Progress opts) =
    Progress { opts | measureLocation = NoMeasure }


barColor : Theme -> Status -> Element.Color
barColor theme status =
    case status of
        StatusDefault ->
            Theme.primary theme

        Success ->
            Theme.success theme

        Danger ->
            Theme.danger theme

        Warning ->
            Theme.warning theme

        Info ->
            Theme.info theme


barHeight : Size -> Int
barHeight size =
    case size of
        SmallBar ->
            6

        DefaultBar ->
            8

        LargeBar ->
            16


{-| Render the Progress as an `Element msg`
-}
toMarkup : Theme -> Progress -> Element msg
toMarkup theme (Progress opts) =
    let
        pct =
            String.fromInt (round opts.value) ++ "%"

        titleEl =
            opts.title
                |> Maybe.map
                    (\t ->
                        Element.el
                            [ Font.size Tokens.fontSizeMd
                            , Font.color (Theme.text theme)
                            , Element.paddingEach { top = 0, right = 0, bottom = Tokens.spacerXs, left = 0 }
                            ]
                            (Element.text t)
                    )
                |> Maybe.withDefault Element.none

        outsideLabelEl =
            case opts.measureLocation of
                Outside ->
                    Element.el
                        [ Font.size Tokens.fontSizeSm
                        , Font.color (Theme.textSubtle theme)
                        ]
                        (Element.text pct)

                _ ->
                    Element.none

        heightPx =
            barHeight opts.barSize

        fillColor =
            barColor theme opts.status

        trackEl =
            Element.el
                [ Element.width Element.fill
                , Element.height (Element.px heightPx)
                , Bg.color (Theme.neutral theme)
                , Border.rounded (heightPx // 2)
                ]
                (Element.el
                    [ Element.width (Element.fillPortion (round opts.value))
                    , Element.height Element.fill
                    , Bg.color fillColor
                    , Border.rounded (heightPx // 2)
                    ]
                    Element.none
                )

        measureRow =
            case opts.measureLocation of
                Outside ->
                    Element.row
                        [ Element.width Element.fill
                        , Element.paddingEach { top = 0, right = 0, bottom = Tokens.spacerXs, left = 0 }
                        ]
                        [ titleEl
                        , Element.el [ Element.alignRight ] outsideLabelEl
                        ]

                _ ->
                    titleEl

        helperEl =
            opts.helperText
                |> Maybe.map
                    (\t ->
                        Element.el
                            [ Font.size Tokens.fontSizeSm
                            , Font.color (Theme.textSubtle theme)
                            , Element.paddingEach { top = Tokens.spacerXs, right = 0, bottom = 0, left = 0 }
                            ]
                            (Element.text t)
                    )
                |> Maybe.withDefault Element.none
    in
    Element.column
        [ Element.width Element.fill ]
        [ measureRow
        , trackEl
        , helperEl
        ]
