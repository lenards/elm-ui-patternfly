module PF6.Checkbox exposing
    ( Checkbox
    , checkbox
    , withLabel, withDescription, withBody
    , withChecked, withIndeterminate, withDisabled
    , toMarkup
    )

{-| PF6 Checkbox component

Checkboxes allow users to select one or more items from a list.

See: <https://www.patternfly.org/components/checkbox>


# Definition

@docs Checkbox


# Constructor

@docs checkbox


# Content modifiers

@docs withLabel, withDescription, withBody


# State modifiers

@docs withChecked, withIndeterminate, withDisabled


# Rendering

@docs toMarkup

-}

import Element exposing (Element)
import Element.Font as Font
import Element.Input as Input
import PF6.Theme as Theme exposing (Theme)
import PF6.Tokens as Tokens


{-| Opaque Checkbox type
-}
type Checkbox msg
    = Checkbox (Options msg)


type alias Options msg =
    { id : String
    , isChecked : Bool
    , isIndeterminate : Bool
    , isDisabled : Bool
    , label : String
    , description : Maybe String
    , body : Maybe (Element msg)
    , onChange : Bool -> msg
    }


{-| Construct a Checkbox

    checkbox
        { id = "my-check"
        , onChange = CheckboxToggled
        }

-}
checkbox : { id : String, onChange : Bool -> msg } -> Checkbox msg
checkbox { id, onChange } =
    Checkbox
        { id = id
        , isChecked = False
        , isIndeterminate = False
        , isDisabled = False
        , label = ""
        , description = Nothing
        , body = Nothing
        , onChange = onChange
        }


{-| Set the checkbox label
-}
withLabel : String -> Checkbox msg -> Checkbox msg
withLabel l (Checkbox opts) =
    Checkbox { opts | label = l }


{-| Set a description below the label
-}
withDescription : String -> Checkbox msg -> Checkbox msg
withDescription d (Checkbox opts) =
    Checkbox { opts | description = Just d }


{-| Set body content (arbitrary element) below the checkbox
-}
withBody : Element msg -> Checkbox msg -> Checkbox msg
withBody el (Checkbox opts) =
    Checkbox { opts | body = Just el }


{-| Set the checked state
-}
withChecked : Bool -> Checkbox msg -> Checkbox msg
withChecked checked (Checkbox opts) =
    Checkbox { opts | isChecked = checked }


{-| Set indeterminate state (partially checked)
-}
withIndeterminate : Checkbox msg -> Checkbox msg
withIndeterminate (Checkbox opts) =
    Checkbox { opts | isIndeterminate = True, isChecked = False }


{-| Disable the checkbox
-}
withDisabled : Checkbox msg -> Checkbox msg
withDisabled (Checkbox opts) =
    Checkbox { opts | isDisabled = True }


{-| Render the Checkbox as an `Element msg`
-}
toMarkup : Theme -> Checkbox msg -> Element msg
toMarkup theme (Checkbox opts) =
    let
        descriptionEl =
            opts.description
                |> Maybe.map
                    (\d ->
                        Element.el
                            [ Font.size Tokens.fontSizeSm
                            , Font.color (Theme.textSubtle theme)
                            ]
                            (Element.text d)
                    )
                |> Maybe.withDefault Element.none

        bodyEl =
            opts.body |> Maybe.withDefault Element.none

        checkEl =
            Input.checkbox []
                { onChange =
                    if opts.isDisabled then
                        \_ -> opts.onChange opts.isChecked

                    else
                        opts.onChange
                , icon = Input.defaultCheckbox
                , checked = opts.isChecked
                , label =
                    Input.labelRight
                        [ Font.size Tokens.fontSizeMd
                        , Font.color
                            (if opts.isDisabled then
                                Theme.textSubtle theme

                             else
                                Theme.text theme
                            )
                        ]
                        (Element.text opts.label)
                }
    in
    Element.column
        [ Element.spacing Tokens.spacerXs ]
        [ checkEl
        , descriptionEl
        , bodyEl
        ]
