module Shell exposing (view)

import Element exposing (Element)
import Element.Background as Bg
import Element.Font as Font
import Html.Attributes
import PF6.Masthead as Masthead
import PF6.Tokens as Tokens
import Route exposing (Route)
import Sidebar


type alias Config msg =
    { route : Route
    , componentsExpanded : Bool
    , layoutsExpanded : Bool
    , onToggleComponents : msg
    , onToggleLayouts : msg
    , onNavigate : Route -> msg
    }


view : Config msg -> Element msg -> Element msg
view config content =
    Element.column
        [ Element.width Element.fill
        , Element.height Element.fill
        ]
        [ mastheadView
        , Element.row
            [ Element.width Element.fill
            , Element.height Element.fill
            , Element.htmlAttribute (Html.Attributes.style "min-height" "0")
            ]
            [ Sidebar.view
                { route = config.route
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


mastheadView : Element msg
mastheadView =
    Masthead.masthead
        |> Masthead.withBrand
            (Element.row [ Element.spacing 12 ]
                [ Element.el
                    [ Font.bold
                    , Font.size 18
                    , Font.color Tokens.colorTextOnDark
                    ]
                    (Element.text "PatternFly 6 Quickstart")
                , Element.el
                    [ Font.size 14
                    , Font.color (Element.rgb255 160 160 160)
                    ]
                    (Element.text "elm-ui")
                ]
            )
        |> Masthead.toMarkup
