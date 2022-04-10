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
import Views.AccordionView as AccordionView
import Views.BadgeView as BadgeView
import Views.ButtonView as ButtonView
import Views.ChipGroupView as ChipGroupView
import Views.ChipView as ChipView
import Views.CreatedView as CreatedView
import Views.ExpandableSectionView as ExpandableSectionView
import Views.HomeView as HomeView
import Views.InfoView as InfoView
import Views.LabelView as LabelView
import Views.SwitchView as SwitchView
import Views.TitleView as TitleView
import Views.TooltipView as TooltipView



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
            [ "Home"
            , "Accordion"
            , "Badge"
            , "Button"
            , "Chip"
            , "ChipGroup"
            , "Created"
            , "ExpandableSection"
            , "Icons"
            , "Info"
            , "Label"
            , "Navigation"
            , "Switch"
            , "Title"
            , "Tooltip"
            ]
      , selectedNav = "Home"
      , accordionState = Accordion.singleExpandState
      , accordionMultiState = Accordion.multipleExpandState
      , sectionExpanded = False
      , checked = True
      , activeMenuId = ""
      , selectedRadio = Nothing
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

        RadioSelected option ->
            ( { model | selectedRadio = Just option }
            , Cmd.none
            )



---- VIEW ----


view : Model -> Html Msg
view model =
    case model.selectedNav of
        "Home" ->
            HomeView.view model

        "Accordion" ->
            AccordionView.view model

        "Badge" ->
            BadgeView.view model

        "Button" ->
            ButtonView.view model

        "Chip" ->
            ChipView.view model

        "ChipGroup" ->
            ChipGroupView.view model

        "Created" ->
            CreatedView.view model

        "ExpandableSection" ->
            ExpandableSectionView.view model

        "Info" ->
            InfoView.view model

        "Label" ->
            LabelView.view model

        "Switch" ->
            SwitchView.view model

        "Title" ->
            TitleView.view model

        "Tooltip" ->
            TooltipView.view model

        _ ->
            -- this is horrible, don't `case` on strings
            HomeView.view model



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
