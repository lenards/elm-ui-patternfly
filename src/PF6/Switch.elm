module PF6.Switch exposing
    ( Switch
    , switch
    , withLabel, withLabelOff, withAriaLabel
    , withChecked, withDisabled, withReversed
    , toMarkup
    )

{-| PF6 Switch component

A switch toggles the state of a setting on or off.

See: <https://www.patternfly.org/components/switch>


# Definition

@docs Switch


# Constructor

@docs switch


# Content modifiers

@docs withLabel, withLabelOff, withAriaLabel


# State modifiers

@docs withChecked, withDisabled, withReversed


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


{-| Opaque Switch type
-}
type Switch msg
    = Switch (Options msg)


type alias Options msg =
    { isChecked : Bool
    , isDisabled : Bool
    , isReversed : Bool
    , labelOn : String
    , labelOff : Maybe String
    , ariaLabel : String
    , onChange : Bool -> msg
    }


{-| Construct a Switch

    switch { onChange = ToggleFeature }

-}
switch : { onChange : Bool -> msg } -> Switch msg
switch { onChange } =
    Switch
        { isChecked = False
        , isDisabled = False
        , isReversed = False
        , labelOn = ""
        , labelOff = Nothing
        , ariaLabel = "toggle"
        , onChange = onChange
        }


{-| Set the "on" label (shown when checked)
-}
withLabel : String -> Switch msg -> Switch msg
withLabel l (Switch opts) =
    Switch { opts | labelOn = l }


{-| Set a separate "off" label (shown when unchecked)
-}
withLabelOff : String -> Switch msg -> Switch msg
withLabelOff l (Switch opts) =
    Switch { opts | labelOff = Just l }


{-| Set aria-label for accessibility
-}
withAriaLabel : String -> Switch msg -> Switch msg
withAriaLabel l (Switch opts) =
    Switch { opts | ariaLabel = l }


{-| Set checked state
-}
withChecked : Bool -> Switch msg -> Switch msg
withChecked checked (Switch opts) =
    Switch { opts | isChecked = checked }


{-| Disable the switch
-}
withDisabled : Switch msg -> Switch msg
withDisabled (Switch opts) =
    Switch { opts | isDisabled = True }


{-| Place the label before the toggle (reversed layout)
-}
withReversed : Switch msg -> Switch msg
withReversed (Switch opts) =
    Switch { opts | isReversed = True }


toggleEl : Theme -> Options msg -> Element msg
toggleEl theme opts =
    let
        trackColor =
            if opts.isChecked then
                Theme.primary theme

            else
                Theme.borderDefault theme

        knobLeft =
            if opts.isChecked then
                Element.alignRight

            else
                Element.alignLeft

        track =
            Element.el
                [ Element.width (Element.px 36)
                , Element.height (Element.px 20)
                , Bg.color trackColor
                , Border.rounded 10
                , Element.padding 2
                ]
                (Element.el
                    [ Element.width (Element.px 16)
                    , Element.height (Element.px 16)
                    , Bg.color (Theme.backgroundDefault theme)
                    , Border.rounded 8
                    , knobLeft
                    ]
                    Element.none
                )
    in
    Input.button []
        { onPress =
            if opts.isDisabled then
                Nothing

            else
                Just (opts.onChange (not opts.isChecked))
        , label = track
        }


labelText : Options msg -> String
labelText opts =
    let
        offLabel =
            opts.labelOff |> Maybe.withDefault opts.labelOn
    in
    if opts.isChecked then
        opts.labelOn

    else
        offLabel


{-| Render the Switch as an `Element msg`
-}
toMarkup : Theme -> Switch msg -> Element msg
toMarkup theme (Switch opts) =
    let
        textColor =
            if opts.isDisabled then
                Theme.textSubtle theme

            else
                Theme.text theme

        labelEl =
            if String.isEmpty opts.labelOn then
                Element.none

            else
                Element.el
                    [ Font.size Tokens.fontSizeMd
                    , Font.color textColor
                    ]
                    (Element.text (labelText opts))

        toggle =
            toggleEl theme opts
    in
    Element.row
        [ Element.spacing Tokens.spacerSm ]
        (if opts.isReversed then
            [ labelEl, toggle ]

         else
            [ toggle, labelEl ]
        )
