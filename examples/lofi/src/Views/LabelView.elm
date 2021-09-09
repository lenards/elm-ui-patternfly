module Views.LabelView exposing (view)

import Element
import Html exposing (Html)
import PF4.Card as Card
import PF4.Icons as Icons
import PF4.Info as Info
import PF4.Label as Label
import PF4.Navigation as Navigation
import PF4.Page as Page
import PF4.Title as Title
import Types exposing (Model, Msg(..))


view : Model -> Html Msg
view model =
    Element.layout [] <|
        Element.column
            [ Element.width Element.fill
            , Element.height Element.fill
            ]
            [ Page.page
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
                , body =
                    [ Title.title "Chip Component"
                        |> Title.withSize2xl
                        |> Title.toMarkup
                    , Info.info
                        "This Beta component is currently under review, so please join in and give us your feedback on the PatternFly forum."
                        |> Info.withTitle "This is a Title"
                        |> Info.withDefaultIcon
                        |> Info.toMarkup
                    , Element.row [ Element.paddingXY 0 10, Element.spacing 10 ] <|
                        [ Card.card
                            [ Label.label "Grey" |> Label.toMarkup
                            , Label.label "Grey"
                                |> Label.withCloseMsg NoOp
                                |> Label.toMarkup
                            , Label.label "Grey"
                                |> Label.withIcon (Icons.infoRgb255 21 21 21)
                                |> Label.withCloseMsg NoOp
                                |> Label.toMarkup
                            , Label.label "Grey"
                                |> Label.withOutline
                                |> Label.toMarkup
                            , Label.label "Grey"
                                |> Label.withOutline
                                |> Label.withCloseMsg NoOp
                                |> Label.toMarkup
                            , Label.label "Grey"
                                |> Label.withOutline
                                |> Label.withIcon (Icons.infoRgb255 21 21 21)
                                |> Label.withCloseMsg NoOp
                                |> Label.toMarkup
                            ]
                            |> Card.withTitle "Label Examples"
                            |> Card.toMarkup
                        ]
                    ]
                }
                |> Page.toMarkup
            ]
