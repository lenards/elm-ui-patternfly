module Views.Layout exposing (withShell)

import Element exposing (Element)
import Element.Background as Bg
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import Html.Attributes
import PF6.Theme as Theme exposing (Mode(..), Theme)
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


navItem : Theme -> Section -> ( Section, String ) -> Element Msg
navItem theme current ( section, label ) =
    let
        isActive =
            current == section

        primaryRgb =
            Element.toRgb (Theme.primary theme)

        activeBg =
            if isActive then
                Element.rgba255
                    (primaryRgb.red * 255 |> round)
                    (primaryRgb.green * 255 |> round)
                    (primaryRgb.blue * 255 |> round)
                    0.12

            else
                Theme.backgroundDefault theme
    in
    Input.button
        [ Element.width Element.fill
        , Element.paddingXY 16 10
        , Font.size 14
        , Font.color
            (if isActive then
                Theme.primary theme

             else
                Theme.text theme
            )
        , Bg.color activeBg
        , Border.widthEach { top = 0, right = 0, bottom = 0, left = 3 }
        , Border.color
            (if isActive then
                Theme.primary theme

             else
                Element.rgba 0 0 0 0
            )
        ]
        { onPress = Just (NavSelected section)
        , label = Element.text label
        }


sidebar : Theme -> Model -> Element Msg
sidebar theme model =
    Element.column
        [ Element.width (Element.px 220)
        , Element.height Element.fill
        , Bg.color (Theme.backgroundDefault theme)
        , Border.widthEach { top = 0, right = 1, bottom = 0, left = 0 }
        , Border.color (Theme.borderDefault theme)
        ]
        (List.map (navItem theme model.section) navSections)


masthead : Model -> Element Msg
masthead model =
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
            , Element.width Element.fill
            ]
            (Element.text "Elm UI Guide")
        , Input.button
            [ Font.color Tokens.colorTextOnDark
            , Element.padding 8
            , Font.size 18
            ]
            { onPress = Just ToggleTheme
            , label =
                Element.text
                    (if model.themeMode == Light then
                        "☾"

                     else
                        "☀"
                    )
            }
        ]


withShell : Model -> Element Msg -> Element Msg
withShell model content =
    let
        theme =
            Theme.fromMode model.themeMode
    in
    Element.column
        [ Element.width Element.fill
        , Element.height Element.fill
        ]
        [ masthead model
        , Element.row
            [ Element.width Element.fill
            , Element.height Element.fill
            , Element.htmlAttribute (Html.Attributes.style "min-height" "0")
            ]
            [ sidebar theme model
            , Element.el
                [ Element.width Element.fill
                , Element.height Element.fill
                , Element.htmlAttribute (Html.Attributes.style "min-height" "0")
                , Bg.color (Theme.backgroundSecondary theme)
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
