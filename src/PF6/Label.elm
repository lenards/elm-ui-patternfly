module PF6.Label exposing
    ( Label, Variant, Color
    , label
    , withFill, withOutline, withCompact
    , withBlueColor, withGreenColor, withOrangeColor, withRedColor, withPurpleColor, withCyanColor, withGoldColor
    , withIcon, withHyperlink, withCloseMsg
    , toMarkup
    )

{-| PF6 Label component

Labels are used to highlight an item's status for quick recognition,
or to flag content that needs action.

See: <https://www.patternfly.org/components/label>


# Definition

@docs Label, Variant, Color


# Constructor

@docs label


# Variant modifiers

@docs withFill, withOutline, withCompact


# Color modifiers

@docs withBlueColor, withGreenColor, withOrangeColor, withRedColor, withPurpleColor, withCyanColor, withGoldColor


# Content modifiers

@docs withIcon, withHyperlink, withCloseMsg


# Rendering

@docs toMarkup

-}

import Element exposing (Element)
import Element.Background as Bg
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import PF6.Tokens as Tokens


{-| Opaque Label type
-}
type Label msg
    = Label (Options msg)


{-| Fill or outline variant
-}
type Variant
    = Fill
    | Outline
    | Compact


{-| Label color theme
-}
type Color
    = Grey
    | Blue
    | Green
    | Orange
    | Red
    | Purple
    | Cyan
    | Gold


type alias ColorPair =
    { bg : Element.Color
    , fg : Element.Color
    , border : Element.Color
    }


colorPairFor : Color -> ColorPair
colorPairFor color =
    case color of
        Grey ->
            { bg = Tokens.colorNeutral
            , fg = Tokens.colorText
            , border = Tokens.colorBorderDefault
            }

        Blue ->
            { bg = Element.rgb255 215 235 255
            , fg = Element.rgb255 0 66 133
            , border = Element.rgb255 115 188 247
            }

        Green ->
            { bg = Element.rgb255 219 237 208
            , fg = Element.rgb255 40 93 5
            , border = Element.rgb255 149 196 112
            }

        Orange ->
            { bg = Element.rgb255 255 226 195
            , fg = Element.rgb255 124 65 5
            , border = Element.rgb255 240 171 0
            }

        Red ->
            { bg = Element.rgb255 251 226 218
            , fg = Element.rgb255 115 31 0
            , border = Element.rgb255 240 129 100
            }

        Purple ->
            { bg = Element.rgb255 231 226 253
            , fg = Element.rgb255 59 34 122
            , border = Element.rgb255 179 156 241
            }

        Cyan ->
            { bg = Element.rgb255 215 250 250
            , fg = Element.rgb255 3 102 102
            , border = Element.rgb255 115 221 221
            }

        Gold ->
            { bg = Element.rgb255 255 245 204
            , fg = Element.rgb255 112 84 0
            , border = Element.rgb255 240 199 0
            }


type alias Options msg =
    { text : String
    , variant : Variant
    , color : Color
    , icon : Maybe (Element msg)
    , href : Maybe String
    , onClose : Maybe msg
    }


defaultOptions : String -> Options msg
defaultOptions text =
    { text = text
    , variant = Fill
    , color = Grey
    , icon = Nothing
    , href = Nothing
    , onClose = Nothing
    }


{-| Construct a Label with the given text
-}
label : String -> Label msg
label text =
    Label (defaultOptions text)


{-| Filled background (default)
-}
withFill : Label msg -> Label msg
withFill (Label opts) =
    Label { opts | variant = Fill }


{-| Outlined border, transparent background
-}
withOutline : Label msg -> Label msg
withOutline (Label opts) =
    Label { opts | variant = Outline }


{-| Compact sizing — smaller padding
-}
withCompact : Label msg -> Label msg
withCompact (Label opts) =
    Label { opts | variant = Compact }


{-| Blue color theme
-}
withBlueColor : Label msg -> Label msg
withBlueColor (Label opts) =
    Label { opts | color = Blue }


{-| Green color theme
-}
withGreenColor : Label msg -> Label msg
withGreenColor (Label opts) =
    Label { opts | color = Green }


{-| Orange color theme
-}
withOrangeColor : Label msg -> Label msg
withOrangeColor (Label opts) =
    Label { opts | color = Orange }


{-| Red color theme
-}
withRedColor : Label msg -> Label msg
withRedColor (Label opts) =
    Label { opts | color = Red }


{-| Purple color theme
-}
withPurpleColor : Label msg -> Label msg
withPurpleColor (Label opts) =
    Label { opts | color = Purple }


{-| Cyan color theme
-}
withCyanColor : Label msg -> Label msg
withCyanColor (Label opts) =
    Label { opts | color = Cyan }


{-| Gold color theme
-}
withGoldColor : Label msg -> Label msg
withGoldColor (Label opts) =
    Label { opts | color = Gold }


{-| Add a leading icon
-}
withIcon : Element msg -> Label msg -> Label msg
withIcon icon (Label opts) =
    Label { opts | icon = Just icon }


{-| Make the label text a hyperlink
-}
withHyperlink : String -> Label msg -> Label msg
withHyperlink href (Label opts) =
    Label { opts | href = Just href }


{-| Add a close/dismiss button that sends msg on click
-}
withCloseMsg : msg -> Label msg -> Label msg
withCloseMsg msg (Label opts) =
    Label { opts | onClose = Just msg }


closeButton : msg -> Element.Color -> Element msg
closeButton msg fg =
    Input.button
        [ Font.color fg
        , Element.paddingEach { top = 0, right = 0, bottom = 0, left = Tokens.spacerXs }
        ]
        { onPress = Just msg
        , label = Element.text "×"
        }


{-| Render the Label as an `Element msg`
-}
toMarkup : Label msg -> Element msg
toMarkup (Label opts) =
    let
        colors =
            colorPairFor opts.color

        ( padding, fontSize ) =
            case opts.variant of
                Compact ->
                    ( Element.paddingXY Tokens.spacerXs 2, Tokens.fontSizeSm )

                _ ->
                    ( Element.paddingXY Tokens.spacerSm Tokens.spacerXs, Tokens.fontSizeMd )

        baseAttrs =
            [ Border.rounded Tokens.radiusPill
            , padding
            , Font.size fontSize
            , Font.color colors.fg
            ]

        variantAttrs =
            case opts.variant of
                Fill ->
                    [ Bg.color colors.bg ]

                Outline ->
                    [ Border.solid
                    , Border.width 1
                    , Border.color colors.border
                    ]

                Compact ->
                    [ Bg.color colors.bg ]

        children =
            [ opts.icon
                |> Maybe.map
                    (\icon ->
                        Element.el
                            [ Element.paddingEach { top = 0, right = Tokens.spacerXs, bottom = 0, left = 0 } ]
                            icon
                    )
                |> Maybe.withDefault Element.none
            , Element.text opts.text
            , opts.onClose
                |> Maybe.map (\msg -> closeButton msg colors.fg)
                |> Maybe.withDefault Element.none
            ]
    in
    Element.row (baseAttrs ++ variantAttrs) children
