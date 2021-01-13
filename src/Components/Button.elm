module Components.Button exposing (..)

import Components.Icons as Icons
import Element exposing (Element)
import Element.Background as Bg
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import Html.Attributes exposing (style)


type Button msg
    = Button (Options msg)


type Variant
    = Primary
    | Secondary
    | Tertiary
    | Warning
    | Danger
    | Plain
    | Control
    | Link


type Position
    = Left
    | Right


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


button : { label : String, onPress : Maybe msg } -> Button msg
button btn =
    Button (defaultOptions btn)


primary : { label : String, onPress : Maybe msg } -> Button msg
primary btn =
    construct btn withPrimary


secondary : { label : String, onPress : Maybe msg } -> Button msg
secondary btn =
    construct btn withSecondary


tertiary : { label : String, onPress : Maybe msg } -> Button msg
tertiary btn =
    construct btn withTertiary


warning : { label : String, onPress : Maybe msg } -> Button msg
warning btn =
    construct btn withWarning


danger : { label : String, onPress : Maybe msg } -> Button msg
danger btn =
    construct btn withDanger


control : { label : String, onPress : Maybe msg } -> Button msg
control btn =
    construct btn withControl


link : { label : String, onPress : Maybe msg, href : String } -> Button msg
link btn =
    -- need to use `href` in the Options record
    construct { label = btn.label, onPress = btn.onPress } withLink


withPrimary : Options msg -> Button msg
withPrimary opts =
    Button { opts | variant = Primary }


withSecondary : Options msg -> Button msg
withSecondary opts =
    Button { opts | variant = Secondary }


withTertiary : Options msg -> Button msg
withTertiary opts =
    Button { opts | variant = Tertiary }


withWarning : Options msg -> Button msg
withWarning opts =
    Button { opts | variant = Warning }


withDanger : Options msg -> Button msg
withDanger opts =
    Button { opts | variant = Danger }


withControl : Options msg -> Button msg
withControl opts =
    Button { opts | variant = Control }


withLink : Options msg -> Button msg
withLink opts =
    Button { opts | variant = Link }


withLargeSize : Button msg -> Button msg
withLargeSize (Button options) =
    Button { options | size = Large }


withSmallSize : Button msg -> Button msg
withSmallSize (Button options) =
    Button { options | size = Small }


withDefaultSize : Button msg -> Button msg
withDefaultSize (Button options) =
    Button { options | size = Normal }


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


withIconRight : Button msg -> Button msg
withIconRight btn =
    btn |> setIconPosition Right


withIconLeft : Button msg -> Button msg
withIconLeft btn =
    btn |> setIconPosition Left


getAttributesBy : Variant -> List (Element.Attribute msg) -> List (Element.Attribute msg)
getAttributesBy var baseAttrs_ =
    case var of
        Primary ->
            [ Bg.color <| Element.rgb255 0 102 104
            , Font.color <| Element.rgb255 255 255 255
            , Border.rounded 5
            ]
                ++ baseAttrs_

        Secondary ->
            [ Bg.color <| Element.rgb255 255 255 255
            , Font.color <| Element.rgb255 0 102 104
            , Border.color <| Element.rgb255 0 102 104
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
