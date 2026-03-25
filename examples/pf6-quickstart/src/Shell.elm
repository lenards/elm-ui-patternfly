module Shell exposing (view)

import Element exposing (Element)
import Element.Background as Bg
import Element.Font as Font
import Element.Input as Input
import Html.Attributes
import PF6.Masthead as Masthead
import PF6.Theme as Theme exposing (Mode(..), Theme)
import Route exposing (Route)
import Sidebar


type alias Config msg =
    { route : Route
    , theme : Theme
    , componentsExpanded : Bool
    , layoutsExpanded : Bool
    , onToggleComponents : msg
    , onToggleLayouts : msg
    , onNavigate : Route -> msg
    , onToggleTheme : msg
    , themeMode : Mode
    }


view : Config msg -> Element msg -> Element msg
view config content =
    Element.column
        [ Element.width Element.fill
        , Element.height Element.fill
        ]
        [ mastheadView config.theme config.onToggleTheme config.themeMode
        , Element.row
            [ Element.width Element.fill
            , Element.height Element.fill
            , Element.htmlAttribute (Html.Attributes.style "min-height" "0")
            ]
            [ Sidebar.view
                { route = config.route
                , theme = config.theme
                , componentsExpanded = config.componentsExpanded
                , layoutsExpanded = config.layoutsExpanded
                , onToggleComponents = config.onToggleComponents
                , onToggleLayouts = config.onToggleLayouts
                , onNavigate = config.onNavigate
                }
            , Element.el
                [ Element.width Element.fill
                , Element.height Element.fill
                , Element.htmlAttribute (Html.Attributes.style "min-height" "0")
                , Bg.color (Theme.backgroundSecondary config.theme)
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


mastheadView : Theme -> msg -> Mode -> Element msg
mastheadView theme onToggleTheme themeMode =
    Masthead.masthead
        |> Masthead.withBrand
            (Element.row [ Element.spacing 12 ]
                [ Element.el
                    [ Font.bold
                    , Font.size 18
                    , Font.color (Theme.textOnDark theme)
                    ]
                    (Element.text "PatternFly 6 Quickstart")
                , Element.el
                    [ Font.size 14
                    , Font.color (Element.rgb255 160 160 160)
                    ]
                    (Element.text "elm-ui")
                ]
            )
        |> Masthead.withToolbar
            (Input.button
                [ Font.size 13
                , Font.color (Theme.textOnDark theme)
                , Element.paddingXY 12 6
                ]
                { onPress = Just onToggleTheme
                , label =
                    Element.text
                        (case themeMode of
                            Light ->
                                "Dark mode"

                            Dark ->
                                "Light mode"
                        )
                }
            )
        |> Masthead.toMarkup theme
