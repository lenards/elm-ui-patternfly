module PF4.Button exposing
    ( Button, Position, Size, Variant
    , button, primary, secondary, tertiary, warning, danger, control, link
    , withDefaultSize, withLargeSize, withSmallSize
    , withIcon, withIconLeft, withIconRight
    , toMarkup
    )

{-| A button component with variation forms


# Definition

@docs Button, Position, Size, Variant


# Constructor functions

@docs button, primary, secondary, tertiary, warning, danger, control, link


# Configuration, sizing, functions

@docs withDefaultSize, withLargeSize, withSmallSize


# Icon functions

@docs withIcon, withIconLeft, withIconRight


# Rendering element

@docs toMarkup

-}

import Element exposing (Element)
import Element.Background as Bg
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import Html.Attributes exposing (style)


{-| Opaque `Button` element that can produce `msg` messages
-}
type Button msg
    = Button (Options msg)


{-| Opaque `Variant` custom type that has 8 variants

`Primary`, `Secondary`, `Tertiary`, `Warning`, `Danger`, `Plain` (default), `Control`, `Link`.

There is a constructor function for each.

Note: the `button` constructs a `Plain` variant.

-}
type Variant
    = Primary
    | Secondary
    | Tertiary
    | Warning
    | Danger
    | Plain
    | Control
    | Link


{-| Opaque `Position` custom type that has 2 variants

`Left`, `Right`

-}
type Position
    = Left
    | Right


{-| An opaque `Size` custom type that has 3 variants

`Normal`, `Large`, `Small`

-}
type Size
    = Normal
    | Small
    | Large


type alias IconElement msg =
    { element : Element msg
    , position : Position
    }


type alias Options msg =
    { label : String
    , icon : Maybe (IconElement msg)
    , onPress : Maybe msg
    , variant : Variant
    , isInline : Bool
    , isDisabled : Bool
    , isBlock : Bool
    , size : Size
    }


defaultOptions : { label : String, onPress : Maybe msg } -> Options msg
defaultOptions { label, onPress } =
    { label = label
    , onPress = onPress
    , icon = Nothing
    , variant = Plain
    , isInline = False
    , isDisabled = False
    , isBlock = False
    , size = Normal
    }


construct :
    { label : String, onPress : Maybe msg }
    -> (Options msg -> Button msg)
    -> Button msg
construct btn withVariantF =
    defaultOptions btn
        |> withVariantF


{-| Configures a `Button` with default appearance
-}
button : { label : String, onPress : Maybe msg } -> Button msg
button btn =
    Button (defaultOptions btn)


{-| Configures appearance of `Button` to be the `Primary` variant
-}
primary : { label : String, onPress : Maybe msg } -> Button msg
primary btn =
    construct btn withPrimary


{-| Configures appearance of `Button` to be the `Secondary` variant
-}
secondary : { label : String, onPress : Maybe msg } -> Button msg
secondary btn =
    construct btn withSecondary


{-| Configures appearance of `Button` to be the `Tertiary` variant

For designs that happen to have 3 overall button styles.

-}
tertiary : { label : String, onPress : Maybe msg } -> Button msg
tertiary btn =
    construct btn withTertiary


{-| Configures appearance of `Button` to be the `Warning` variant
-}
warning : { label : String, onPress : Maybe msg } -> Button msg
warning btn =
    construct btn withWarning


{-| Configures appearance of `Button` to be the `Danger` variant
-}
danger : { label : String, onPress : Maybe msg } -> Button msg
danger btn =
    construct btn withDanger


{-| Configures appearance of `Button` to be the `Control` variant
-}
control : { label : String, onPress : Maybe msg } -> Button msg
control btn =
    construct btn withControl


{-| Constructs a `Link` variant `Button`

Has additional required argument of `href` to be used for the hyperlink.

-}
link : { label : String, onPress : Maybe msg, href : String } -> Button msg
link btn =
    -- need to use `href` in the Options record
    construct { label = btn.label, onPress = btn.onPress } withLink


{-| Configures appearance of `Button` to be the `Primary` variant
-}
withPrimary : Options msg -> Button msg
withPrimary opts =
    Button { opts | variant = Primary }


{-| Configures appearance of `Button` to be the `Secondary` variant
-}
withSecondary : Options msg -> Button msg
withSecondary opts =
    Button { opts | variant = Secondary }


