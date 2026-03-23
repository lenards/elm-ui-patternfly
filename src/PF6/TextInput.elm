module PF6.TextInput exposing
    ( TextInput, Type
    , textInput
    , withPlaceholder, withHelperText, withLabel
    , withPasswordType, withEmailType, withSearchType, withNumberType, withTelType
    , withSuccess, withDanger, withWarning
    , withDisabled, withReadOnly
    , withIcon
    , toMarkup
    )

{-| PF6 TextInput component

Text inputs are used to gather free-form text input from the user.

See: <https://www.patternfly.org/components/text-input>


# Definition

@docs TextInput, Type


# Constructor

@docs textInput


# Content modifiers

@docs withPlaceholder, withHelperText, withLabel


# Input type modifiers

@docs withPasswordType, withEmailType, withSearchType, withNumberType, withTelType


# Validation modifiers

@docs withSuccess, withDanger, withWarning


# State modifiers

@docs withDisabled, withReadOnly


# Icon

@docs withIcon


# Rendering

@docs toMarkup

-}

import Element exposing (Element)
import Element.Background as Bg
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import PF6.Tokens as Tokens


{-| Opaque TextInput type
-}
type TextInput msg
    = TextInput (Options msg)


{-| Input type
-}
type Type
    = Text
    | Password
    | Email
    | Search
    | Number
    | Tel


type ValidationStatus
    = None
    | Success
    | Danger
    | Warning


type alias Options msg =
    { value : String
    , onChange : String -> msg
    , label : Maybe String
    , placeholder : Maybe String
    , helperText : Maybe String
    , inputType : Type
    , validation : ValidationStatus
    , isDisabled : Bool
    , isReadOnly : Bool
    , icon : Maybe (Element msg)
    }


{-| Construct a TextInput

    textInput { value = model.name, onChange = NameChanged }

-}
textInput : { value : String, onChange : String -> msg } -> TextInput msg
textInput { value, onChange } =
    TextInput
        { value = value
        , onChange = onChange
        , label = Nothing
        , placeholder = Nothing
        , helperText = Nothing
        , inputType = Text
        , validation = None
        , isDisabled = False
        , isReadOnly = False
        , icon = Nothing
        }


{-| Set the visible label
-}
withLabel : String -> TextInput msg -> TextInput msg
withLabel l (TextInput opts) =
    TextInput { opts | label = Just l }


{-| Set placeholder text
-}
withPlaceholder : String -> TextInput msg -> TextInput msg
withPlaceholder p (TextInput opts) =
    TextInput { opts | placeholder = Just p }


{-| Set helper text below the input
-}
withHelperText : String -> TextInput msg -> TextInput msg
withHelperText t (TextInput opts) =
    TextInput { opts | helperText = Just t }


{-| Password input type (masked)
-}
withPasswordType : TextInput msg -> TextInput msg
withPasswordType (TextInput opts) =
    TextInput { opts | inputType = Password }


{-| Email input type
-}
withEmailType : TextInput msg -> TextInput msg
withEmailType (TextInput opts) =
    TextInput { opts | inputType = Email }


{-| Search input type
-}
withSearchType : TextInput msg -> TextInput msg
withSearchType (TextInput opts) =
    TextInput { opts | inputType = Search }


{-| Number input type
-}
withNumberType : TextInput msg -> TextInput msg
withNumberType (TextInput opts) =
    TextInput { opts | inputType = Number }


{-| Tel input type
-}
withTelType : TextInput msg -> TextInput msg
withTelType (TextInput opts) =
    TextInput { opts | inputType = Tel }


{-| Success validation state (green border)
-}
withSuccess : TextInput msg -> TextInput msg
withSuccess (TextInput opts) =
    TextInput { opts | validation = Success }


{-| Danger/error validation state (red border)
-}
withDanger : TextInput msg -> TextInput msg
withDanger (TextInput opts) =
    TextInput { opts | validation = Danger }


{-| Warning validation state (yellow border)
-}
withWarning : TextInput msg -> TextInput msg
withWarning (TextInput opts) =
    TextInput { opts | validation = Warning }


{-| Disable the input
-}
withDisabled : TextInput msg -> TextInput msg
withDisabled (TextInput opts) =
    TextInput { opts | isDisabled = True }


{-| Make the input read-only
-}
withReadOnly : TextInput msg -> TextInput msg
withReadOnly (TextInput opts) =
    TextInput { opts | isReadOnly = True }


{-| Add an icon inside the input (leading)
-}
withIcon : Element msg -> TextInput msg -> TextInput msg
withIcon icon (TextInput opts) =
    TextInput { opts | icon = Just icon }


validationBorderColor : ValidationStatus -> Element.Color
validationBorderColor status =
    case status of
        None ->
            Tokens.colorBorderDefault

        Success ->
            Tokens.colorSuccess

        Danger ->
            Tokens.colorDanger

        Warning ->
            Tokens.colorWarning


validationHelperColor : ValidationStatus -> Element.Color
validationHelperColor status =
    case status of
        Danger ->
            Tokens.colorDanger

        Warning ->
            Tokens.colorWarning

        _ ->
            Tokens.colorTextSubtle


{-| Render the TextInput as an `Element msg`
-}
toMarkup : TextInput msg -> Element msg
toMarkup (TextInput opts) =
    let
        borderColor =
            validationBorderColor opts.validation

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

        placeholderEl =
            opts.placeholder
                |> Maybe.map
                    (\p ->
                        Input.placeholder
                            [ Font.color Tokens.colorTextSubtle ]
                            (Element.text p)
                    )

        inputEl =
            case opts.inputType of
                Password ->
                    Input.newPassword
                        [ Element.width Element.fill
                        , Border.rounded Tokens.radiusMd
                        , Border.solid
                        , Border.width 1
                        , Border.color borderColor
                        , Element.padding Tokens.spacerSm
                        , Font.size Tokens.fontSizeMd
                        , Bg.color
                            (if opts.isDisabled then
                                Tokens.colorBackgroundSecondary

                             else
                                Tokens.colorBackgroundDefault
                            )
                        ]
                        { onChange = opts.onChange
                        , text = opts.value
                        , placeholder = placeholderEl
                        , label = Input.labelHidden (opts.label |> Maybe.withDefault "password")
                        , show = False
                        }

                _ ->
                    Input.text
                        [ Element.width Element.fill
                        , Border.rounded Tokens.radiusMd
                        , Border.solid
                        , Border.width 1
                        , Border.color borderColor
                        , Element.padding Tokens.spacerSm
                        , Font.size Tokens.fontSizeMd
                        , Bg.color
                            (if opts.isDisabled then
                                Tokens.colorBackgroundSecondary

                             else
                                Tokens.colorBackgroundDefault
                            )
                        ]
                        { onChange = opts.onChange
                        , text = opts.value
                        , placeholder = placeholderEl
                        , label = Input.labelHidden (opts.label |> Maybe.withDefault "input")
                        }

        helperEl =
            opts.helperText
                |> Maybe.map
                    (\t ->
                        Element.el
                            [ Font.size Tokens.fontSizeSm
                            , Font.color (validationHelperColor opts.validation)
                            , Element.paddingEach { top = Tokens.spacerXs, right = 0, bottom = 0, left = 0 }
                            ]
                            (Element.text t)
                    )
                |> Maybe.withDefault Element.none
    in
    Element.column
        [ Element.width Element.fill
        , Element.spacing 0
        ]
        [ labelEl
        , inputEl
        , helperEl
        ]
