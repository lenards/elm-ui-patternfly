module PF6.Radio exposing
    ( Radio
    , radio
    , withLabel, withDescription, withBody
    , withChecked, withDisabled
    , toMarkup
    )

{-| PF6 Radio component

Radio buttons allow users to select one option from a set.

See: <https://www.patternfly.org/components/radio>


# Definition

@docs Radio


# Constructor

@docs radio


# Content modifiers

@docs withLabel, withDescription, withBody


# State modifiers

@docs withChecked, withDisabled


# Rendering

@docs toMarkup

-}

import Element exposing (Element)
import Element.Font as Font
import Element.Input as Input
import PF6.Tokens as Tokens


{-| Opaque Radio type
-}
type Radio msg
    = Radio (Options msg)


type alias Options msg =
    { id : String
    , isChecked : Bool
    , isDisabled : Bool
    , label : String
    , description : Maybe String
    , body : Maybe (Element msg)
    , onChange : Bool -> msg
    }


{-| Construct a Radio button

    radio
        { id = "option-a"
        , onChange = OptionASelected
        }

-}
radio : { id : String, onChange : Bool -> msg } -> Radio msg
radio { id, onChange } =
    Radio
        { id = id
        , isChecked = False
        , isDisabled = False
        , label = ""
        , description = Nothing
        , body = Nothing
        , onChange = onChange
        }


{-| Set the radio label
-}
withLabel : String -> Radio msg -> Radio msg
withLabel l (Radio opts) =
    Radio { opts | label = l }


{-| Set a description below the label
-}
withDescription : String -> Radio msg -> Radio msg
withDescription d (Radio opts) =
    Radio { opts | description = Just d }


{-| Set body content below the radio
-}
withBody : Element msg -> Radio msg -> Radio msg
withBody el (Radio opts) =
    Radio { opts | body = Just el }


{-| Set the checked state
-}
withChecked : Bool -> Radio msg -> Radio msg
withChecked checked (Radio opts) =
    Radio { opts | isChecked = checked }


{-| Disable the radio button
-}
withDisabled : Radio msg -> Radio msg
withDisabled (Radio opts) =
    Radio { opts | isDisabled = True }


{-| Render the Radio as an `Element msg`
-}
toMarkup : Radio msg -> Element msg
toMarkup (Radio opts) =
    let
        descriptionEl =
            opts.description
                |> Maybe.map
                    (\d ->
                        Element.el
                            [ Font.size Tokens.fontSizeSm
                            , Font.color Tokens.colorTextSubtle
                            , Element.paddingEach { top = 0, right = 0, bottom = 0, left = 24 }
                            ]
                            (Element.text d)
                    )
                |> Maybe.withDefault Element.none

        bodyEl =
            opts.body
                |> Maybe.map
                    (\el ->
                        Element.el
                            [ Element.paddingEach { top = 0, right = 0, bottom = 0, left = 24 } ]
                            el
                    )
                |> Maybe.withDefault Element.none

        radioEl =
            Input.radio []
                { onChange =
                    if opts.isDisabled then
                        \_ -> opts.onChange opts.isChecked

                    else
                        opts.onChange
                , selected =
                    if opts.isChecked then
                        Just True

                    else
                        Nothing
                , label = Input.labelHidden opts.label
                , options =
                    [ Input.option True
                        (Element.el
                            [ Font.size Tokens.fontSizeMd
                            , Font.color
                                (if opts.isDisabled then
                                    Tokens.colorTextSubtle

                                 else
                                    Tokens.colorText
                                )
                            ]
                            (Element.text opts.label)
                        )
                    ]
                }
    in
    Element.column
        [ Element.spacing Tokens.spacerXs ]
        [ radioEl
        , descriptionEl
        , bodyEl
        ]
