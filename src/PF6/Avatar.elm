module PF6.Avatar exposing
    ( Avatar, Size
    , avatar
    , withSmallSize, withMediumSize, withLargeSize, withXLargeSize
    , withBorder
    , toMarkup
    )

{-| PF6 Avatar component

Displays a user's profile image with optional border, in various sizes.

See: <https://www.patternfly.org/components/avatar>


# Definition

@docs Avatar, Size


# Constructor

@docs avatar


# Size modifiers

@docs withSmallSize, withMediumSize, withLargeSize, withXLargeSize


# Style modifiers

@docs withBorder


# Rendering

@docs toMarkup

-}

import Element exposing (Element)
import Element.Border as Border
import PF6.Theme as Theme exposing (Theme)


{-| Opaque Avatar type
-}
type Avatar
    = Avatar Options


{-| Avatar size variants
-}
type Size
    = Small
    | Medium
    | Large
    | XLarge


type alias Options =
    { src : String
    , alt : String
    , size : Size
    , hasBorder : Bool
    }


{-| Construct an Avatar from an image src and alt text
-}
avatar : { src : String, alt : String } -> Avatar
avatar { src, alt } =
    Avatar
        { src = src
        , alt = alt
        , size = Medium
        , hasBorder = False
        }


{-| Small avatar — 24px
-}
withSmallSize : Avatar -> Avatar
withSmallSize (Avatar opts) =
    Avatar { opts | size = Small }


{-| Medium avatar — 36px (default)
-}
withMediumSize : Avatar -> Avatar
withMediumSize (Avatar opts) =
    Avatar { opts | size = Medium }


{-| Large avatar — 72px
-}
withLargeSize : Avatar -> Avatar
withLargeSize (Avatar opts) =
    Avatar { opts | size = Large }


{-| XLarge avatar — 128px
-}
withXLargeSize : Avatar -> Avatar
withXLargeSize (Avatar opts) =
    Avatar { opts | size = XLarge }


{-| Add a border around the avatar
-}
withBorder : Avatar -> Avatar
withBorder (Avatar opts) =
    Avatar { opts | hasBorder = True }


sizePx : Size -> Int
sizePx size =
    case size of
        Small ->
            24

        Medium ->
            36

        Large ->
            72

        XLarge ->
            128


{-| Render the Avatar as an `Element msg`
-}
toMarkup : Theme -> Avatar -> Element msg
toMarkup theme (Avatar opts) =
    let
        px =
            sizePx opts.size

        borderAttrs =
            if opts.hasBorder then
                [ Border.rounded (px // 2)
                , Border.solid
                , Border.width 2
                , Border.color (Theme.borderDefault theme)
                ]

            else
                [ Border.rounded (px // 2) ]
    in
    Element.image
        ([ Element.width (Element.px px)
         , Element.height (Element.px px)
         ]
            ++ borderAttrs
        )
        { src = opts.src
        , description = opts.alt
        }
