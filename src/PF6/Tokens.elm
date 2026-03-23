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

-}

import Element exposing (Color, rgb255)


-- SEMANTIC COLORS


{-| Primary brand color — PF6 blue
-}
colorPrimary : Color
colorPrimary =
    rgb255 0 102 204


colorPrimaryHover : Color
colorPrimaryHover =
    rgb255 0 77 153


{-| Danger/error color — PF6 red-orange
-}
colorDanger : Color
colorDanger =
    rgb255 177 56 11


colorDangerHover : Color
colorDangerHover =
    rgb255 115 31 0


{-| Warning color — PF6 yellow/gold
-}
colorWarning : Color
colorWarning =
    rgb255 240 171 0


colorWarningHover : Color
colorWarningHover =
    rgb255 220 166 20


{-| Success color — PF6 green
-}
colorSuccess : Color
colorSuccess =
    rgb255 61 115 23


colorSuccessHover : Color
colorSuccessHover =
    rgb255 32 77 0


{-| Info color — PF6 purple
-}
colorInfo : Color
colorInfo =
    rgb255 94 64 190


colorInfoHover : Color
colorInfoHover =
    rgb255 61 39 133


{-| Neutral / secondary gray
-}
colorNeutral : Color
colorNeutral =
    rgb255 242 242 242


colorNeutralHover : Color
colorNeutralHover =
    rgb255 224 224 224



-- TEXT COLORS


colorText : Color
colorText =
    rgb255 21 21 21


colorTextSubtle : Color
colorTextSubtle =
    rgb255 106 110 115


colorTextOnDark : Color
colorTextOnDark =
    rgb255 255 255 255



-- BACKGROUND COLORS


colorBackgroundDefault : Color
colorBackgroundDefault =
    rgb255 255 255 255


colorBackgroundSecondary : Color
colorBackgroundSecondary =
    rgb255 245 245 245


colorBackgroundPrimary : Color
colorBackgroundPrimary =
    rgb255 0 102 204


colorBackgroundDanger : Color
colorBackgroundDanger =
    rgb255 251 226 218


colorBackgroundWarning : Color
colorBackgroundWarning =
    rgb255 255 245 204


colorBackgroundSuccess : Color
colorBackgroundSuccess =
    rgb255 219 237 208


colorBackgroundInfo : Color
colorBackgroundInfo =
    rgb255 231 226 253



-- BORDER COLORS


colorBorderDefault : Color
colorBorderDefault =
    rgb255 210 210 210


colorBorderSubtle : Color
colorBorderSubtle =
    rgb255 240 240 240



-- SPACING (in pixels)


spacerXs : Int
spacerXs =
    4


spacerSm : Int
spacerSm =
    8


spacerMd : Int
spacerMd =
    16


spacerLg : Int
spacerLg =
    24


spacerXl : Int
spacerXl =
    32


spacer2xl : Int
spacer2xl =
    48


spacer3xl : Int
spacer3xl =
    64


spacer4xl : Int
spacer4xl =
    80



-- BORDER RADIUS (in pixels)


radiusSm : Int
radiusSm =
    2


radiusMd : Int
radiusMd =
    4


radiusLg : Int
radiusLg =
    8


radiusPill : Int
radiusPill =
    30



-- FONT SIZES (in points, for elm-ui)


fontSizeSm : Int
fontSizeSm =
    12


fontSizeMd : Int
fontSizeMd =
    14


fontSizeLg : Int
fontSizeLg =
    16


fontSizeXl : Int
fontSizeXl =
    20


fontSize2xl : Int
fontSize2xl =
    24


fontSize3xl : Int
fontSize3xl =
    28


fontSize4xl : Int
fontSize4xl =
    36
