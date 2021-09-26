module Main exposing (..)

import Browser
import Element exposing (Element)
import Html exposing (Html)
import PF4.Accordion as Accordion
import PF4.ApplicationLauncher as AppLauncher
import PF4.Button as Button
import PF4.Card as Card
import PF4.Created as Created
import PF4.ExpandableSection as ExpandableSection
import PF4.Icons as Icons
import PF4.Info as Info
import PF4.Label as Label
import PF4.Menu as Menu
import PF4.Navigation as Navigation exposing (Navigation)
import PF4.Page as Page
import PF4.Switch as Switch
import PF4.Title as Title
import PF4.Tooltip as Tooltip
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
      , accordionState = Accordion.singleExpandState
      , accordionMultiState = Accordion.multipleExpandState
      , sectionExpanded = False
      , checked = True
      , activeMenuId = ""
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

        AccordionSelected accordionMsg ->
            ( { model
                | accordionState =
                    Accordion.update
                        accordionMsg
                        model.accordionState
              }
            , Cmd.none
            )

        AccordionMultiSelected accordionMsg ->
            ( { model
                | accordionMultiState =
                    Accordion.update
                        accordionMsg
                        model.accordionMultiState
              }
            , Cmd.none
            )

        ToggleExpandableSection ->
            ( { model | sectionExpanded = not model.sectionExpanded }
            , Cmd.none
            )

        SwitchChanged checked ->
            ( { model | checked = checked }
            , Cmd.none
            )

        LauncherClicked menuId ->
            let
                nextMenuId =
                    if model.activeMenuId == menuId then
                        ""

                    else
                        menuId
            in
            ( { model | activeMenuId = nextMenuId }
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
                , body = body model
                }
                |> Page.toMarkup
            ]


body : Model -> List (Element Msg)
body model =
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
            , Button.primary
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
            , Created.created
                { createdOn = Time.millisToPosix 1609468521866
                , now = Time.millisToPosix 1609468694666
                }
                |> Created.toMarkup
            ]
            |> Card.withTitle "Tooltip Examples"
            |> Card.toMarkup
        ]
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
            |> Card.withTitle "Accordion Example"
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
    , Element.column
        [ Element.paddingXY 2 10
        , Element.spacing 10
        , Element.width (Element.px 960)
        ]
        [ Card.card
            [ ExpandableSection.expandableSection
                { text = "Click me ..."
                , content = Element.el [] (Label.label "Expanded Content" |> Label.toMarkup)
                , onPress = Just ToggleExpandableSection
                }
                |> (\es ->
                        if model.sectionExpanded then
                            ExpandableSection.expandSection es

                        else
                            ExpandableSection.collapseSection es
                   )
                |> ExpandableSection.toMarkup
            ]
            |> Card.withTitle "ExpandableSection Example"
            |> Card.toMarkup
        ]
    , Element.column
        [ Element.paddingXY 2 10
        , Element.spacing 10
        , Element.width (Element.px 960)
        ]
        [ Card.card
            [ AppLauncher.applicationLauncher
                { id = "menu-id__lolz"
                , items =
                    [ { itemId = "instances_id", label = "instances" }
                    , { itemId = "volumes_id", label = "volumes" }
                    , { itemId = "images_id", label = "images" }
                    ]
                , onItemSelect = \_ -> NoOp
                , onClick = LauncherClicked "menu-id__lolz"
                }
                |> AppLauncher.withActiveMenu model.activeMenuId
                |> AppLauncher.toMarkup
            ]
            |> Card.withTitle "Menu Example - sort of ..."
            |> Card.withBodyPaddingEach
                { top = 10
                , right = 0
                , bottom = 10
                , left = 0
                }
            |> Card.toMarkup
        ]
    , Element.column
        [ Element.paddingXY 2 10
        , Element.spacing 10
        , Element.width (Element.px 960)
        ]
        [ Card.card
            [ Switch.switch
                { checked = model.checked
                , onText = "Text that you say when 'on'"
                , offText = "Text that you say when 'off'"
                , onChange = SwitchChanged
                }
                |> Switch.toMarkup
            ]
            |> Card.withTitle "Switch Example"
            |> Card.withBodyPaddingEach
                { top = 10
                , right = 0
                , bottom = 45
                , left = 0
                }
            |> Card.toMarkup
        ]
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
