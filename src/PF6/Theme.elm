module PF6.Theme exposing
    ( Theme, Mode(..)
    , light, dark, fromMode
    , text, textSubtle, textOnDark
    , backgroundDefault, backgroundSecondary
    , backgroundPrimary, backgroundDanger, backgroundWarning, backgroundSuccess, backgroundInfo
    , borderDefault, borderSubtle
    , primary, primaryHover
    , danger, dangerHover
    , warning, warningHover
    , success, successHover
    , info, infoHover
    , neutral, neutralHover
    )

{-| A theme system for PF6 components supporting light and dark modes.

The `Theme` type wraps all color tokens needed by the design system.
Use `light` or `dark` to get a pre-built theme, or `fromMode` to
derive one from a `Mode` value stored in your model.


# Theme

@docs Theme, Mode
@docs light, dark, fromMode


# Text Colors

@docs text, textSubtle, textOnDark


# Background Colors

@docs backgroundDefault, backgroundSecondary
@docs backgroundPrimary, backgroundDanger, backgroundWarning, backgroundSuccess, backgroundInfo


# Border Colors

@docs borderDefault, borderSubtle


# Semantic Colors

@docs primary, primaryHover
@docs danger, dangerHover
@docs warning, warningHover
@docs success, successHover
@docs info, infoHover
@docs neutral, neutralHover

-}

import Element exposing (Color, rgb255)


{-| An opaque type holding all color tokens for a given theme.
-}
type Theme
    = Theme Colors


{-| The visual mode — `Light` or `Dark`.
-}
type Mode
    = Light
    | Dark


type alias Colors =
    { primary : Color
    , primaryHover : Color
    , danger : Color
    , dangerHover : Color
    , warning : Color
    , warningHover : Color
    , success : Color
    , successHover : Color
    , info : Color
    , infoHover : Color
    , neutral : Color
    , neutralHover : Color
    , text : Color
    , textSubtle : Color
    , textOnDark : Color
    , backgroundDefault : Color
    , backgroundSecondary : Color
    , backgroundPrimary : Color
    , backgroundDanger : Color
    , backgroundWarning : Color
    , backgroundSuccess : Color
    , backgroundInfo : Color
    , borderDefault : Color
    , borderSubtle : Color
    }



-- CONSTRUCTORS


{-| The PF6 light mode theme. Color values match `PF6.Tokens`.
-}
light : Theme
light =
    Theme
        { primary = rgb255 0 102 204
        , primaryHover = rgb255 0 77 153
        , danger = rgb255 177 56 11
        , dangerHover = rgb255 115 31 0
        , warning = rgb255 240 171 0
        , warningHover = rgb255 220 166 20
        , success = rgb255 61 115 23
        , successHover = rgb255 32 77 0
        , info = rgb255 94 64 190
        , infoHover = rgb255 61 39 133
        , neutral = rgb255 242 242 242
        , neutralHover = rgb255 224 224 224
        , text = rgb255 21 21 21
        , textSubtle = rgb255 106 110 115
        , textOnDark = rgb255 255 255 255
        , backgroundDefault = rgb255 255 255 255
        , backgroundSecondary = rgb255 245 245 245
        , backgroundPrimary = rgb255 0 102 204
        , backgroundDanger = rgb255 251 226 218
        , backgroundWarning = rgb255 255 245 204
        , backgroundSuccess = rgb255 219 237 208
        , backgroundInfo = rgb255 231 226 253
        , borderDefault = rgb255 210 210 210
        , borderSubtle = rgb255 240 240 240
        }


