module Views.AccordionView exposing (view)

import Element exposing (Element)
import Html exposing (Html)
import PF4.Accordion as Accordion
import PF4.Card as Card
import PF4.Info as Info
import PF4.Label as Label
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
    [ Title.title "Accordion Component"
        |> Title.withSize2xl
        |> Title.toMarkup
    , Info.info
        "This Beta component is currently under review, so please join in and give us your feedback on the PatternFly forum."
        |> Info.withTitle "This is a Title"
        |> Info.withDefaultIcon
        |> Info.toMarkup
    , Element.column
        [ Element.paddingXY 2 10
        , Element.spacing 10
        , Element.width (Element.px 960)
        ]
        [ Card.card
            [ Accordion.accordion
                (\accMsg -> AccordionSelected accMsg)
                [ ( "Title 1", Element.el [] (Label.label "Content 1" |> Label.toMarkup) )
                , ( "Title 2", Element.el [] (Label.label "Content 2" |> Label.toMarkup) )
                ]
                |> Accordion.toMarkupFor
                    model.accordionState
            , Label.label "The first stateful PF4 component" |> Label.toMarkup
            ]
            |> Card.withTitle "Basic Accordion Example"
            |> Card.toMarkup
        ]
    , Element.column
        [ Element.paddingXY 2 10
        , Element.spacing 10
        , Element.width (Element.px 960)
        ]
        [ Card.card
            [ Accordion.accordion
                (\accMsg -> AccordionMultiSelected accMsg)
                [ ( "Title 1", Element.el [] (Label.label "Content 1" |> Label.toMarkup) )
                , ( "Title 2", Element.el [] (Label.label "Content 2" |> Label.toMarkup) )
                ]
                |> Accordion.toMarkupFor
                    model.accordionMultiState
            , Label.label "The first stateful PF4 component" |> Label.toMarkup
            ]
            |> Card.withTitle "Accordion Multiple Expanded Example"
            |> Card.toMarkup
        ]
    ]
