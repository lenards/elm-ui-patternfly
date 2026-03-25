module PF6.InlineEdit exposing
    ( InlineEdit
    , inlineEdit
    , withValue
    , withPlaceholder
    , withEditing
    , withOnEdit
    , withOnChange
    , withOnSave
    , withOnCancel
    , withIsDisabled
    , toMarkup
    )

{-| PF6 InlineEdit component

Displays text that can be toggled into an editable input. The consumer controls
the `editing` state, current value, and all transition messages.

    -- Model
    type alias Model =
        { name : String, editingName : Bool }

    -- Msg
    type Msg = EditName | NameChanged String | SaveName | CancelName

    -- View
    InlineEdit.inlineEdit model.name
        |> InlineEdit.withEditing model.editingName
        |> InlineEdit.withOnEdit EditName
        |> InlineEdit.withOnChange NameChanged
        |> InlineEdit.withOnSave SaveName
        |> InlineEdit.withOnCancel CancelName
        |> InlineEdit.toMarkup theme

See: <https://www.patternfly.org/components/inline-edit>


# Definition

@docs InlineEdit


# Constructor

@docs inlineEdit


# Value modifiers

@docs withValue, withPlaceholder


# State modifiers

@docs withEditing, withIsDisabled


# Event modifiers

@docs withOnEdit, withOnChange, withOnSave, withOnCancel


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


{-| Opaque InlineEdit type
-}
type InlineEdit msg
    = InlineEdit (Options msg)


type alias Options msg =
    { value : String
    , placeholder : String
    , isEditing : Bool
    , isDisabled : Bool
    , onEdit : Maybe msg
    , onChange : Maybe (String -> msg)
    , onSave : Maybe msg
    , onCancel : Maybe msg
    }


{-| Construct an InlineEdit with the given display value
-}
inlineEdit : String -> InlineEdit msg
inlineEdit value =
    InlineEdit
        { value = value
        , placeholder = "Click to edit"
        , isEditing = False
        , isDisabled = False
        , onEdit = Nothing
        , onChange = Nothing
        , onSave = Nothing
        , onCancel = Nothing
        }


{-| Set the current text value
-}
withValue : String -> InlineEdit msg -> InlineEdit msg
withValue v (InlineEdit opts) =
    InlineEdit { opts | value = v }


{-| Set the placeholder text shown when value is empty
-}
withPlaceholder : String -> InlineEdit msg -> InlineEdit msg
withPlaceholder p (InlineEdit opts) =
    InlineEdit { opts | placeholder = p }


{-| Put the component into editing mode (shows input + save/cancel)
-}
withEditing : Bool -> InlineEdit msg -> InlineEdit msg
withEditing editing (InlineEdit opts) =
    InlineEdit { opts | isEditing = editing }


{-| Disable editing (hides the edit button)
-}
withIsDisabled : InlineEdit msg -> InlineEdit msg
withIsDisabled (InlineEdit opts) =
    InlineEdit { opts | isDisabled = True }


{-| Message sent when the edit (pencil) button is clicked
-}
withOnEdit : msg -> InlineEdit msg -> InlineEdit msg
withOnEdit msg (InlineEdit opts) =
    InlineEdit { opts | onEdit = Just msg }


{-| Message sent as the user types (provides new string value).
Required for the text input to function in editing mode.
-}
withOnChange : (String -> msg) -> InlineEdit msg -> InlineEdit msg
withOnChange f (InlineEdit opts) =
    InlineEdit { opts | onChange = Just f }


{-| Message sent when the save (✓) button is clicked
-}
withOnSave : msg -> InlineEdit msg -> InlineEdit msg
withOnSave msg (InlineEdit opts) =
    InlineEdit { opts | onSave = Just msg }


{-| Message sent when the cancel (×) button is clicked
-}
withOnCancel : msg -> InlineEdit msg -> InlineEdit msg
withOnCancel msg (InlineEdit opts) =
    InlineEdit { opts | onCancel = Just msg }


saveBtn : Theme -> Maybe msg -> Element msg
saveBtn theme onSave =
    Input.button
        [ Bg.color (Theme.success theme)
        , Font.color (Theme.textOnDark theme)
        , Border.rounded Tokens.radiusMd
        , Element.paddingXY Tokens.spacerSm Tokens.spacerXs
        , Font.size Tokens.fontSizeMd
        ]
        { onPress = onSave
        , label = Element.text "✓"
        }


cancelBtn : Theme -> Maybe msg -> Element msg
cancelBtn theme onCancel =
    Input.button
        [ Bg.color (Theme.backgroundSecondary theme)
        , Font.color (Theme.text theme)
        , Border.rounded Tokens.radiusMd
        , Border.solid
        , Border.width 1
        , Border.color (Theme.borderDefault theme)
        , Element.paddingXY Tokens.spacerSm Tokens.spacerXs
        , Font.size Tokens.fontSizeMd
        ]
        { onPress = onCancel
        , label = Element.text "×"
        }


{-| Render the InlineEdit as an `Element msg`
-}
toMarkup : Theme -> InlineEdit msg -> Element msg
toMarkup theme (InlineEdit opts) =
    if opts.isEditing then
        case opts.onChange of
            Just onChange ->
                -- Full edit mode: text input + save/cancel
                Element.row
                    [ Element.width Element.fill
                    , Element.spacing Tokens.spacerXs
                    ]
                    [ Input.text
                        [ Element.width Element.fill
                        , Bg.color (Theme.backgroundDefault theme)
                        , Border.rounded Tokens.radiusMd
                        , Border.solid
                        , Border.width 1
                        , Border.color (Theme.primary theme)
                        , Font.size Tokens.fontSizeMd
                        , Font.color (Theme.text theme)
                        , Element.paddingXY Tokens.spacerSm Tokens.spacerXs
                        ]
                        { onChange = onChange
                        , text = opts.value
                        , placeholder =
                            Just
                                (Input.placeholder
                                    [ Font.color (Theme.textSubtle theme) ]
                                    (Element.text opts.placeholder)
                                )
                        , label = Input.labelHidden "inline edit"
                        }
                    , saveBtn theme opts.onSave
                    , cancelBtn theme opts.onCancel
                    ]

            Nothing ->
                -- No onChange provided: show value as text with save/cancel
                Element.row
                    [ Element.width Element.fill
                    , Element.spacing Tokens.spacerXs
                    ]
                    [ Element.el
                        [ Font.size Tokens.fontSizeMd
                        , Font.color (Theme.text theme)
                        , Element.width Element.fill
                        ]
                        (Element.text opts.value)
                    , saveBtn theme opts.onSave
                    , cancelBtn theme opts.onCancel
                    ]

    else
        -- View mode: text + optional edit button
        Element.row
            [ Element.width Element.fill
            , Element.spacing Tokens.spacerXs
            ]
            [ Element.el
                [ Font.size Tokens.fontSizeMd
                , Font.color
                    (if String.isEmpty opts.value then
                        Theme.textSubtle theme

                     else
                        Theme.text theme
                    )
                ]
                (Element.text
                    (if String.isEmpty opts.value then
                        opts.placeholder

                     else
                        opts.value
                    )
                )
            , if opts.isDisabled then
                Element.none

              else
                Input.button
                    [ Font.color (Theme.textSubtle theme)
                    , Font.size Tokens.fontSizeMd
                    , Element.htmlAttribute (Html.Attributes.title "Edit")
                    ]
                    { onPress = opts.onEdit
                    , label = Element.text "✏"
                    }
            ]