{-| Configures appearance of `Button` to be the `Tertiary` variant
-}
withTertiary : Options msg -> Button msg
withTertiary opts =
    Button { opts | variant = Tertiary }


{-| Configures appearance of `Button` to be the `Warnig` variant
-}
withWarning : Options msg -> Button msg
withWarning opts =
    Button { opts | variant = Warning }


{-| Configures appearance of `Button` to be the `Danger` variant
-}
withDanger : Options msg -> Button msg
withDanger opts =
    Button { opts | variant = Danger }


{-| Configures appearance of `Button` to be the `Control` variant
-}
withControl : Options msg -> Button msg
withControl opts =
    Button { opts | variant = Control }


{-| Configures appearance of `Button` to be the `Link` variant
-}
withLink : Options msg -> Button msg
withLink opts =
    Button { opts | variant = Link }


{-| Configures size to be `Larger`
-}
withLargeSize : Button msg -> Button msg
withLargeSize (Button options) =
    Button { options | size = Large }


{-| Configures size to be `Small`
-}
withSmallSize : Button msg -> Button msg
withSmallSize (Button options) =
    Button { options | size = Small }


{-| Configures size to be `Normal`

`Normal` is the default value for button size.

-}
withDefaultSize : Button msg -> Button msg
withDefaultSize (Button options) =
    Button { options | size = Normal }


{-| Configures the button to have an `Icon`

By default, the position is left of the text

-}
withIcon : Element msg -> Button msg -> Button msg
withIcon icon (Button options) =
    Button
        { options
            | icon =
                Just
                    { element = icon
                    , position = Left
                    }
        }


setIconPosition : Position -> Button msg -> Button msg
setIconPosition pos (Button options) =
    let
        updated =
            options.icon
                |> Maybe.map
                    (\el ->
                        Just { el | position = pos }
                    )
                |> Maybe.withDefault
                    options.icon
    in
    Button { options | icon = updated }


{-| Configure the position of the icon to be right of the text
-}
withIconRight : Button msg -> Button msg
withIconRight btn =
    btn |> setIconPosition Right


{-| Configure the position of the icon to be left of the text
-}
withIconLeft : Button msg -> Button msg
withIconLeft btn =
    btn |> setIconPosition Left


getAttributesBy : Variant -> List (Element.Attribute msg) -> List (Element.Attribute msg)
getAttributesBy var baseAttrs_ =
    case var of
        Primary ->
            [ Bg.color <| Element.rgb255 0 102 204
            , Font.color <| Element.rgb255 255 255 255
            , Border.rounded 5
            ]
                ++ baseAttrs_

        Secondary ->
            [ Bg.color <| Element.rgb255 255 255 255
            , Font.color <| Element.rgb255 0 102 204
            , Border.color <| Element.rgb255 0 102 204
            , Border.rounded 5
            , Border.solid
            , Border.width 1
            ]
                ++ baseAttrs_

        Tertiary ->
            [ Bg.color <| Element.rgb255 255 255 255
            , Font.color <| Element.rgb255 21 21 21
            , Border.color <| Element.rgb255 21 21 21
            , Border.rounded 5
            , Border.solid
            , Border.width 1
            ]
                ++ baseAttrs_

        Warning ->
            [ Bg.color <| Element.rgb255 240 171 0
            , Font.color <| Element.rgb255 21 21 21
            , Border.rounded 5
            ]
                ++ baseAttrs_

        Danger ->
            [ Bg.color <| Element.rgb255 201 25 11
            , Font.color <| Element.rgb255 255 255 255
            , Border.rounded 5
            ]
                ++ baseAttrs_

        Plain ->
            [] ++ baseAttrs_

        Control ->
            [ Border.solid
            , Border.color <| Element.rgb255 240 240 240
            , Border.width 1
            , Element.htmlAttribute
                (style "border-bottom" "1px solid rgb(21,21,21)")
            ]
                ++ baseAttrs_

        Link ->
            [] ++ baseAttrs_


{-| Given the custom type representation, renders as an `Element msg`.
-}
toMarkup : Button msg -> Element msg
toMarkup (Button options) =
    let
        baseAttrs =
            [ Element.paddingXY 12 8 ]

        attrs_ =
            getAttributesBy options.variant baseAttrs
    in
    Input.button attrs_ <|
        { label = Element.text options.label
        , onPress = options.onPress
        }
