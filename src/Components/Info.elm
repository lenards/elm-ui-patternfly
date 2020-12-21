module Components.Info exposing
    ( info
    , toMarkup
    , withDefaultIcon
    , withTitle
    )

import Element exposing (Element)
import Element.Background as Bg
import Element.Border as Border
import Element.Font as Font
import Element.Region as Region
import Html
import Html.Attributes exposing (style)
import Svg
import Svg.Attributes as SvgAttrs


type Info msg
    = Info (Options msg)


type alias Options msg =
    { title : Maybe String
    , text : String
    , icon : Maybe (Element msg)
    }


defaultIcon : Element msg
defaultIcon =
    Html.div [ style "color" "#2b9af3" ]
        [ Svg.svg
            [ SvgAttrs.fill "currentColor"
            , SvgAttrs.viewBox "0 0 512 512"
            , SvgAttrs.height "1em"
            , SvgAttrs.width "1em"
            ]
            [ Svg.path
                [ SvgAttrs.d
                    (String.concat
                        [ "M256 8C119.043 8 8 119.083 8 256c0 136.997 111.043 248 248 248s248-111.003 "
                        , "248-248C504 119.083 392.957 8 256 8zm0 110c23.196 0 42 18.804 42 42s-18.804 "
                        , "42-42 42-42-18.804-42-42 18.804-42 42-42zm56 254c0 6.627-5.373 12-12 "
                        , "12h-88c-6.627 0-12-5.373-12-12v-24c0-6.627 5.373-12 12-12h12v-64h-12c-6.627 "
                        , "0-12-5.373-12-12v-24c0-6.627 5.373-12 12-12h64c6.627 0 12 5.373 12 "
                        , "12v100h12c6.627 0 12 5.373 12 12v24z"
                        ]
                    )
                ]
                []
            ]
        ]
        |> Element.html


info : String -> Info msg
info text =
    Info
        { title = Nothing
        , text = text
        , icon = Nothing
        }


withTitle : String -> Info msg -> Info msg
withTitle title_ (Info options) =
    Info { options | title = Just title_ }


withDefaultIcon : Info msg -> Info msg
withDefaultIcon (Info options) =
    Info
        { options
            | icon = Just defaultIcon
        }


toMarkup : Info msg -> Element msg
toMarkup (Info options) =
    let
        parentEl =
            case options.icon of
                Just icon ->
                    \attrs child ->
                        Element.el
                            [ Element.width Element.fill
                            , Element.padding 4
                            ]
                            (Element.row attrs
                                [ Element.el
                                    [ Element.width <| Element.px 24
                                    , Element.centerX
                                    , Element.alignTop
                                    , Element.moveDown 15.5
                                    , Element.paddingEach
                                        { top = 0
                                        , right = 0
                                        , bottom = 0
                                        , left = 10
                                        }
                                    ]
                                    icon
                                , child
                                ]
                            )

                Nothing ->
                    \attrs child ->
                        Element.el
                            [ Element.width Element.fill
                            , Element.padding 4
                            ]
                            (Element.el attrs child)

        attrs_ =
            [ Bg.color <| Element.rgb255 231 241 250
            , Border.color <| Element.rgb255 43 154 243
            , Border.solid
            , Border.widthEach
                { top = 2
                , right = 0
                , left = 0
                , bottom = 0
                }
            , Element.paddingEach
                { top = 4
                , right = 0
                , bottom = 4
                , left = 0
                }
            , Element.width Element.fill
            ]

        columnAttrs_ =
            [ Element.padding 16
            , Element.spacingXY 0 4
            , Element.width Element.fill
            , Element.alignLeft
            ]

        titleAttrs_ =
            [ Region.heading 4
            , Font.color <| Element.rgb255 0 41 82
            ]

        contentAttrs_ =
            [ Font.alignLeft ]
    in
    parentEl attrs_ <|
        Element.column columnAttrs_ <|
            [ Element.el titleAttrs_ <|
                Element.text
                    (options.title
                        |> Maybe.withDefault ""
                    )
            , Element.paragraph contentAttrs_ <|
                [ Element.text options.text ]
            ]
