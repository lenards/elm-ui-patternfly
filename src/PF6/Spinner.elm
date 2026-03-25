module PF6.Spinner exposing
    ( Spinner, Size
    , spinner
    , withSmallSize, withMediumSize, withLargeSize, withXLargeSize
    , withAriaLabel
    , toMarkup
    )

{-| PF6 Spinner component

Spinners are used to indicate that content is loading.

See: <https://www.patternfly.org/components/spinner>


# Definition

@docs Spinner, Size


# Constructor

@docs spinner


# Size modifiers

@docs withSmallSize, withMediumSize, withLargeSize, withXLargeSize


# Accessibility

@docs withAriaLabel


# Rendering

@docs toMarkup

-}

import Element exposing (Element)
import Html
import Html.Attributes
import PF6.Theme exposing (Theme)


{-| Opaque Spinner type
-}
type Spinner
    = Spinner Options


{-| Spinner size
-}
type Size
    = Small
    | Medium
    | Large
    | XLarge


type alias Options =
    { size : Size
    , ariaLabel : String
    }


{-| Construct a default medium spinner
-}
spinner : Spinner
spinner =
    Spinner
        { size = Medium
        , ariaLabel = "Loading..."
        }


{-| Small spinner — 1rem
-}
withSmallSize : Spinner -> Spinner
withSmallSize (Spinner opts) =
    Spinner { opts | size = Small }


{-| Medium spinner — 1.5rem (default)
-}
withMediumSize : Spinner -> Spinner
withMediumSize (Spinner opts) =
    Spinner { opts | size = Medium }


{-| Large spinner — 3rem
-}
withLargeSize : Spinner -> Spinner
withLargeSize (Spinner opts) =
    Spinner { opts | size = Large }


{-| XLarge spinner — 3.75rem
-}
withXLargeSize : Spinner -> Spinner
withXLargeSize (Spinner opts) =
    Spinner { opts | size = XLarge }


{-| Set the accessible label for screen readers
-}
withAriaLabel : String -> Spinner -> Spinner
withAriaLabel label (Spinner opts) =
    Spinner { opts | ariaLabel = label }


sizePx : Size -> Int
sizePx size =
    case size of
        Small ->
            16

        Medium ->
            24

        Large ->
            48

        XLarge ->
            60


{-| Render the Spinner as an `Element msg`

Uses CSS animation via inline HTML for the spinning effect.
The spinner is a circle with a colored arc rotating via CSS.

-}
toMarkup : Theme -> Spinner -> Element msg
toMarkup _ (Spinner opts) =
    let
        px =
            sizePx opts.size

        pxStr =
            String.fromInt px ++ "px"

        borderPx =
            max 2 (px // 8)

        borderStr =
            String.fromInt borderPx ++ "px"

        spinnerHtml =
            Html.span
                [ Html.Attributes.style "display" "inline-block"
                , Html.Attributes.style "width" pxStr
                , Html.Attributes.style "height" pxStr
                , Html.Attributes.style "border" (borderStr ++ " solid #e0e0e0")
                , Html.Attributes.style "border-top-color" "#0066CC"
                , Html.Attributes.style "border-radius" "50%"
                , Html.Attributes.style "animation" "pf6-spin 0.75s linear infinite"
                , Html.Attributes.attribute "aria-label" opts.ariaLabel
                , Html.Attributes.attribute "role" "progressbar"
                ]
                []

        styleEl =
            Html.node "style"
                []
                [ Html.text "@keyframes pf6-spin { from { transform: rotate(0deg); } to { transform: rotate(360deg); } }" ]
    in
    Element.html
        (Html.span []
            [ styleEl
            , spinnerHtml
            ]
        )
