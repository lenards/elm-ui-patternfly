module Views.ChipGroupView exposing (view)

import Element
import Html exposing (Html)
import PF4.Card as Card
import PF4.Chip as Chip
import PF4.ChipGroup as ChipGroup
import PF4.Info as Info
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
                    [ Title.title "ChipGroup Component"
                        |> Title.withSize2xl
                        |> Title.toMarkup
                    , Info.info
                        "This Beta component is currently under review, so please join in and give us your feedback on the PatternFly forum."
                        |> Info.withTitle "This is a Title"
                        |> Info.withDefaultIcon
                        |> Info.toMarkup
                    , Element.row [ Element.paddingXY 0 10, Element.spacing 10 ] <|
                        [ Card.card
                            [ ChipGroup.group model.listOfChips RemoveChip
                                |> ChipGroup.toMarkup
                            , model.category
                                |> Maybe.map
                                    (\c ->
                                        ChipGroup.group c.items (\_ -> NoOp)
                                            |> ChipGroup.withCategory c.name
                                            |> ChipGroup.withClickMsg RemoveCategory
                                            |> ChipGroup.toMarkup
                                    )
                                |> Maybe.withDefault Element.none
                            ]
                            |> Card.withTitle "ChipGroup Examples"
                            |> Card.toMarkup
                        ]
                    ]
                }
                |> Page.toMarkup
            ]
