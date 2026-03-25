module PF6.Alert exposing
    ( Alert, Variant
    , alert
    , withSuccess, withDanger, withWarning, withInfo, withCustom
    , withTitle, withInline, withPlain
    , withCloseMsg, withActions
    , toMarkup
    )

{-| PF6 Alert component

Alerts communicate status and provide brief, contextual information to users.

See: <https://www.patternfly.org/components/alert>


# Definition

@docs Alert, Variant


# Constructor

@docs alert


# Variant modifiers

@docs withSuccess, withDanger, withWarning, withInfo, withCustom


# Display modifiers

@docs withTitle, withInline, withPlain


# Action modifiers

@docs withCloseMsg, withActions


# Rendering

@docs toMarkup

-}

import Element exposing (Element)
import Element.Background as Bg
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import PF6.Theme as Theme exposing (Theme)
import PF6.Tokens as Tokens


{-| Opaque Alert type
-}
type Alert msg
    = Alert (Options msg)


{-| Alert severity variants
-}
type Variant
    = Default
    | Success
    | Danger
    | Warning
    | Info
    | Custom


type alias ColorSet =
    { bg : Element.Color
    , border : Element.Color
    , icon : Element.Color
    , iconLabel : String
    }


colorSetFor : Theme -> Variant -> ColorSet
colorSetFor theme variant =
    case variant of
        Default ->
            { bg = Theme.backgroundSecondary theme
            , border = Theme.borderDefault theme
            , icon = Theme.text theme
            , iconLabel = "ℹ"
            }

        Success ->
            { bg = Theme.backgroundSuccess theme
            , border = Theme.success theme
            , icon = Theme.success theme
            , iconLabel = "✓"
            }

        Danger ->
            { bg = Theme.backgroundDanger theme
            , border = Theme.danger theme
            , icon = Theme.danger theme
            , iconLabel = "✕"
            }

        Warning ->
            { bg = Theme.backgroundWarning theme
            , border = Theme.warning theme
            , icon = Element.rgb255 112 84 0
            , iconLabel = "⚠"
            }

        Info ->
            { bg = Theme.backgroundInfo theme
            , border = Theme.info theme
            , icon = Theme.info theme
            , iconLabel = "ℹ"
            }

        Custom ->
            { bg = Element.rgb255 215 250 250
            , border = Element.rgb255 20 120 120
            , icon = Element.rgb255 20 120 120
            , iconLabel = "★"
            }


type alias Options msg =
    { title : String
    , body : Maybe String
    , variant : Variant
    , isInline : Bool
    , isPlain : Bool
    , onClose : Maybe msg
    , actions : Maybe (Element msg)
    }


{-| Construct a default Alert with the given body text
-}
alert : String -> Alert msg
alert bodyText =
    Alert
        { title = ""
        , body = Just bodyText
        , variant = Default
        , isInline = False
        , isPlain = False
        , onClose = Nothing
        , actions = Nothing
        }


{-| Set the alert title
-}
withTitle : String -> Alert msg -> Alert msg
withTitle t (Alert opts) =
    Alert { opts | title = t }


{-| Success variant (green)
-}
withSuccess : Alert msg -> Alert msg
withSuccess (Alert opts) =
    Alert { opts | variant = Success }


{-| Danger variant (red)
-}
withDanger : Alert msg -> Alert msg
withDanger (Alert opts) =
    Alert { opts | variant = Danger }


{-| Warning variant (yellow)
-}
withWarning : Alert msg -> Alert msg
withWarning (Alert opts) =
    Alert { opts | variant = Warning }


{-| Info variant (purple)
-}
withInfo : Alert msg -> Alert msg
withInfo (Alert opts) =
    Alert { opts | variant = Info }


{-| Custom variant (teal)
-}
withCustom : Alert msg -> Alert msg
withCustom (Alert opts) =
    Alert { opts | variant = Custom }


{-| Inline display — no outer box shadow, fits within content
-}
withInline : Alert msg -> Alert msg
withInline (Alert opts) =
    Alert { opts | isInline = True }


{-| Plain display — no background color
-}
withPlain : Alert msg -> Alert msg
withPlain (Alert opts) =
    Alert { opts | isPlain = True }


{-| Add a close button that sends msg on click
-}
withCloseMsg : msg -> Alert msg -> Alert msg
withCloseMsg msg (Alert opts) =
    Alert { opts | onClose = Just msg }


{-| Add action buttons below the alert body
-}
withActions : Element msg -> Alert msg -> Alert msg
withActions el (Alert opts) =
    Alert { opts | actions = Just el }


{-| Render the Alert as an `Element msg`
-}
toMarkup : Theme -> Alert msg -> Element msg
toMarkup theme (Alert opts) =
    let
        colors =
            colorSetFor theme opts.variant

        bg =
            if opts.isPlain then
                Theme.backgroundDefault theme

            else
                colors.bg

        iconEl =
            Element.el
                [ Font.color colors.icon
                , Font.bold
                , Font.size Tokens.fontSizeLg
                , Element.alignTop
                ]
                (Element.text colors.iconLabel)

        titleEl =
            if String.isEmpty opts.title then
                Element.none

            else
                Element.el
                    [ Font.bold
                    , Font.size Tokens.fontSizeMd
                    , Font.color (Theme.text theme)
                    ]
                    (Element.text opts.title)

        bodyEl =
            opts.body
                |> Maybe.map
                    (\b ->
                        Element.paragraph
                            [ Font.size Tokens.fontSizeMd
                            , Font.color (Theme.text theme)
                            ]
                            [ Element.text b ]
                    )
                |> Maybe.withDefault Element.none

        closeEl =
            opts.onClose
                |> Maybe.map
                    (\msg ->
                        Input.button
                            [ Font.color (Theme.textSubtle theme)
                            , Element.alignTop
                            , Element.alignRight
                            ]
                            { onPress = Just msg
                            , label = Element.text "×"
                            }
                    )
                |> Maybe.withDefault Element.none

        actionsEl =
            opts.actions
                |> Maybe.map (\el -> Element.el [ Element.paddingEach { top = Tokens.spacerSm, right = 0, bottom = 0, left = 0 } ] el)
                |> Maybe.withDefault Element.none

        contentCol =
            Element.column
                [ Element.width Element.fill
                , Element.spacing Tokens.spacerXs
                ]
                [ titleEl, bodyEl, actionsEl ]
    in
    Element.el
        [ Element.width Element.fill
        , Bg.color bg
        , Border.rounded Tokens.radiusMd
        , Border.solid
        , Border.width 1
        , Border.color colors.border
        , Border.widthEach { top = 0, right = 0, bottom = 0, left = 4 }
        ]
        (Element.row
            [ Element.width Element.fill
            , Element.padding Tokens.spacerMd
            , Element.spacing Tokens.spacerSm
            ]
            [ iconEl
            , contentCol
            , closeEl
            ]
        )
