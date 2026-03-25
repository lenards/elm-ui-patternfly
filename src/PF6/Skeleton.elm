module PF6.Skeleton exposing
    ( Skeleton, Shape
    , skeleton, circleSkeleton
    , withWidth, withHeight, withFontSize
    , withTextLine, withSquare, withCircle
    , toMarkup
    )

{-| PF6 Skeleton component

Skeletons are loading placeholders that provide a low-fidelity representation
of content before it loads.

See: <https://www.patternfly.org/components/skeleton>


# Definition

@docs Skeleton, Shape


# Constructor

@docs skeleton, circleSkeleton


# Dimension modifiers

@docs withWidth, withHeight, withFontSize


# Shape modifiers

@docs withTextLine, withSquare, withCircle


# Rendering

@docs toMarkup

-}

import Element exposing (Element)
import Html
import Html.Attributes


{-| Opaque Skeleton type
-}
type Skeleton
    = Skeleton Options


{-| Skeleton shape
-}
type Shape
    = TextLine
    | Square
    | Circle


type alias Options =
    { shape : Shape
    , widthPct : Maybe Int
    , widthPx : Maybe Int
    , heightPx : Maybe Int
    , fontSize : Maybe Int
    }


defaultOptions : Options
defaultOptions =
    { shape = TextLine
    , widthPct = Just 100
    , widthPx = Nothing
    , heightPx = Nothing
    , fontSize = Nothing
    }


{-| Construct a text-line skeleton
-}
skeleton : Skeleton
skeleton =
    Skeleton defaultOptions


{-| Construct a circle skeleton
-}
circleSkeleton : Skeleton
circleSkeleton =
    Skeleton { defaultOptions | shape = Circle, widthPx = Just 64, heightPx = Just 64, widthPct = Nothing }


{-| Set width as a percentage (1–100)
-}
withWidth : Int -> Skeleton -> Skeleton
withWidth pct (Skeleton opts) =
    Skeleton { opts | widthPct = Just (clamp 1 100 pct), widthPx = Nothing }


{-| Set width in pixels
-}
withHeight : Int -> Skeleton -> Skeleton
withHeight px (Skeleton opts) =
    Skeleton { opts | heightPx = Just px }


{-| Set font size — used to calculate text-line height
-}
withFontSize : Int -> Skeleton -> Skeleton
withFontSize px (Skeleton opts) =
    Skeleton { opts | fontSize = Just px }


{-| Text line shape (default)
-}
withTextLine : Skeleton -> Skeleton
withTextLine (Skeleton opts) =
    Skeleton { opts | shape = TextLine }


{-| Square shape
-}
withSquare : Skeleton -> Skeleton
withSquare (Skeleton opts) =
    Skeleton { opts | shape = Square }


{-| Circle shape
-}
withCircle : Skeleton -> Skeleton
withCircle (Skeleton opts) =
    Skeleton { opts | shape = Circle }


{-| Render the Skeleton as an `Element msg`
-}
toMarkup : Skeleton -> Element msg
toMarkup (Skeleton opts) =
    let
        widthStyle =
            case opts.widthPx of
                Just px ->
                    String.fromInt px ++ "px"

                Nothing ->
                    case opts.widthPct of
                        Just pct ->
                            String.fromInt pct ++ "%"

                        Nothing ->
                            "100%"

        heightStyle =
            case opts.heightPx of
                Just px ->
                    String.fromInt px ++ "px"

                Nothing ->
                    case opts.fontSize of
                        Just fs ->
                            String.fromInt fs ++ "px"

                        Nothing ->
                            case opts.shape of
                                TextLine ->
                                    "1em"

                                _ ->
                                    "64px"

        borderRadius =
            case opts.shape of
                Circle ->
                    "50%"

                _ ->
                    "4px"

        skeletonHtml =
            Html.span
                [ Html.Attributes.style "display" "inline-block"
                , Html.Attributes.style "width" widthStyle
                , Html.Attributes.style "height" heightStyle
                , Html.Attributes.style "background-color" "#e0e0e0"
                , Html.Attributes.style "border-radius" borderRadius
                , Html.Attributes.style "background" "linear-gradient(90deg, #e0e0e0 25%, #f0f0f0 50%, #e0e0e0 75%)"
                , Html.Attributes.style "background-size" "200% 100%"
                , Html.Attributes.style "animation" "pf6-shimmer 1.5s infinite"
                ]
                []

        styleEl =
            Html.node "style"
                []
                [ Html.text "@keyframes pf6-shimmer { 0% { background-position: 200% 0; } 100% { background-position: -200% 0; } }" ]
    in
    Element.html
        (Html.span []
            [ styleEl
            , skeletonHtml
            ]
        )
