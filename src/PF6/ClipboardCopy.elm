module PF6.ClipboardCopy exposing
    ( ClipboardCopy
    , clipboardCopy
    , withExpanded, withInline, withBlock
    , withOnCopy
    , toMarkup
    )

{-| PF6 ClipboardCopy component

ClipboardCopy allows users to copy content to their clipboard with a button.

See: <https://www.patternfly.org/components/clipboard-copy>


# Definition

@docs ClipboardCopy


# Constructor

@docs clipboardCopy


# Variant modifiers

@docs withExpanded, withInline, withBlock


# Behavior modifiers

@docs withOnCopy


# Rendering

@docs toMarkup

-}

import Element exposing (Element)
import Element.Background as Bg
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import PF6.Tokens as Tokens




{-| Opaque ClipboardCopy type
-}
type ClipboardCopy msg
    = ClipboardCopy (Options msg)


type DisplayVariant
    = Default
    | Inline
    | Block


type alias Options msg =
    { content : String
    , variant : DisplayVariant
    , isExpanded : Bool
    , onToggleExpand : Maybe (Bool -> msg)
    , onCopy : Maybe msg
    }


{-| Construct a ClipboardCopy with content text
-}
clipboardCopy : String -> ClipboardCopy msg
clipboardCopy content =
    ClipboardCopy
        { content = content
        , variant = Default
        , isExpanded = False
        , onToggleExpand = Nothing
        , onCopy = Nothing
        }


{-| Expandable variant — shows truncated text with expand toggle
-}
withExpanded : Bool -> (Bool -> msg) -> ClipboardCopy msg -> ClipboardCopy msg
withExpanded isExpanded onToggle (ClipboardCopy opts) =
    ClipboardCopy { opts | isExpanded = isExpanded, onToggleExpand = Just onToggle }


{-| Inline variant — minimal display
-}
withInline : ClipboardCopy msg -> ClipboardCopy msg
withInline (ClipboardCopy opts) =
    ClipboardCopy { opts | variant = Inline }


{-| Block (code) variant
-}
withBlock : ClipboardCopy msg -> ClipboardCopy msg
withBlock (ClipboardCopy opts) =
    ClipboardCopy { opts | variant = Block }


{-| Set a message to send when the copy button is pressed
-}
withOnCopy : msg -> ClipboardCopy msg -> ClipboardCopy msg
withOnCopy msg (ClipboardCopy opts) =
    ClipboardCopy { opts | onCopy = Just msg }


copyBtn : Options msg -> Element msg
copyBtn opts =
    Input.button
        [ Element.paddingXY Tokens.spacerSm Tokens.spacerXs
        , Bg.color Tokens.colorBackgroundSecondary
        , Border.widthEach { top = 0, right = 0, bottom = 0, left = 1 }
        , Border.color Tokens.colorBorderDefault
        , Font.size Tokens.fontSizeSm
        , Font.color Tokens.colorText
        ]
        { onPress = opts.onCopy
        , label = Element.text "Copy"
        }


{-| Render the ClipboardCopy as an `Element msg`
-}
toMarkup : ClipboardCopy msg -> Element msg
toMarkup (ClipboardCopy opts) =
    case opts.variant of
        Inline ->
            Element.row
                [ Border.rounded Tokens.radiusMd
                , Border.solid
                , Border.width 1
                , Border.color Tokens.colorBorderDefault
                , Bg.color Tokens.colorBackgroundDefault
                ]
                [ Element.el
                    [ Font.family [ Font.monospace ]
                    , Font.size Tokens.fontSizeSm
                    , Element.paddingXY Tokens.spacerSm Tokens.spacerXs
                    ]
                    (Element.text opts.content)
                , copyBtn opts
                ]

        Block ->
            Element.row
                [ Element.width Element.fill
                , Border.rounded Tokens.radiusMd
                , Border.solid
                , Border.width 1
                , Border.color Tokens.colorBorderDefault
                , Bg.color (Element.rgb255 250 250 250)
                ]
                [ Element.el
                    [ Element.width Element.fill
                    , Font.family [ Font.monospace ]
                    , Font.size Tokens.fontSizeSm
                    , Element.padding Tokens.spacerMd
                    , Element.scrollbarX
                    ]
                    (Element.text opts.content)
                , copyBtn opts
                ]

        Default ->
            let
                displayText =
                    if opts.isExpanded || opts.onToggleExpand == Nothing then
                        opts.content

                    else
                        opts.content
                            |> String.left 80
                            |> (\s ->
                                    if String.length opts.content > 80 then
                                        s ++ "..."

                                    else
                                        s
                               )

                expandBtn =
                    case opts.onToggleExpand of
                        Just onToggle ->
                            Input.button
                                [ Element.paddingXY Tokens.spacerXs Tokens.spacerXs
                                , Bg.color Tokens.colorBackgroundDefault
                                , Border.widthEach { top = 0, right = 1, bottom = 0, left = 0 }
                                , Border.color Tokens.colorBorderDefault
                                , Font.size Tokens.fontSizeSm
                                ]
                                { onPress = Just (onToggle (not opts.isExpanded))
                                , label =
                                    Element.text
                                        (if opts.isExpanded then
                                            "▲"

                                         else
                                            "▼"
                                        )
                                }

                        Nothing ->
                            Element.none
            in
            Element.row
                [ Element.width Element.fill
                , Border.rounded Tokens.radiusMd
                , Border.solid
                , Border.width 1
                , Border.color Tokens.colorBorderDefault
                ]
                [ expandBtn
                , Element.el
                    [ Element.width Element.fill
                    , Element.padding Tokens.spacerSm
                    , Font.size Tokens.fontSizeMd
                    , Font.color Tokens.colorText
                    , Bg.color Tokens.colorBackgroundDefault
                    ]
                    (Element.text displayText)
                , copyBtn opts
                ]
