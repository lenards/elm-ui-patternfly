module Views.Layout exposing (withShell)

import Element exposing (Element)
import Element.Background as Bg
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import PF6.Tokens as Tokens
import Types exposing (Model, Msg(..), Section(..))


navSections : List ( Section, String )
navSections =
    [ ( Home, "Home" )
    , ( Primitives, "Primitives" )
    , ( Feedback, "Feedback & Status" )
    , ( Forms, "Forms" )
    , ( Navigation, "Navigation" )
    , ( Layout, "Layout" )
    , ( Overlays, "Overlays" )
    , ( Content, "Content" )
    , ( Data, "Data" )
    ]


navItem : Section -> ( Section, String ) -> Element Msg
navItem current ( section, label ) =
    let
        isActive =
            current == section
    in
    Input.button
        [ Element.width Element.fill
        , Element.paddingXY 16 10
        , Font.size 14
        , Font.color
            (if isActive then
                Tokens.colorPrimary

             else
                Tokens.colorText
            )
        , Bg.color
            (if isActive then
                Element.rgb255 215 235 255

             else
                Tokens.colorBackgroundDefault
            )
        , Border.widthEach { top = 0, right = 0, bottom = 0, left = 3 }
        , Border.color
            (if isActive then
                Tokens.colorPrimary

             else
                Element.rgba 0 0 0 0
            )
        ]
        { onPress = Just (NavSelected section)
        , label = Element.text label
        }


sidebar : Model -> Element Msg
sidebar model =
    Element.column
        [ Element.width (Element.px 220)
        , Element.height Element.fill
        , Bg.color Tokens.colorBackgroundDefault
        , Border.widthEach { top = 0, right = 1, bottom = 0, left = 0 }
        , Border.color Tokens.colorBorderDefault
        ]
        (List.map (navItem model.section) navSections)


masthead : Element Msg
masthead =
    Element.row
        [ Element.width Element.fill
        , Bg.color (Element.rgb255 21 21 21)
        , Element.paddingXY 24 12
        , Element.spacing 12
        ]
        [ Element.el
            [ Font.bold
            , Font.size 18
            , Font.color Tokens.colorTextOnDark
            ]
            (Element.text "PatternFly 6")
        , Element.el
            [ Font.size 14
            , Font.color (Element.rgb255 160 160 160)
            ]
            (Element.text "Elm UI Guide")
        ]


withShell : Model -> Element Msg -> Element Msg
withShell model content =
    Element.column
        [ Element.width Element.fill
        , Element.height Element.fill
        ]
        [ masthead
        , Element.row
            [ Element.width Element.fill
            , Element.height Element.fill
            ]
            [ sidebar model
            , Element.el
                [ Element.width Element.fill
                , Element.height Element.fill
                , Bg.color Tokens.colorBackgroundSecondary
                , Element.scrollbarY
                ]
                (Element.column
                    [ Element.width (Element.maximum 960 Element.fill)
                    , Element.padding 32
                    , Element.spacing 32
                    , Element.centerX
                    ]
                    [ content ]
                )
            ]
        ]
