module PF6.Select exposing
    ( Select, SelectOption
    , select
    , option, optionGroup
    , withPlaceholder, withLabel, withHelperText
    , withDisabled, withDanger, withSuccess, withWarning
    , toMarkup
    )

{-| PF6 Select component

Select components allow users to choose one or more values from a list.

See: <https://www.patternfly.org/components/menus/select>


# Definition

@docs Select, SelectOption


# Constructor

@docs select


# Option constructors

@docs option, optionGroup


# Content modifiers

@docs withPlaceholder, withLabel, withHelperText


# State modifiers

@docs withDisabled, withDanger, withSuccess, withWarning


# Rendering

@docs toMarkup

-}

import Element exposing (Element)
import Element.Background as Bg
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import Html.Attributes
import PF6.Tokens as Tokens


{-| Opaque Select type
-}
type Select msg
    = Select (Options msg)


{-| A selectable option
-}
type SelectOption msg
    = Option { value : String, label : String, isDisabled : Bool }
    | OptionGroup { groupLabel : String, options : List (SelectOption msg) }


type ValidationStatus
    = NoValidation
    | ValidationSuccess
    | ValidationDanger
    | ValidationWarning


type alias Options msg =
    { selected : Maybe String
    , options : List (SelectOption msg)
    , onSelect : String -> msg
    , isOpen : Bool
    , onToggle : Bool -> msg
    , placeholder : String
    , label : Maybe String
    , helperText : Maybe String
    , isDisabled : Bool
    , validation : ValidationStatus
    }


{-| Construct a Select

    select
        { selected = model.selectedColor
        , isOpen = model.selectOpen
        , onToggle = SelectToggled
        , onSelect = ColorSelected
        , options = [ option "red" "Red", option "blue" "Blue" ]
        }

-}
select :
    { selected : Maybe String
    , isOpen : Bool
    , onToggle : Bool -> msg
    , onSelect : String -> msg
    , options : List (SelectOption msg)
    }
    -> Select msg
select config =
    Select
        { selected = config.selected
        , options = config.options
        , onSelect = config.onSelect
        , isOpen = config.isOpen
        , onToggle = config.onToggle
        , placeholder = "Select..."
        , label = Nothing
        , helperText = Nothing
        , isDisabled = False
        , validation = NoValidation
        }


{-| Create a single option
-}
option : String -> String -> SelectOption msg
option value label =
    Option { value = value, label = label, isDisabled = False }


{-| Create a group of options with a header label
-}
optionGroup : String -> List (SelectOption msg) -> SelectOption msg
optionGroup groupLabel options =
    OptionGroup { groupLabel = groupLabel, options = options }


{-| Set placeholder text (shown when nothing selected)
-}
withPlaceholder : String -> Select msg -> Select msg
withPlaceholder p (Select opts) =
    Select { opts | placeholder = p }


{-| Set a visible label above the select
-}
withLabel : String -> Select msg -> Select msg
withLabel l (Select opts) =
    Select { opts | label = Just l }


{-| Set helper text below the select
-}
withHelperText : String -> Select msg -> Select msg
withHelperText t (Select opts) =
    Select { opts | helperText = Just t }


{-| Disable the select
-}
withDisabled : Select msg -> Select msg
withDisabled (Select opts) =
    Select { opts | isDisabled = True }


{-| Danger/error validation state
-}
withDanger : Select msg -> Select msg
withDanger (Select opts) =
    Select { opts | validation = ValidationDanger }


{-| Success validation state
-}
withSuccess : Select msg -> Select msg
withSuccess (Select opts) =
    Select { opts | validation = ValidationSuccess }


{-| Warning validation state
-}
withWarning : Select msg -> Select msg
withWarning (Select opts) =
    Select { opts | validation = ValidationWarning }


borderColor : ValidationStatus -> Element.Color
borderColor v =
    case v of
        NoValidation ->
            Tokens.colorBorderDefault

        ValidationSuccess ->
            Tokens.colorSuccess

        ValidationDanger ->
            Tokens.colorDanger

        ValidationWarning ->
            Tokens.colorWarning


displayLabel : Options msg -> String
displayLabel opts =
    case opts.selected of
        Nothing ->
            opts.placeholder

        Just val ->
            opts.options
                |> List.concatMap flattenOptions
                |> List.filterMap
                    (\o ->
                        case o of
                            Option { value, label } ->
                                if value == val then
                                    Just label

                                else
                                    Nothing

                            _ ->
                                Nothing
                    )
                |> List.head
                |> Maybe.withDefault val


flattenOptions : SelectOption msg -> List (SelectOption msg)
flattenOptions opt =
    case opt of
        Option _ ->
            [ opt ]

        OptionGroup { options } ->
            List.concatMap flattenOptions options


