module PF6.Divider exposing
    ( Divider, Orientation
    , divider
    , withHorizontal, withVertical
    , withInset, withInsetMd, withInsetLg, withInsetXl
    , toMarkup
    )

{-| PF6 Divider component

A horizontal or vertical rule to visually separate content.

See: <https://www.patternfly.org/components/divider>


# Definition

@docs Divider, Orientation


# Constructor

@docs divider


# Orientation

@docs withHorizontal, withVertical


# Inset modifiers

@docs withInset, withInsetMd, withInsetLg, withInsetXl


# Rendering

@docs toMarkup

-}

import Element exposing (Element)
import Element.Background as Bg
import PF6.Theme as Theme exposing (Theme)
import PF6.Tokens as Tokens


{-| Opaque Divider type
-}
type Divider
    = Divider Options


{-| Divider orientation
-}
type Orientation
    = Horizontal
    | Vertical


type alias Options =
    { orientation : Orientation
    , inset : Int
    }


{-| Construct a horizontal divider
-}
divider : Divider
divider =
    Divider
        { orientation = Horizontal
        , inset = 0
        }


{-| Horizontal divider (default)
-}
withHorizontal : Divider -> Divider
withHorizontal (Divider opts) =
    Divider { opts | orientation = Horizontal }


{-| Vertical divider
-}
withVertical : Divider -> Divider
withVertical (Divider opts) =
    Divider { opts | orientation = Vertical }


{-| Small inset (8px each side)
-}
withInset : Divider -> Divider
withInset (Divider opts) =
    Divider { opts | inset = Tokens.spacerSm }


{-| Medium inset (16px each side)
-}
withInsetMd : Divider -> Divider
withInsetMd (Divider opts) =
    Divider { opts | inset = Tokens.spacerMd }


{-| Large inset (24px each side)
-}
withInsetLg : Divider -> Divider
withInsetLg (Divider opts) =
    Divider { opts | inset = Tokens.spacerLg }


{-| XL inset (32px each side)
-}
withInsetXl : Divider -> Divider
withInsetXl (Divider opts) =
    Divider { opts | inset = Tokens.spacerXl }


{-| Render the Divider as an `Element msg`
-}
toMarkup : Theme -> Divider -> Element msg
toMarkup theme (Divider opts) =
    case opts.orientation of
        Horizontal ->
            Element.el
                [ Element.width Element.fill
                , Element.height (Element.px 1)
                , Bg.color (Theme.borderDefault theme)
                , Element.paddingXY opts.inset 0
                ]
                Element.none

        Vertical ->
            Element.el
                [ Element.width (Element.px 1)
                , Element.height Element.fill
                , Bg.color (Theme.borderDefault theme)
                , Element.paddingXY 0 opts.inset
                ]
                Element.none
