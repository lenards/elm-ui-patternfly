module PF6.TextInputGroup exposing
    ( TextInputGroup
    , textInputGroup
    , withPrefix, withSuffix, withPlaceholder, withLabel, withDisabled
    , toMarkup
    )

{-| PF6 TextInputGroup component

An input with optional prefix and/or suffix elements sharing a common border.

See: <https://www.patternfly.org/components/text-input-group>


# Definition

@docs TextInputGroup


# Constructor

@docs textInputGroup


# Modifiers

@docs withPrefix, withSuffix, withPlaceholder, withLabel, withDisabled


# Rendering

@docs toMarkup

-}

import Element exposing (Element)
import Element.Background as Bg
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import PF6.Tokens as Tokens


{-| Opaque TextInputGroup type
-}
type TextInputGroup msg
    = TextInputGroup (Options msg)


type alias Options msg =
    { value : String
    , onChange : String -> msg
    , prefix : Maybe (Element msg)
    , suffix : Maybe (Element msg)
    , placeholder : Maybe String
    , label : Maybe String
    , isDisabled : Bool
    }


{-| Construct a TextInputGroup

    textInputGroup { value = model.search, onChange = SearchChanged }

-}
textInputGroup : { value : String, onChange : String -> msg } -> TextInputGroup msg
textInputGroup config =
    TextInputGroup
        { value = config.value
        , onChange = config.onChange
        , prefix = Nothing
        , suffix = Nothing
        , placeholder = Nothing
        , label = Nothing
        , isDisabled = False
        }


{-| Add a prefix element (e.g. an icon or label) before the input
-}
withPrefix : Element msg -> TextInputGroup msg -> TextInputGroup msg
withPrefix el (TextInputGroup opts) =
    TextInputGroup { opts | prefix = Just el }


{-| Add a suffix element (e.g. a button or icon) after the input
-}
withSuffix : Element msg -> TextInputGroup msg -> TextInputGroup msg
withSuffix el (TextInputGroup opts) =
    TextInputGroup { opts | suffix = Just el }


{-| Set placeholder text
-}
withPlaceholder : String -> TextInputGroup msg -> TextInputGroup msg
withPlaceholder p (TextInputGroup opts) =
    TextInputGroup { opts | placeholder = Just p }


{-| Set a visible label above the input group
-}
withLabel : String -> TextInputGroup msg -> TextInputGroup msg
withLabel l (TextInputGroup opts) =
    TextInputGroup { opts | label = Just l }


{-| Disable the input
-}
withDisabled : TextInputGroup msg -> TextInputGroup msg
withDisabled (TextInputGroup opts) =
    TextInputGroup { opts | isDisabled = True }


{-| Render the TextInputGroup as an `Element msg`
-}
toMarkup : TextInputGroup msg -> Element msg
toMarkup (TextInputGroup opts) =
    let
        labelEl =
            opts.label
                |> Maybe.map
                    (\l ->
                        Element.el
                            [ Font.size Tokens.fontSizeMd
                            , Font.color Tokens.colorText
                            , Element.paddingEach { top = 0, right = 0, bottom = Tokens.spacerXs, left = 0 }
                            ]
                            (Element.text l)
                    )
                |> Maybe.withDefault Element.none

        bgColor =
            if opts.isDisabled then
                Tokens.colorBackgroundSecondary

            else
                Tokens.colorBackgroundDefault

        prefixEl =
            opts.prefix
                |> Maybe.map
                    (\el ->
                        Element.el
                            [ Element.paddingXY Tokens.spacerSm 0
                            , Element.centerY
                            , Font.color Tokens.colorTextSubtle
                            , Bg.color bgColor
                            ]
                            el
                    )
                |> Maybe.withDefault Element.none

        suffixEl =
            opts.suffix
                |> Maybe.map
                    (\el ->
                        Element.el
                            [ Element.paddingXY Tokens.spacerSm 0
                            , Element.centerY
                            , Font.color Tokens.colorTextSubtle
                            , Bg.color bgColor
                            ]
                            el
                    )
                |> Maybe.withDefault Element.none

        placeholderEl =
            opts.placeholder
                |> Maybe.map
                    (\p ->
                        Input.placeholder
                            [ Font.color Tokens.colorTextSubtle ]
                            (Element.text p)
                    )

        inputEl =
            Input.text
                [ Element.width Element.fill
                , Border.width 0
                , Element.padding Tokens.spacerSm
                , Font.size Tokens.fontSizeMd
                , Bg.color bgColor
                ]
                { onChange = opts.onChange
                , text = opts.value
                , placeholder = placeholderEl
                , label = Input.labelHidden (opts.label |> Maybe.withDefault "input")
                }

        groupRow =
            Element.row
                [ Element.width Element.fill
                , Border.rounded Tokens.radiusMd
                , Border.solid
                , Border.width 1
                , Border.color Tokens.colorBorderDefault
                , Bg.color bgColor
                , Element.clip
                ]
                [ prefixEl
                , inputEl
                , suffixEl
                ]
    in
    Element.column
        [ Element.width Element.fill
        , Element.spacing 0
        ]
        [ labelEl
        , groupRow
        ]