{-| The PF6 dark mode theme. Uses lighter foreground colors on dark
surfaces for proper contrast.
-}
dark : Theme
dark =
    Theme
        { primary = rgb255 115 180 255
        , primaryHover = rgb255 140 200 255
        , danger = rgb255 255 130 100
        , dangerHover = rgb255 255 160 130
        , warning = rgb255 255 204 51
        , warningHover = rgb255 255 215 80
        , success = rgb255 130 200 100
        , successHover = rgb255 160 220 130
        , info = rgb255 160 140 230
        , infoHover = rgb255 180 160 240
        , neutral = rgb255 50 50 50
        , neutralHover = rgb255 63 63 63
        , text = rgb255 240 240 240
        , textSubtle = rgb255 177 177 177
        , textOnDark = rgb255 240 240 240
        , backgroundDefault = rgb255 31 31 31
        , backgroundSecondary = rgb255 21 21 21
        , backgroundPrimary = rgb255 38 113 204
        , backgroundDanger = rgb255 60 20 15
        , backgroundWarning = rgb255 60 50 20
        , backgroundSuccess = rgb255 20 50 15
        , backgroundInfo = rgb255 35 25 60
        , borderDefault = rgb255 63 63 63
        , borderSubtle = rgb255 50 50 50
        }


{-| Convert a `Mode` to the corresponding `Theme`.

    fromMode Light == light

    fromMode Dark == dark

-}
fromMode : Mode -> Theme
fromMode mode =
    case mode of
        Light ->
            light

        Dark ->
            dark



-- ACCESSORS: Text Colors


{-| Default text color.
-}
text : Theme -> Color
text (Theme c) =
    c.text


{-| Subtle/secondary text color.
-}
textSubtle : Theme -> Color
textSubtle (Theme c) =
    c.textSubtle


{-| Text color for use on dark backgrounds.
-}
textOnDark : Theme -> Color
textOnDark (Theme c) =
    c.textOnDark



-- ACCESSORS: Background Colors


{-| Default background color.
-}
backgroundDefault : Theme -> Color
backgroundDefault (Theme c) =
    c.backgroundDefault


{-| Secondary background color.
-}
backgroundSecondary : Theme -> Color
backgroundSecondary (Theme c) =
    c.backgroundSecondary


{-| Primary-colored background.
-}
backgroundPrimary : Theme -> Color
backgroundPrimary (Theme c) =
    c.backgroundPrimary


{-| Danger/error background color.
-}
backgroundDanger : Theme -> Color
backgroundDanger (Theme c) =
    c.backgroundDanger


{-| Warning background color.
-}
backgroundWarning : Theme -> Color
backgroundWarning (Theme c) =
    c.backgroundWarning


{-| Success background color.
-}
backgroundSuccess : Theme -> Color
backgroundSuccess (Theme c) =
    c.backgroundSuccess


{-| Info background color.
-}
backgroundInfo : Theme -> Color
backgroundInfo (Theme c) =
    c.backgroundInfo



-- ACCESSORS: Border Colors


{-| Default border color.
-}
borderDefault : Theme -> Color
borderDefault (Theme c) =
    c.borderDefault


{-| Subtle border color.
-}
borderSubtle : Theme -> Color
borderSubtle (Theme c) =
    c.borderSubtle



-- ACCESSORS: Semantic Colors


{-| Primary brand color.
-}
primary : Theme -> Color
primary (Theme c) =
    c.primary


{-| Primary brand color hover state.
-}
primaryHover : Theme -> Color
primaryHover (Theme c) =
    c.primaryHover


{-| Danger/error color.
-}
danger : Theme -> Color
danger (Theme c) =
    c.danger


{-| Danger/error color hover state.
-}
dangerHover : Theme -> Color
dangerHover (Theme c) =
    c.dangerHover


{-| Warning color.
-}
warning : Theme -> Color
warning (Theme c) =
    c.warning


{-| Warning color hover state.
-}
warningHover : Theme -> Color
warningHover (Theme c) =
    c.warningHover


{-| Success color.
-}
success : Theme -> Color
success (Theme c) =
    c.success


{-| Success color hover state.
-}
successHover : Theme -> Color
successHover (Theme c) =
    c.successHover


{-| Info color.
-}
info : Theme -> Color
info (Theme c) =
    c.info


{-| Info color hover state.
-}
infoHover : Theme -> Color
infoHover (Theme c) =
    c.infoHover


{-| Neutral / secondary gray.
-}
neutral : Theme -> Color
neutral (Theme c) =
    c.neutral


{-| Neutral color hover state.
-}
neutralHover : Theme -> Color
neutralHover (Theme c) =
    c.neutralHover
