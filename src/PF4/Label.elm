module PF4.Label exposing
    ( Label
    , Variant
    , label
    , toMarkup
    , withCloseMsg
    , withFill
    , withHyperlink
    , withIcon
    , withOutline
    )

import Element exposing (Element)
import Element.Background as Bg
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import PF4.Icons as Icons


type Label msg
    = Label (Options msg)


type Variant
    = Outline
    | Fill


type alias Options msg =
    { text : String
    , variant : Variant
    , onClose : Maybe msg
    , href : Maybe String
    , icon : Maybe (Element msg)
    , background : Element.Color
    , foreground : Element.Color
    }


backgroundColor : Element.Color
backgroundColor =
    Element.rgb255 240 240 240


foregroundColor : Element.Color
foregroundColor =
    Element.rgb255 21 21 21


defaultClose : Element msg
defaultClose =
    Icons.close


label : String -> Label msg
label text =
    Label
        { text = text
        , variant = Fill
        , onClose = Nothing
        , href = Nothing
        , icon = Nothing
        , background = backgroundColor
        , foreground = foregroundColor
        }


withOutline : Label msg -> Label msg
withOutline (Label options) =
    Label { options | variant = Outline }


withFill : Label msg -> Label msg
withFill (Label options) =
    Label { options | variant = Fill }


withCloseMsg : msg -> Label msg -> Label msg
withCloseMsg msg (Label options) =
    Label { options | onClose = Just msg }


withHyperlink : String -> Label msg -> Label msg
withHyperlink link (Label options) =
    Label { options | href = Just link }


withIcon : Element msg -> Label msg -> Label msg
withIcon icon (Label options) =
    Label { options | icon = Just icon }


closeEl : msg -> Element msg
closeEl closeMsg =
    Input.button [ Element.moveDown 2.0 ]
        { onPress = Just closeMsg
        , label = defaultClose
        }


iconEl : Element msg -> Element msg
iconEl icon =
    Element.el
        [ Element.paddingEach
            { top = 0
            , right = 4
            , bottom = 0
            , left = 0
            }
        , Element.moveDown 1.3
        ]
        icon


contentEl : Options msg -> (List (Element.Attribute msg) -> Element msg -> Element msg)
contentEl options =
    case ( options.icon, options.onClose ) of
        ( Just icon, Just closeMsg ) ->
            \attrs child ->
                Element.row attrs <|
                    [ iconEl icon
                    , Element.el [] child
                    , closeEl closeMsg
                    ]

        ( Just icon, Nothing ) ->
            \attrs child ->
                Element.row attrs <|
                    [ iconEl icon
                    , Element.el [] child
                    ]

        ( Nothing, Just closeMsg ) ->
            \attrs child ->
                Element.row attrs <|
                    [ Element.el [] child
                    , closeEl closeMsg
                    ]

        ( Nothing, Nothing ) ->
            \attrs child ->
                Element.row attrs <|
                    [ Element.el [] child ]


filterAttr : ( Bool, a ) -> Maybe a
filterAttr ( include, attr ) =
    if include then
        Just attr

    else
        Nothing


toMarkup : Label msg -> Element msg
toMarkup (Label options) =
    let
        parentEl =
            contentEl options

        attrs_ =
            [ ( True, Border.rounded 30 )
            , ( True, Element.paddingXY 8 4 )
            , ( True, Font.color options.foreground )
            , ( options.variant == Fill, Bg.color options.background )
            , ( options.variant == Outline, Border.solid )
            , ( options.variant == Outline, Border.color options.background )
            , ( options.variant == Outline, Border.width 1 )
            ]
                |> List.filterMap filterAttr
    in
    Element.el [] <|
        parentEl attrs_ <|
            Element.text options.text