renderOption : Options msg -> SelectOption msg -> List (Element msg)
renderOption opts selectOpt =
    case selectOpt of
        Option { value, label, isDisabled } ->
            let
                isSelected =
                    opts.selected == Just value
            in
            [ Input.button
                [ Element.width Element.fill
                , Element.paddingXY Tokens.spacerMd Tokens.spacerSm
                , Font.size Tokens.fontSizeMd
                , Font.color
                    (if isDisabled then
                        Tokens.colorTextSubtle

                     else
                        Tokens.colorText
                    )
                , Bg.color
                    (if isSelected then
                        Element.rgb255 215 235 255

                     else
                        Tokens.colorBackgroundDefault
                    )
                , Element.mouseOver [ Bg.color Tokens.colorBackgroundSecondary ]
                ]
                { onPress =
                    if isDisabled then
                        Nothing

                    else
                        Just (opts.onSelect value)
                , label =
                    Element.row [ Element.spacing Tokens.spacerSm ]
                        [ if isSelected then
                            Element.el [ Font.color Tokens.colorPrimary ] (Element.text "✓")

                          else
                            Element.el [ Element.width (Element.px 16) ] Element.none
                        , Element.text label
                        ]
                }
            ]

        OptionGroup { groupLabel, options } ->
            Element.el
                [ Element.width Element.fill
                , Element.paddingXY Tokens.spacerMd Tokens.spacerXs
                , Font.size Tokens.fontSizeSm
                , Font.bold
                , Font.color Tokens.colorTextSubtle
                ]
                (Element.text (String.toUpper groupLabel))
                :: List.concatMap (renderOption opts) options


{-| Render the Select as an `Element msg`
-}
toMarkup : Select msg -> Element msg
toMarkup (Select opts) =
    let
        bc =
            borderColor opts.validation

        labelEl =
            opts.label
                |> Maybe.map
                    (\l ->
                        Element.el
                            [ Font.size Tokens.fontSizeMd
                            , Font.bold
                            , Font.color Tokens.colorText
                            , Element.paddingEach { top = 0, right = 0, bottom = Tokens.spacerXs, left = 0 }
                            ]
                            (Element.text l)
                    )
                |> Maybe.withDefault Element.none

        toggleEl =
            Input.button
                [ Element.width Element.fill
                , Element.paddingXY Tokens.spacerSm Tokens.spacerSm
                , Border.rounded Tokens.radiusMd
                , Border.solid
                , Border.width 1
                , Border.color bc
                , Bg.color
                    (if opts.isDisabled then
                        Tokens.colorBackgroundSecondary

                     else
                        Tokens.colorBackgroundDefault
                    )
                ]
                { onPress =
                    if opts.isDisabled then
                        Nothing

                    else
                        Just (opts.onToggle (not opts.isOpen))
                , label =
                    Element.row
                        [ Element.width Element.fill ]
                        [ Element.el
                            [ Element.width Element.fill
                            , Font.size Tokens.fontSizeMd
                            , Font.color
                                (if opts.selected == Nothing then
                                    Tokens.colorTextSubtle

                                 else
                                    Tokens.colorText
                                )
                            ]
                            (Element.text (displayLabel opts))
                        , Element.el
                            [ Font.size Tokens.fontSizeSm
                            , Font.color Tokens.colorTextSubtle
                            ]
                            (Element.text
                                (if opts.isOpen then
                                    "▲"

                                 else
                                    "▼"
                                )
                            )
                        ]
                }

        menuEl =
            if opts.isOpen then
                Element.column
                    [ Element.width Element.fill
                    , Bg.color Tokens.colorBackgroundDefault
                    , Border.solid
                    , Border.width 1
                    , Border.color Tokens.colorBorderDefault
                    , Border.rounded Tokens.radiusMd
                    , Element.htmlAttribute (Html.Attributes.style "box-shadow" "0 0.25rem 0.5rem rgba(3,3,3,0.12)")
                    , Element.htmlAttribute (Html.Attributes.style "z-index" "200")
                    , Element.htmlAttribute (Html.Attributes.style "max-height" "300px")
                    , Element.htmlAttribute (Html.Attributes.style "overflow-y" "auto")
                    ]
                    (List.concatMap (renderOption opts) opts.options)

            else
                Element.none

        helperEl =
            opts.helperText
                |> Maybe.map
                    (\t ->
                        Element.el
                            [ Font.size Tokens.fontSizeSm
                            , Font.color Tokens.colorTextSubtle
                            , Element.paddingEach { top = Tokens.spacerXs, right = 0, bottom = 0, left = 0 }
                            ]
                            (Element.text t)
                    )
                |> Maybe.withDefault Element.none
    in
    Element.column
        [ Element.width Element.fill ]
        [ labelEl
        , Element.el [ Element.width Element.fill, Element.below menuEl ] toggleEl
        , helperEl
        ]
