module Views.TooltipView exposing (view)

import Element exposing (Element)
import Html exposing (Html)
import PF4.Card as Card
import PF4.Info as Info
import PF4.Label as Label
import PF4.Navigation as Navigation
import PF4.Page as Page
import PF4.Title as Title
import PF4.Tooltip as Tooltip
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
    [ Title.title "Tooltip Component"
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
            [ Element.el
                [ Tooltip.tooltip "Example of a tooltip on hover"
                    |> Tooltip.withPositionLeft
                    |> Tooltip.toMarkup
                ]
                (Label.label "Left"
                    |> Label.toMarkup
                )
            , Element.el
                [ Tooltip.tooltip "Example of a tooltip on hover"
                    |> Tooltip.withPositionTop
                    |> Tooltip.toMarkup
                ]
                (Label.label "Top"
                    |> Label.toMarkup
                )
            , Element.el
                [ Tooltip.tooltip "Example of a tooltip on hover"
                    |> Tooltip.withPositionBottom
                    |> Tooltip.toMarkup
                ]
                (Label.label "Bottom"
                    |> Label.toMarkup
                )
            , Element.el
                [ Tooltip.tooltip "Example of a tooltip on hover"
                    |> Tooltip.withPositionRight
                    |> Tooltip.toMarkup
                ]
                (Label.label "Right"
                    |> Label.toMarkup
                )
            ]
            |> Card.withTitle "Tooltip Examples"
            |> Card.toMarkup
        ]
    ]
