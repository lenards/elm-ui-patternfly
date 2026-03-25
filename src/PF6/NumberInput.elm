module PF6.NumberInput exposing
    ( NumberInput
    , numberInput
    , withMin, withMax, withStep
    , withLabel, withHelperText, withUnit
    , withDisabled, withDanger, withWarning, withSuccess
    , toMarkup
    )

{-| PF6 NumberInput component

NumberInput allows users to enter a numeric value with stepper controls.

See: <https://www.patternfly.org/components/number-input>


# Definition

@docs NumberInput


# Constructor

@docs numberInput


# Range modifiers

@docs withMin, withMax, withStep


# Content modifiers

@docs withLabel, withHelperText, withUnit


# State modifiers

@docs withDisabled, withDanger, withWarning, withSuccess


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


{-| Opaque NumberInput type
-}
type NumberInput msg
    = NumberInput (Options msg)


type ValidationStatus
    = NoValidation
    | ValidationSuccess
    | ValidationDanger
    | ValidationWarning


type alias Options msg =
    { value : Float
    , onChange : Float -> msg
    , min : Maybe Float
    , max : Maybe Float
    , step : Float
    , label : Maybe String
    , helperText : Maybe String
    , unit : Maybe String
    , isDisabled : Bool
    , validation : ValidationStatus
    }


{-| Construct a NumberInput

    numberInput { value = model.count, onChange = CountChanged }

-}
numberInput : { value : Float, onChange : Float -> msg } -> NumberInput msg
numberInput { value, onChange } =
    NumberInput
        { value = value
        , onChange = onChange
        , min = Nothing
        , max = Nothing
        , step = 1
        , label = Nothing
        , helperText = Nothing
        , unit = Nothing
        , isDisabled = False
        , validation = NoValidation
        }


{-| Set minimum value
-}
withMin : Float -> NumberInput msg -> NumberInput msg
withMin m (NumberInput opts) =
    NumberInput { opts | min = Just m }


{-| Set maximum value
-}
withMax : Float -> NumberInput msg -> NumberInput msg
withMax m (NumberInput opts) =
    NumberInput { opts | max = Just m }


{-| Set step size (default 1)
-}
withStep : Float -> NumberInput msg -> NumberInput msg
withStep s (NumberInput opts) =
    NumberInput { opts | step = s }


{-| Set visible label
-}
withLabel : String -> NumberInput msg -> NumberInput msg
withLabel l (NumberInput opts) =
    NumberInput { opts | label = Just l }


{-| Set helper text below the input
-}
withHelperText : String -> NumberInput msg -> NumberInput msg
withHelperText t (NumberInput opts) =
    NumberInput { opts | helperText = Just t }


{-| Set unit text displayed after the input (e.g., "%", "GB")
-}
withUnit : String -> NumberInput msg -> NumberInput msg
withUnit u (NumberInput opts) =
    NumberInput { opts | unit = Just u }


{-| Disable the input
-}
withDisabled : NumberInput msg -> NumberInput msg
withDisabled (NumberInput opts) =
    NumberInput { opts | isDisabled = True }


{-| Danger validation state
-}
withDanger : NumberInput msg -> NumberInput msg
withDanger (NumberInput opts) =
    NumberInput { opts | validation = ValidationDanger }


{-| Warning validation state
-}
withWarning : NumberInput msg -> NumberInput msg
withWarning (NumberInput opts) =
    NumberInput { opts | validation = ValidationWarning }


{-| Success validation state
-}
withSuccess : NumberInput msg -> NumberInput msg
withSuccess (NumberInput opts) =
    NumberInput { opts | validation = ValidationSuccess }


canDecrement : Options msg -> Bool
canDecrement opts =
    not opts.isDisabled
        && (opts.min |> Maybe.map (\m -> opts.value > m) |> Maybe.withDefault True)


canIncrement : Options msg -> Bool
canIncrement opts =
    not opts.isDisabled
        && (opts.max |> Maybe.map (\m -> opts.value < m) |> Maybe.withDefault True)


clampedValue : Options msg -> Float -> Float
clampedValue opts v =
    let
        withMin_ =
            opts.min |> Maybe.map (\m -> max m v) |> Maybe.withDefault v

        withMax_ =
            opts.max |> Maybe.map (\m -> min m withMin_) |> Maybe.withDefault withMin_
    in
    withMax_


borderColor : Theme -> ValidationStatus -> Element.Color
borderColor theme v =
    case v of
        NoValidation ->
            Theme.borderDefault theme

        ValidationSuccess ->
            Theme.success theme

        ValidationDanger ->
            Theme.danger theme

        ValidationWarning ->
            Theme.warning theme


stepperBtn : Theme -> String -> Maybe msg -> Element msg
stepperBtn theme label onPress =
    Input.button
        [ Element.paddingXY Tokens.spacerSm Tokens.spacerXs
        , Bg.color (Theme.backgroundSecondary theme)
        , Font.size Tokens.fontSizeMd
        , Font.color
            (case onPress of
                Nothing ->
                    Theme.textSubtle theme

                Just _ ->
                    Theme.text theme
            )
        , Border.widthEach { top = 0, right = 0, bottom = 0, left = 1 }
        , Border.color (Theme.borderDefault theme)
        ]
        { onPress = onPress
        , label = Element.text label
        }


{-| Render the NumberInput as an `Element msg`
-}
toMarkup : Theme -> NumberInput msg -> Element msg
toMarkup theme (NumberInput opts) =
    let
        bc =
            borderColor theme opts.validation

        displayValue =
            if opts.step == toFloat (round opts.step) then
                String.fromInt (round opts.value)

            else
                String.fromFloat opts.value

        labelEl =
            opts.label
                |> Maybe.map
                    (\l ->
                        Element.el
                            [ Font.size Tokens.fontSizeMd
                            , Font.bold
                            , Font.color (Theme.text theme)
                            , Element.paddingEach { top = 0, right = 0, bottom = Tokens.spacerXs, left = 0 }
                            ]
                            (Element.text l)
                    )
                |> Maybe.withDefault Element.none

        decrementBtn =
            stepperBtn theme "−"
                (if canDecrement opts then
                    Just (opts.onChange (clampedValue opts (opts.value - opts.step)))

                 else
                    Nothing
                )

        incrementBtn =
            stepperBtn theme "+"
                (if canIncrement opts then
                    Just (opts.onChange (clampedValue opts (opts.value + opts.step)))

                 else
                    Nothing
                )

        valueEl =
            Element.el
                [ Element.paddingXY Tokens.spacerSm Tokens.spacerXs
                , Font.size Tokens.fontSizeMd
                , Font.color (Theme.text theme)
                , Element.width (Element.minimum 60 Element.shrink)
                , Element.centerX
                ]
                (Element.text displayValue)

        unitEl =
            opts.unit
                |> Maybe.map
                    (\u ->
                        Element.el
                            [ Font.size Tokens.fontSizeMd
                            , Font.color (Theme.textSubtle theme)
                            , Element.paddingEach { top = 0, right = 0, bottom = 0, left = Tokens.spacerXs }
                            ]
                            (Element.text u)
                    )
                |> Maybe.withDefault Element.none

        helperEl =
            opts.helperText
                |> Maybe.map
                    (\t ->
                        Element.el
                            [ Font.size Tokens.fontSizeSm
                            , Font.color (Theme.textSubtle theme)
                            , Element.paddingEach { top = Tokens.spacerXs, right = 0, bottom = 0, left = 0 }
                            ]
                            (Element.text t)
                    )
                |> Maybe.withDefault Element.none

        inputRow =
            Element.row
                [ Element.spacing Tokens.spacerXs ]
                [ Element.row
                    [ Border.rounded Tokens.radiusMd
                    , Border.solid
                    , Border.width 1
                    , Border.color bc
                    , Bg.color
                        (if opts.isDisabled then
                            Theme.backgroundSecondary theme

                         else
                            Theme.backgroundDefault theme
                        )
                    ]
                    [ decrementBtn, valueEl, incrementBtn ]
                , unitEl
                ]
    in
    Element.column
        [ Element.width Element.shrink ]
        [ labelEl
        , inputRow
        , helperEl
        ]
