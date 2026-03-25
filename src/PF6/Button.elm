module PF6.Button exposing
    ( Button, Variant, Size, Position
    , button, primary, secondary, tertiary, danger, warning, plain, link, control
    , withSmallSize, withLargeSize, withDefaultSize
    , withIcon, withIconLeft, withIconRight
    , withDisabled
    , toMarkup
    )

{-| PF6 Button component

Supports all PF6 button variants, sizes, and icon positions.

See: <https://www.patternfly.org/components/button>


# Definition

@docs Button, Variant, Size, Position


# Constructor functions

@docs button, primary, secondary, tertiary, danger, warning, plain, link, control


# Size modifiers

@docs withSmallSize, withLargeSize, withDefaultSize


# Icon modifiers

@docs withIcon, withIconLeft, withIconRight


# State modifiers

@docs withDisabled


# Rendering

@docs toMarkup

-}

import Element exposing (Element)
import Element.Background as Bg
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import PF6.Tokens as Tokens


{-| Opaque Button type
-}
type Button msg
    = Button (Options msg)


{-| Button visual variants
-}
type Variant
    = Primary
    | Secondary
    | Tertiary
    | Danger
    | Warning
    | Plain
    | Link
    | Control


{-| Button size
-}
type Size
    = Default
    | Small
    | Large


{-| Icon position relative to label text
-}
type Position
    = Left
    | Right


type alias IconEl msg =
    { element : Element msg
    , position : Position
    }


type alias Options msg =
    { label : String
    , variant : Variant
    , size : Size
    , icon : Maybe (IconEl msg)
    , onPress : Maybe msg
    , isDisabled : Bool
    }


defaultOptions : { label : String, onPress : Maybe msg } -> Options msg
defaultOptions { label, onPress } =
    { label = label
    , onPress = onPress
    , variant = Plain
    , size = Default
    , icon = Nothing
    , isDisabled = False
    }


construct : { label : String, onPress : Maybe msg } -> Variant -> Button msg
construct args variant =
    let
        defaults =
            defaultOptions args
    in
    Button { defaults | variant = variant }


{-| Plain button (no styling)
-}
button : { label : String, onPress : Maybe msg } -> Button msg
button args =
    Button (defaultOptions args)


{-| Primary filled button — main call to action
-}
primary : { label : String, onPress : Maybe msg } -> Button msg
primary args =
    construct args Primary


{-| Secondary outlined button
-}
secondary : { label : String, onPress : Maybe msg } -> Button msg
secondary args =
    construct args Secondary


{-| Tertiary outlined button with dark border
-}
tertiary : { label : String, onPress : Maybe msg } -> Button msg
tertiary args =
    construct args Tertiary


{-| Danger filled button — destructive action
-}
danger : { label : String, onPress : Maybe msg } -> Button msg
danger args =
    construct args Danger


{-| Warning filled button — potentially risky action
-}
warning : { label : String, onPress : Maybe msg } -> Button msg
warning args =
    construct args Warning


{-| Plain button with no background or border
-}
plain : { label : String, onPress : Maybe msg } -> Button msg
plain args =
    construct args Plain


{-| Link-style button
-}
link : { label : String, onPress : Maybe msg } -> Button msg
link args =
    construct args Link


{-| Control button — used in toolbars and input groups
-}
control : { label : String, onPress : Maybe msg } -> Button msg
control args =
    construct args Control


{-| Set button size to small
-}
withSmallSize : Button msg -> Button msg
withSmallSize (Button opts) =
    Button { opts | size = Small }


{-| Set button size to large
-}
withLargeSize : Button msg -> Button msg
withLargeSize (Button opts) =
    Button { opts | size = Large }


{-| Set button size to default
-}
withDefaultSize : Button msg -> Button msg
withDefaultSize (Button opts) =
    Button { opts | size = Default }


{-| Add an icon; defaults to left position
-}
withIcon : Element msg -> Button msg -> Button msg
withIcon icon (Button opts) =
    Button { opts | icon = Just { element = icon, position = Left } }


{-| Position icon to the left of the label
-}
withIconLeft : Button msg -> Button msg
withIconLeft (Button opts) =
    let
        updated =
            opts.icon |> Maybe.map (\i -> { i | position = Left })
    in
    Button { opts | icon = updated }


{-| Position icon to the right of the label
-}
withIconRight : Button msg -> Button msg
withIconRight (Button opts) =
    let
        updated =
            opts.icon |> Maybe.map (\i -> { i | position = Right })
    in
    Button { opts | icon = updated }


{-| Mark the button as disabled
-}
withDisabled : Button msg -> Button msg
withDisabled (Button opts) =
    Button { opts | isDisabled = True, onPress = Nothing }


variantAttrs : Variant -> List (Element.Attribute msg)
variantAttrs variant =
    case variant of
        Primary ->
            [ Bg.color Tokens.colorPrimary
            , Font.color Tokens.colorTextOnDark
            , Border.rounded Tokens.radiusMd
            , Border.width 0
            ]

        Secondary ->
            [ Bg.color Tokens.colorBackgroundDefault
            , Font.color Tokens.colorPrimary
            , Border.rounded Tokens.radiusMd
            , Border.solid
            , Border.width 1
            , Border.color Tokens.colorPrimary
            ]

        Tertiary ->
            [ Bg.color Tokens.colorBackgroundDefault
            , Font.color Tokens.colorText
            , Border.rounded Tokens.radiusMd
            , Border.solid
            , Border.width 1
            , Border.color Tokens.colorText
            ]

        Danger ->
            [ Bg.color Tokens.colorDanger
            , Font.color Tokens.colorTextOnDark
            , Border.rounded Tokens.radiusMd
            , Border.width 0
            ]

        Warning ->
            [ Bg.color Tokens.colorWarning
            , Font.color Tokens.colorText
            , Border.rounded Tokens.radiusMd
            , Border.width 0
            ]

        Plain ->
            [ Bg.color Tokens.colorBackgroundDefault
            , Font.color Tokens.colorText
            , Border.rounded Tokens.radiusMd
            , Border.width 0
            ]

        Link ->
            [ Font.color Tokens.colorPrimary
            , Font.underline
            , Border.width 0
            ]

        Control ->
            [ Bg.color Tokens.colorBackgroundDefault
            , Font.color Tokens.colorText
            , Border.solid
            , Border.width 1
            , Border.color Tokens.colorBorderDefault
            ]


sizeAttrs : Size -> List (Element.Attribute msg)
sizeAttrs size =
    case size of
        Small ->
            [ Element.paddingXY Tokens.spacerSm Tokens.spacerXs
            , Font.size Tokens.fontSizeSm
            ]

        Default ->
            [ Element.paddingXY 16 Tokens.spacerSm
            , Font.size Tokens.fontSizeMd
            ]

        Large ->
            [ Element.paddingXY Tokens.spacerLg 12
            , Font.size Tokens.fontSizeLg
            ]


labelEl : Options msg -> Element msg
labelEl opts =
    let
        textEl =
            Element.text opts.label
    in
    case opts.icon of
        Nothing ->
            textEl

        Just { element, position } ->
            case position of
                Left ->
                    Element.row [ Element.spacing Tokens.spacerXs ]
                        [ element, textEl ]

                Right ->
                    Element.row [ Element.spacing Tokens.spacerXs ]
                        [ textEl, element ]


{-| Render the Button as an `Element msg`
-}
toMarkup : Button msg -> Element msg
toMarkup (Button opts) =
    let
        attrs =
            variantAttrs opts.variant ++ sizeAttrs opts.size
    in
    Input.button attrs
        { label = labelEl opts
        , onPress = opts.onPress
        }
