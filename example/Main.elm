module Main exposing (..)

import Browser
import PF4.Button as Button
import PF4.Card as Card
import PF4.Created as Created
import PF4.Info as Info
import PF4.Label as Label
import PF4.Navigation as Navigation exposing (Navigation)
import PF4.Page as Page
import PF4.Title as Title
import PF4.Tooltip as Tooltip
import Element
import Html exposing (Html)
import Time
import Types exposing (Model, Msg(..))



---- MODEL ----


init : ( Model, Cmd Msg )
init =
    ( { exampleChip = Just "New Language"
      , listOfChips = [ "English", "Spanish", "Hindi" ]
      , category =
            Just <|
                { name = "Languages"
                , items = [ "English", "Spanish", "Hindi" ]
                }
      , navItems =
            [ "Badge"
            , "Chip"
            , "ChipGroup"
            , "Icons"
            , "Info"
            , "Label"
            , "Navigation"
            , "Title"
            , "Tooltip"
            ]
      , selectedNav = "Badge"
      }
    , Cmd.none
    )



---- UPDATE ----


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        RemoveExampleChip ->
            ( { model | exampleChip = Nothing }
            , Cmd.none
            )

        RemoveChip name ->
            ( { model
                | listOfChips =
                    model.listOfChips
                        |> List.filter (\c -> name /= c)
              }
            , Cmd.none
            )

        RemoveCategory ->
            ( { model | category = Nothing }
            , Cmd.none
            )

        NavSelected itemName ->
            ( { model | selectedNav = itemName }
            , Cmd.none
            )



---- VIEW ----


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
                    [ Title.title "Kitchen Sink of PF4 Components"
                        |> Title.withSize2xl
                        |> Title.toMarkup
                    , Info.info
                        "This Beta component is currently under review, so please join in and give us your feedback on the PatternFly forum."
                        |> Info.withTitle "This is a Title"
                        |> Info.withDefaultIcon
                        |> Info.toMarkup
                    , Info.info
                        "This Beta component is currently under review, so please join in and give us your feedback on the PatternFly forum."
                        |> Info.withTitle "This is a Title"
                        |> Info.toMarkup
                    , Info.info
                        "This Beta component is currently under review, so please join in and give us your feedback on the PatternFly forum."
                        |> Info.toMarkup
                    , Element.row
                        [ Element.paddingXY 0 10
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
                            , Created.created
                                { createdOn = Time.millisToPosix 1609468521866
                                , now = Time.millisToPosix 1609468694666
                                }
                                |> Created.toMarkup
                            ]
                            |> Card.withTitle "Tooltip Examples"
                            |> Card.toMarkup
                        ]
                    ]
                }
                |> Page.toMarkup
            ]



{-
   Element.row []
       [ Element.el
           [ Bg.color <| Element.rgb255 21 21 21
           , Element.width <| Element.px 20
           , Element.height <| Element.px 20
           , Element.htmlAttribute
               (style
                   "transform"
                   "translateX(-50%) translateY(50%) rotate(45deg)"
               )
           ]
           Element.none
       ]
-}
---- PROGRAM ----


main : Program () Model Msg
main =
    Browser.element
        { view = view
        , init = \_ -> init
        , update = update
        , subscriptions = always Sub.none
        }
