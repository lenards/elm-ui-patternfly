module Views.ChipGroupView exposing (view)

import Components.Card as Card
import Components.Chip as Chip
import Components.ChipGroup as ChipGroup
import Components.Info as Info
import Components.Navigation as Navigation
import Components.Page as Page
import Components.Title as Title
import Element
import Html exposing (Html)
import Types exposing (Model, Msg(..))


view : Model -> Html Msg
view model =
    Element.layout [] <|
        Element.column
            [ Element.width Element.fill
            , Element.height Element.fill
            ]
            [ Page.page
                { title = "Components"
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
