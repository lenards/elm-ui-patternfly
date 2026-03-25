module PF6.Toast exposing
    ( Toast, Variant
    , toast
    , withSuccess, withDanger, withWarning, withInfo
    , withTitle
    , withCloseMsg
    , toMarkup
    )

{-| PF6 Toast component

Toasts display brief, auto-dismissing alerts. Use `Element.inFront` on a parent
container to position a stack of toasts. Dismissal timing is handled by the consumer
via subscriptions (e.g. `Process.sleep` + a `DismissToast id` message).

See: <https://www.patternfly.org/components/toast>


# Definition

@docs Toast, Variant


# Constructor

@docs toast


# Variant modifiers

@docs withSuccess, withDanger, withWarning, withInfo


# Content modifiers

@docs withTitle


# Action modifiers

@docs withCloseMsg


# Rendering

@docs toMarkup

-}

import Element exposing (Element)
import Element.Background as Bg
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import Html.Attributes
import PF6.Theme as Theme exposing (Theme)
import PF6.Tokens as Tokens


{-| Opaque Toast type
-}
type Toast msg
    = Toast (Options msg)


{-| Toast severity variants
-}
type Variant
    = Default
    | Success
    | Danger
    | Warning
    | Info


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
            , icon = Theme.warning theme
            , iconLabel = "⚠"
            }

        Info ->
            { bg = Theme.backgroundInfo theme
            , border = Theme.info theme
            , icon = Theme.info theme
            , iconLabel = "ℹ"
            }


type alias Options msg =
    { title : String
    , body : String
    , variant : Variant
    , onClose : Maybe msg
    }


{-| Construct a Toast with the given body text
-}
toast : String -> Toast msg
toast body =
    Toast
        { title = ""
        , body = body
        , variant = Default
        , onClose = Nothing
        }


{-| Set the toast title
-}
withTitle : String -> Toast msg -> Toast msg
withTitle t (Toast opts) =
    Toast { opts | title = t }


{-| Success variant (green)
-}
withSuccess : Toast msg -> Toast msg
withSuccess (Toast opts) =
    Toast { opts | variant = Success }


{-| Danger variant (red)
-}
withDanger : Toast msg -> Toast msg
withDanger (Toast opts) =
    Toast { opts | variant = Danger }


{-| Warning variant (yellow)
-}
withWarning : Toast msg -> Toast msg
withWarning (Toast opts) =
    Toast { opts | variant = Warning }


{-| Info variant (purple)
-}
withInfo : Toast msg -> Toast msg
withInfo (Toast opts) =
    Toast { opts | variant = Info }


{-| Add a close button that sends msg on click
-}
withCloseMsg : msg -> Toast msg -> Toast msg
withCloseMsg msg (Toast opts) =
    Toast { opts | onClose = Just msg }


{-| Render the Toast as an `Element msg`.

Position using `Element.inFront` on a parent layout. Stack multiple toasts in a
`column` with spacing:

    Element.layout
        [ Element.inFront
            (Element.column
                [ Element.alignRight
                , Element.alignTop
                , Element.padding 16
                , Element.spacing 8
                ]
                (List.map (Toast.toMarkup theme) model.toasts)
            )
        ]
        mainContent

-}
toMarkup : Theme -> Toast msg -> Element msg
toMarkup theme (Toast opts) =
    let
        colors =
            colorSetFor theme opts.variant

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
            Element.paragraph
                [ Font.size Tokens.fontSizeMd
                , Font.color (Theme.text theme)
                ]
                [ Element.text opts.body ]

        closeEl =
            opts.onClose
                |> Maybe.map
                    (\msg ->
                        Input.button
                            [ Font.color (Theme.textSubtle theme)
                            , Font.size Tokens.fontSizeXl
                            , Element.alignTop
                            , Element.alignRight
                            ]
                            { onPress = Just msg
                            , label = Element.text "×"
                            }
                    )
                |> Maybe.withDefault Element.none

        contentCol =
            Element.column
                [ Element.width Element.fill
                , Element.spacing Tokens.spacerXs
                ]
                [ titleEl, bodyEl ]
    in
    Element.el
        [ Element.width (Element.px 320)
        , Bg.color colors.bg
        , Border.rounded Tokens.radiusMd
        , Border.solid
        , Border.width 1
        , Border.color colors.border
        , Border.widthEach { top = 0, right = 0, bottom = 0, left = 4 }
        , Element.htmlAttribute (Html.Attributes.style "box-shadow" "0 4px 16px rgba(0,0,0,0.2)")
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
