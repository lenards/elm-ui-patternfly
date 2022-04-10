module Views.ButtonView exposing (view)

import Element exposing (Element)
import Html exposing (Html)
import PF4.Button as Button
import PF4.Card as Card
import PF4.Info as Info
import PF4.Navigation as Navigation
import PF4.Page as Page
import PF4.Title as Title
import Types exposing (Model, Msg(..))
import Views.Layout exposing (layout)


view : Model -> Html Msg
view model =
    layout <|
        Page.page
            { title = "PF4 Components"
            , nav =
                model.navItems
                    |> List.map
                        (\item ->
                            ( item, NavSelected item )
                        )
                    |> Navigation.nav
                    |> Navigation.withSelectedItem
                        model.selectedNav
            , body = body model
            }


body model =
    [ Title.title "Button Component"
        |> Title.withSize2xl
        |> Title.toMarkup
    , Info.info
        "This Beta component is currently under review, so please join in and give us your feedback on the PatternFly forum."
        |> Info.withTitle "This is a Title"
        |> Info.withDefaultIcon
        |> Info.toMarkup
    , Element.row
        [ Element.paddingXY 2 10
        , Element.spacing 10
        ]
        [ Card.card
            [ Button.primary
                { label = "Example"
                , onPress = Nothing
                }
                |> Button.toMarkup
            , Button.secondary
                { label = "Example"
                , onPress = Nothing
                }
                |> Button.toMarkup
            , Button.control
                { label = "Example"
                , onPress = Nothing
                }
                |> Button.toMarkup
            ]
            |> Card.withTitle "Button Examples"
            |> Card.toMarkup
        ]
    ]
