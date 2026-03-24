module PF6.Tokens exposing
    ( -- Colors
      colorPrimary
    , colorPrimaryHover
    , colorDanger
    , colorDangerHover
    , colorWarning
    , colorWarningHover
    , colorSuccess
    , colorSuccessHover
    , colorInfo
    , colorInfoHover
    , colorNeutral
    , colorNeutralHover
      -- Text colors
    , colorText
    , colorTextSubtle
    , colorTextOnDark
      -- Background colors
    , colorBackgroundDefault
    , colorBackgroundSecondary
    , colorBackgroundPrimary
    , colorBackgroundDanger
    , colorBackgroundWarning
    , colorBackgroundSuccess
    , colorBackgroundInfo
      -- Border colors
    , colorBorderDefault
    , colorBorderSubtle
      -- Spacing
    , spacerXs
    , spacerSm
    , spacerMd
    , spacerLg
    , spacerXl
    , spacer2xl
    , spacer3xl
    , spacer4xl
      -- Border radius
    , radiusSm
    , radiusMd
    , radiusLg
    , radiusPill
      -- Font sizes
    , fontSizeSm
    , fontSizeMd
    , fontSizeLg
    , fontSizeXl
    , fontSize2xl
    , fontSize3xl
    , fontSize4xl
    )

{-| PF6 design tokens encoded as Elm values.

All colors sourced from the PatternFly 6 token system.
See: <https://www.patternfly.org/tokens/all-patternfly-tokens>


# Semantic Colors

@docs colorPrimary, colorPrimaryHover
@docs colorDanger, colorDangerHover
@docs colorWarning, colorWarningHover
@docs colorSuccess, colorSuccessHover
@docs colorInfo, colorInfoHover
@docs colorNeutral, colorNeutralHover


# Text Colors

@docs colorText, colorTextSubtle, colorTextOnDark


# Background Colors

@docs colorBackgroundDefault, colorBackgroundSecondary, colorBackgroundPrimary
@docs colorBackgroundDanger, colorBackgroundWarning, colorBackgroundSuccess, colorBackgroundInfo


# Border Colors

@docs colorBorderDefault, colorBorderSubtle


# Spacing

@docs spacerXs, spacerSm, spacerMd, spacerLg, spacerXl, spacer2xl, spacer3xl, spacer4xl


# Border Radius

@docs radiusSm, radiusMd, radiusLg, radiusPill


# Font Sizes

@docs fontSizeSm, fontSizeMd, fontSizeLg, fontSizeXl, fontSize2xl, fontSize3xl, fontSize4xl

-}

import Element exposing (Color, rgb255)


-- SEMANTIC COLORS


{-| Primary brand color — PF6 blue
-}
colorPrimary : Color
colorPrimary =
    rgb255 0 102 204


{-| Primary brand color hover state
-}
colorPrimaryHover : Color
colorPrimaryHover =
    rgb255 0 77 153


{-| Danger/error color — PF6 red-orange
-}
colorDanger : Color
colorDanger =
    rgb255 177 56 11


{-| Danger/error color hover state
-}
colorDangerHover : Color
colorDangerHover =
    rgb255 115 31 0


{-| Warning color — PF6 yellow/gold
-}
colorWarning : Color
colorWarning =
    rgb255 240 171 0


{-| Warning color hover state
-}
colorWarningHover : Color
colorWarningHover =
    rgb255 220 166 20


{-| Success color — PF6 green
-}
colorSuccess : Color
colorSuccess =
    rgb255 61 115 23


{-| Success color hover state
-}
colorSuccessHover : Color
colorSuccessHover =
    rgb255 32 77 0


{-| Info color — PF6 purple
-}
colorInfo : Color
colorInfo =
    rgb255 94 64 190


{-| Info color hover state
-}
colorInfoHover : Color
colorInfoHover =
    rgb255 61 39 133


{-| Neutral / secondary gray
-}
colorNeutral : Color
colorNeutral =
    rgb255 242 242 242


{-| Neutral color hover state
-}
colorNeutralHover : Color
colorNeutralHover =
    rgb255 224 224 224



-- TEXT COLORS


{-| Default text color
-}
colorText : Color
colorText =
    rgb255 21 21 21


{-| Subtle/secondary text color
-}
colorTextSubtle : Color
colorTextSubtle =
    rgb255 106 110 115


{-| Text color for use on dark backgrounds
-}
colorTextOnDark : Color
colorTextOnDark =
    rgb255 255 255 255



-- BACKGROUND COLORS


{-| Default background color (white)
-}
colorBackgroundDefault : Color
colorBackgroundDefault =
    rgb255 255 255 255


{-| Secondary background color (light gray)
-}
colorBackgroundSecondary : Color
colorBackgroundSecondary =
    rgb255 245 245 245


{-| Primary-colored background
-}
colorBackgroundPrimary : Color
colorBackgroundPrimary =
    rgb255 0 102 204


{-| Danger/error background color
-}
colorBackgroundDanger : Color
colorBackgroundDanger =
    rgb255 251 226 218


{-| Warning background color
-}
colorBackgroundWarning : Color
colorBackgroundWarning =
    rgb255 255 245 204


{-| Success background color
-}
colorBackgroundSuccess : Color
colorBackgroundSuccess =
    rgb255 219 237 208


{-| Info background color
-}
colorBackgroundInfo : Color
colorBackgroundInfo =
    rgb255 231 226 253



-- BORDER COLORS


{-| Default border color
-}
colorBorderDefault : Color
colorBorderDefault =
    rgb255 210 210 210


{-| Subtle border color
-}
colorBorderSubtle : Color
colorBorderSubtle =
    rgb255 240 240 240



-- SPACING (in pixels)


{-| Extra-small spacer (4px)
-}
spacerXs : Int
spacerXs =
    4


{-| Small spacer (8px)
-}
spacerSm : Int
spacerSm =
    8


{-| Medium spacer (16px)
-}
spacerMd : Int
spacerMd =
    16


{-| Large spacer (24px)
-}
spacerLg : Int
spacerLg =
    24


{-| Extra-large spacer (32px)
-}
spacerXl : Int
spacerXl =
    32


{-| 2x extra-large spacer (48px)
-}
spacer2xl : Int
spacer2xl =
    48


{-| 3x extra-large spacer (64px)
-}
spacer3xl : Int
spacer3xl =
    64


{-| 4x extra-large spacer (80px)
-}
spacer4xl : Int
spacer4xl =
    80



-- BORDER RADIUS (in pixels)


{-| Small border radius (2px)
-}
radiusSm : Int
radiusSm =
    2


{-| Medium border radius (4px)
-}
radiusMd : Int
radiusMd =
    4


{-| Large border radius (8px)
-}
radiusLg : Int
radiusLg =
    8


{-| Pill-shaped border radius (30px)
-}
radiusPill : Int
radiusPill =
    30



-- FONT SIZES (in points, for elm-ui)


{-| Small font size (12pt)
-}
fontSizeSm : Int
fontSizeSm =
    12


{-| Medium font size (14pt)
-}
fontSizeMd : Int
fontSizeMd =
    14


{-| Large font size (16pt)
-}
fontSizeLg : Int
fontSizeLg =
    16


{-| Extra-large font size (20pt)
-}
fontSizeXl : Int
fontSizeXl =
    20


{-| 2x extra-large font size (24pt)
-}
fontSize2xl : Int
fontSize2xl =
    24


{-| 3x extra-large font size (28pt)
-}
fontSize3xl : Int
fontSize3xl =
    28


{-| 4x extra-large font size (36pt)
-}
fontSize4xl : Int
fontSize4xl =
    36
