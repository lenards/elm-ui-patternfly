module PF6.Slider exposing
    ( Slider
    , slider
    , withLabel, withStep, withDisabled, withShowValue, withShowTicks, withCustomThumb
    , toMarkup
    )

{-| PF6 Slider component

A range slider input with PF6 styling.

See: <https://www.patternfly.org/components/slider>


# Definition

@docs Slider


# Constructor

@docs slider


# Modifiers

@docs withLabel, withStep, withDisabled, withShowValue, withShowTicks, withCustomThumb


# Rendering

@docs toMarkup

-}

import Element exposing (Element)
import Element.Background as Bg
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import PF6.Tokens as Tokens


{-| Opaque Slider type
-}
type Slider msg
    = Slider (Options msg)


type alias Options msg =
    { value : Float
    , onChange : Float -> msg
    , min : Float
    , max : Float
    , label : Maybe String
    , step : Maybe Float
    , isDisabled : Bool
    , showValue : Bool
    , showTicks : Bool
    , customThumb : Maybe Input.Thumb
    }


{-| Construct a Slider

    slider { value = 50, onChange = SliderChanged, min = 0, max = 100 }

-}
slider : { value : Float, onChange : Float -> msg, min : Float, max : Float } -> Slider msg
slider config =
    Slider
        { value = config.value
        , onChange = config.onChange
        , min = config.min
        , max = config.max
        , label = Nothing
        , step = Nothing
        , isDisabled = False
        , showValue = False
        , showTicks = False
        , customThumb = Nothing
        }


{-| Set a visible label above the slider
-}
withLabel : String -> Slider msg -> Slider msg
withLabel l (Slider opts) =
    Slider { opts | label = Just l }


{-| Set the step increment
-}
withStep : Float -> Slider msg -> Slider msg
withStep s (Slider opts) =
    Slider { opts | step = Just s }


{-| Disable the slider
-}
withDisabled : Slider msg -> Slider msg
withDisabled (Slider opts) =
    Slider { opts | isDisabled = True }


{-| Show the current value next to the slider
-}
withShowValue : Slider msg -> Slider msg
withShowValue (Slider opts) =
    Slider { opts | showValue = True }


{-| Show tick marks along the track
-}
withShowTicks : Slider msg -> Slider msg
withShowTicks (Slider opts) =
    Slider { opts | showTicks = True }


{-| Provide a custom thumb element
-}
withCustomThumb : Input.Thumb -> Slider msg -> Slider msg
withCustomThumb thumb (Slider opts) =
    Slider { opts | customThumb = Just thumb }


defaultThumb : Input.Thumb
defaultThumb =
    Input.thumb
        [ Element.width (Element.px 20)
        , Element.height (Element.px 20)
        , Border.rounded 10
        , Bg.color Tokens.colorPrimary
        , Border.width 2
        , Border.color Tokens.colorBackgroundDefault
        ]


disabledThumb : Input.Thumb
disabledThumb =
    Input.thumb
        [ Element.width (Element.px 20)
        , Element.height (Element.px 20)
        , Border.rounded 10
        , Bg.color Tokens.colorTextSubtle
        , Border.width 2
        , Border.color Tokens.colorBackgroundDefault
        ]


formatValue : Float -> String
formatValue v =
    let
        rounded =
            toFloat (round (v * 100)) / 100
    in
    String.fromFloat rounded


{-| Render the Slider as an `Element msg`
-}
toMarkup : Slider msg -> Element msg
toMarkup (Slider opts) =
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

        thumb =
            if opts.isDisabled then
                disabledThumb

            else
                opts.customThumb |> Maybe.withDefault defaultThumb

        sliderEl =
            Input.slider
                [ Element.width Element.fill
                , Element.height (Element.px 38)
                , Element.behindContent
                    (Element.el
                        [ Element.width Element.fill
                        , Element.height (Element.px 4)
                        , Element.centerY
                        , Bg.color
                            (if opts.isDisabled then
                                Tokens.colorBorderDefault

                             else
                                Tokens.colorBorderDefault
                            )
                        , Border.rounded 2
                        ]
                        Element.none
                    )
                ]
                { onChange =
                    if opts.isDisabled then
                        \_ -> opts.onChange opts.value

                    else
                        opts.onChange
                , label = Input.labelHidden (opts.label |> Maybe.withDefault "slider")
                , min = opts.min
                , max = opts.max
                , value = opts.value
                , thumb = thumb
                , step = opts.step
                }

        valueEl =
            if opts.showValue then
                Element.el
                    [ Font.size Tokens.fontSizeMd
                    , Font.color Tokens.colorText
                    , Element.paddingXY Tokens.spacerSm 0
                    , Element.width (Element.px 60)
                    , Font.alignRight
                    ]
                    (Element.text (formatValue opts.value))

            else
                Element.none

        sliderRow =
            Element.row
                [ Element.width Element.fill
                , Element.spacing Tokens.spacerXs
                ]
                [ sliderEl, valueEl ]

        ticksEl =
            if opts.showTicks then
                Element.row
                    [ Element.width Element.fill
                    , Element.spaceEvenly
                    , Element.paddingEach { top = 0, right = 0, bottom = 0, left = 0 }
                    ]
                    [ Element.el [ Font.size Tokens.fontSizeSm, Font.color Tokens.colorTextSubtle ] (Element.text (formatValue opts.min))
                    , Element.el [ Font.size Tokens.fontSizeSm, Font.color Tokens.colorTextSubtle ] (Element.text (formatValue opts.max))
                    ]

            else
                Element.none
    in
    Element.column
        [ Element.width Element.fill
        , Element.spacing 0
        ]
        [ labelEl
        , sliderRow
        , ticksEl
        ]
