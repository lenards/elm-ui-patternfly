module PF6.Banner exposing
    ( Banner, Variant
    , banner
    , withDefault, withInfo, withSuccess, withWarning, withDanger
    , withIcon, withLink
    , toMarkup
    )

{-| PF6 Banner component

Banners display important, site-wide information above the page navigation.

See: <https://www.patternfly.org/components/banner>


# Definition

@docs Banner, Variant


# Constructor

@docs banner


# Variant modifiers

@docs withDefault, withInfo, withSuccess, withWarning, withDanger


# Content modifiers

@docs withIcon, withLink


# Rendering

@docs toMarkup

-}

import Element exposing (Element)
import Element.Background as Bg
import Element.Font as Font
import PF6.Tokens as Tokens


{-| Opaque Banner type
-}
type Banner msg
    = Banner (Options msg)


{-| Banner severity variant
-}
type Variant
    = Default
    | Info
    | Success
    | Warning
    | Danger


type alias Options msg =
    { text : String
    , variant : Variant
    , icon : Maybe (Element msg)
    , link : Maybe { label : String, href : String }
    }


type alias BannerColors =
    { bg : Element.Color
    , fg : Element.Color
    }


colorsFor : Variant -> BannerColors
colorsFor variant =
    case variant of
        Default ->
            { bg = Element.rgb255 240 240 240
            , fg = Tokens.colorText
            }

        Info ->
            { bg = Tokens.colorInfo
            , fg = Tokens.colorTextOnDark
            }

        Success ->
            { bg = Tokens.colorSuccess
            , fg = Tokens.colorTextOnDark
            }

        Warning ->
            { bg = Tokens.colorWarning
            , fg = Tokens.colorText
            }

        Danger ->
            { bg = Tokens.colorDanger
            , fg = Tokens.colorTextOnDark
            }


{-| Construct a Banner with body text
-}
banner : String -> Banner msg
banner text =
    Banner
        { text = text
        , variant = Default
        , icon = Nothing
        , link = Nothing
        }


{-| Default (gray) variant
-}
withDefault : Banner msg -> Banner msg
withDefault (Banner opts) =
    Banner { opts | variant = Default }


{-| Info (purple) variant
-}
withInfo : Banner msg -> Banner msg
withInfo (Banner opts) =
    Banner { opts | variant = Info }


{-| Success (green) variant
-}
withSuccess : Banner msg -> Banner msg
withSuccess (Banner opts) =
    Banner { opts | variant = Success }


{-| Warning (gold) variant
-}
withWarning : Banner msg -> Banner msg
withWarning (Banner opts) =
    Banner { opts | variant = Warning }


{-| Danger (red) variant
-}
withDanger : Banner msg -> Banner msg
withDanger (Banner opts) =
    Banner { opts | variant = Danger }


{-| Add a leading icon
-}
withIcon : Element msg -> Banner msg -> Banner msg
withIcon el (Banner opts) =
    Banner { opts | icon = Just el }


{-| Add a trailing link
-}
withLink : { label : String, href : String } -> Banner msg -> Banner msg
withLink l (Banner opts) =
    Banner { opts | link = Just l }


{-| Render the Banner as an `Element msg`
-}
toMarkup : Banner msg -> Element msg
toMarkup (Banner opts) =
    let
        colors =
            colorsFor opts.variant

        iconEl =
            opts.icon
                |> Maybe.map
                    (\el ->
                        Element.el
                            [ Element.paddingEach { top = 0, right = Tokens.spacerXs, bottom = 0, left = 0 } ]
                            el
                    )
                |> Maybe.withDefault Element.none

        linkEl =
            opts.link
                |> Maybe.map
                    (\l ->
                        Element.el
                            [ Font.underline
                            , Font.color colors.fg
                            , Element.paddingEach { top = 0, right = 0, bottom = 0, left = Tokens.spacerSm }
                            ]
                            (Element.text l.label)
                    )
                |> Maybe.withDefault Element.none
    in
    Element.row
        [ Element.width Element.fill
        , Bg.color colors.bg
        , Font.color colors.fg
        , Font.size Tokens.fontSizeSm
        , Element.paddingXY Tokens.spacerMd Tokens.spacerSm
        , Element.spacing 0
        ]
        [ iconEl
        , Element.el [ Element.width Element.fill, Element.centerX ] (Element.text opts.text)
        , linkEl
        ]
