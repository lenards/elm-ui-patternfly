module Main exposing (..)

import Browser
import Components.Badge as Badge
import Components.Card as Card
import Components.Chip as Chip
import Components.ChipGroup as ChipGroup
import Components.Icons as Icons
import Components.Info as Info
import Components.Label as Label
import Components.Page as Page
import Components.Title as Title
import Components.Tooltip as Tooltip
import Element
import Html exposing (Html)



---- MODEL ----


type alias Category =
    { name : String
    , items : List String
    }


type alias Model =
    { exampleChip : Maybe String
    , listOfChips : List String
    , category : Maybe Category
    }


init : ( Model, Cmd Msg )
init =
    ( { exampleChip = Just "New Language"
      , listOfChips = [ "English", "Spanish", "Hindi" ]
      , category =
            Just <|
                { name = "Languages"
                , items = [ "English", "Spanish", "Hindi" ]
                }
      }
    , Cmd.none
    )



---- UPDATE ----


type Msg
    = NoOp
    | RemoveExampleChip
    | RemoveChip String
    | RemoveCategory


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



---- VIEW ----


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
                    [ ( "Badge", NoOp )
                    , ( "Chip", NoOp )
                    , ( "ChipGroup", NoOp )
                    , ( "Icons", NoOp )
                    , ( "Info", NoOp )
                    , ( "Label", NoOp )
                    , ( "Navigation", NoOp )
                    , ( "Title", NoOp )
                    , ( "Tooltip", NoOp )
                    ]
                , body =
                    [ Title.title "Kitchen Sink of Components"
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
                    , Element.column [ Element.paddingXY 0 10, Element.spacing 20 ] <|
                        [ Chip.chip "English"
                            |> Chip.toMarkup
                        , model.exampleChip
                            |> Maybe.map
                                (\c ->
                                    Chip.chip c
                                        |> Chip.withCloseMsg RemoveExampleChip
                                        |> Chip.toMarkup
                                )
                            |> Maybe.withDefault Element.none
                        , ChipGroup.group model.listOfChips RemoveChip
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
                    , Element.row [ Element.paddingXY 0 10, Element.spacing 10 ] <|
                        [ Badge.badge 88 |> Badge.toMarkup
                        , Badge.unreadBadge 12 |> Badge.toMarkup
                        , Badge.badge 650 |> Badge.toMarkup
                        , Badge.badge 1000 |> Badge.toMarkup
                        ]
                    , Element.row
                        [ Element.paddingXY 0 10
                        , Element.spacing 10
                        , Tooltip.tooltip "Example of a tooltip on hover"
                            |> Tooltip.withPositionLeft
                            |> Tooltip.toMarkup
                        ]
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
