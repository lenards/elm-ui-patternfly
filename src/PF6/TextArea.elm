module PF6.TextArea exposing
    ( TextArea, ResizeDirection
    , textArea
    , withLabel, withPlaceholder, withRows, withDisabled, withRequired
    , withSuccess, withDanger, withHelperText
    , withResizeVertical, withResizeHorizontal, withResizeBoth
    , toMarkup
    )

{-| PF6 TextArea component

A multi-line text input for gathering longer text content.

See: <https://www.patternfly.org/components/text-area>


# Definition

@docs TextArea, ResizeDirection


# Constructor

@docs textArea


# Content modifiers

@docs withLabel, withPlaceholder, withRows, withDisabled, withRequired


# Validation modifiers

@docs withSuccess, withDanger, withHelperText


# Resize modifiers

@docs withResizeVertical, withResizeHorizontal, withResizeBoth


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


{-| Opaque TextArea type
-}
type TextArea msg
    = TextArea (Options msg)


{-| Resize direction
-}
type ResizeDirection
    = NoResize
    | Vertical
    | Horizontal
    | Both


type ValidationStatus
    = None
    | Success
    | Danger


type alias Options msg =
    { value : String
    , onChange : String -> msg
    , label : Maybe String
    , placeholder : Maybe String
    , rows : Int
    , isDisabled : Bool
    , isRequired : Bool
    , validation : ValidationStatus
    , helperText : Maybe String
    , resize : ResizeDirection
    }


{-| Construct a TextArea

    textArea { value = model.description, onChange = DescriptionChanged }

-}
textArea : { value : String, onChange : String -> msg } -> TextArea msg
textArea { value, onChange } =
    TextArea
        { value = value
        , onChange = onChange
        , label = Nothing
        , placeholder = Nothing
        , rows = 3
        , isDisabled = False
        , isRequired = False
        , validation = None
        , helperText = Nothing
        , resize = Vertical
        }


{-| Set the visible label
-}
withLabel : String -> TextArea msg -> TextArea msg
withLabel l (TextArea opts) =
    TextArea { opts | label = Just l }


{-| Set placeholder text
-}
withPlaceholder : String -> TextArea msg -> TextArea msg
withPlaceholder p (TextArea opts) =
    TextArea { opts | placeholder = Just p }


{-| Set the number of visible rows
-}
withRows : Int -> TextArea msg -> TextArea msg
withRows r (TextArea opts) =
    TextArea { opts | rows = r }


{-| Disable the textarea
-}
withDisabled : TextArea msg -> TextArea msg
withDisabled (TextArea opts) =
    TextArea { opts | isDisabled = True }


{-| Mark the textarea as required
-}
withRequired : TextArea msg -> TextArea msg
withRequired (TextArea opts) =
    TextArea { opts | isRequired = True }


{-| Success validation state (green border)
-}
withSuccess : TextArea msg -> TextArea msg
withSuccess (TextArea opts) =
    TextArea { opts | validation = Success }


{-| Danger/error validation state (red border)
-}
withDanger : TextArea msg -> TextArea msg
withDanger (TextArea opts) =
    TextArea { opts | validation = Danger }


{-| Set helper text below the input
-}
withHelperText : String -> TextArea msg -> TextArea msg
withHelperText t (TextArea opts) =
    TextArea { opts | helperText = Just t }


{-| Allow vertical resizing only
-}
withResizeVertical : TextArea msg -> TextArea msg
withResizeVertical (TextArea opts) =
    TextArea { opts | resize = Vertical }


{-| Allow horizontal resizing only
-}
withResizeHorizontal : TextArea msg -> TextArea msg
withResizeHorizontal (TextArea opts) =
    TextArea { opts | resize = Horizontal }


{-| Allow resizing in both directions
-}
withResizeBoth : TextArea msg -> TextArea msg
withResizeBoth (TextArea opts) =
    TextArea { opts | resize = Both }


validationBorderColor : ValidationStatus -> Element.Color
validationBorderColor status =
    case status of
        None ->
            Tokens.colorBorderDefault

        Success ->
            Tokens.colorSuccess

        Danger ->
            Tokens.colorDanger


validationHelperColor : ValidationStatus -> Element.Color
validationHelperColor status =
    case status of
        Danger ->
            Tokens.colorDanger

        _ ->
            Tokens.colorTextSubtle


{-| Render the TextArea as an `Element msg`
-}
toMarkup : TextArea msg -> Element msg
toMarkup (TextArea opts) =
    let
        borderColor =
            validationBorderColor opts.validation

        labelEl =
            opts.label
                |> Maybe.map
                    (\l ->
                        Element.row
                            [ Font.size Tokens.fontSizeMd
                            , Font.color Tokens.colorText
                            , Element.paddingEach { top = 0, right = 0, bottom = Tokens.spacerXs, left = 0 }
                            , Element.spacing Tokens.spacerXs
                            ]
                            [ Element.text l
                            , if opts.isRequired then
                                Element.el [ Font.color Tokens.colorDanger ] (Element.text "*")

                              else
                                Element.none
                            ]
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

        rowHeight =
            opts.rows * 20 + Tokens.spacerSm * 2

        inputEl =
            Input.multiline
                [ Element.width Element.fill
                , Element.height (Element.px rowHeight)
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
                , Element.htmlAttribute
                    (Html.Attributes.style "resize"
                        (case opts.resize of
                            NoResize ->
                                "none"

                            Vertical ->
                                "vertical"

                            Horizontal ->
                                "horizontal"

                            Both ->
                                "both"
                        )
                    )
                ]
                { onChange = opts.onChange
                , text = opts.value
                , placeholder = placeholderEl
                , label = Input.labelHidden (opts.label |> Maybe.withDefault "textarea")
                , spellcheck = True
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
