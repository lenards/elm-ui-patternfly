port module Main exposing (main)

import Browser
import Element
import PF6.Theme exposing (Mode(..))
import Types exposing (Model, Msg(..), Section(..))
import Views.ContentView as ContentView
import Views.DataView as DataView
import Views.FeedbackView as FeedbackView
import Views.FormsView as FormsView
import Views.HomeView as HomeView
import Views.Layout as Layout
import Views.LayoutView as LayoutView
import Views.NavigationView as NavigationView
import Views.OverlaysView as OverlaysView
import Views.PrimitivesView as PrimitivesView


init : () -> ( Model, Cmd Msg )
init _ =
    ( { section = Home
      , badgeCount = 3
      , progressValue = 60
      , alertVisible = True
      , textValue = ""
      , successValue = ""
      , errorValue = ""
      , searchValue = ""
      , checkboxChecked = False
      , radioSelected = Nothing
      , switchOn = False
      , numberValue = 0
      , selectOpen = False
      , selectValue = Nothing
      , modalOpen = False
      , dropdownOpen = False
      , accordionExpanded = Nothing
      , sectionExpanded = False
      , tableSort = Nothing
      , dataListChecked = []
      , drawerOpen = False
      , activeTab = "tab1"
      , activeBoxTab = "tab1"
      , textAreaValue = ""
      , selectedTile = Nothing
      , toggleViewMode = "grid"
      , simpleListActive = "item1"
      , notificationExpanded = False
      , sliderValue = 50
      , wizardStep = 0
      , menuSearchValue = ""
      , textInputGroupValue = ""
      , backdropVisible = False
      , themeMode = Light
      , toastVisible = False
      , datePickerYear = 2026
      , datePickerMonth = 3
      , datePickerSelected = Nothing
      , treeExpanded = []
      , treeSelected = Nothing
      , dualAvailable =
            [ { id = "a", label = "Option Alpha" }
            , { id = "b", label = "Option Beta" }
            , { id = "c", label = "Option Gamma" }
            , { id = "d", label = "Option Delta" }
            , { id = "e", label = "Option Epsilon" }
            ]
      , dualChosen = []
      , uploadFileName = Nothing
      , uploadDragOver = False
      , inlineValue = "Click the pencil to edit this text"
      , inlineEditing = False
      , loginUsername = ""
      , loginPassword = ""
      , loginShowPassword = False
      }
    , Cmd.none
    )


port copyToClipboard : String -> Cmd msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        NavSelected section ->
            ( { model | section = section }, Cmd.none )

        BadgeIncrement ->
            ( { model | badgeCount = model.badgeCount + 1 }, Cmd.none )

        BadgeDecrement ->
            ( { model | badgeCount = max 0 (model.badgeCount - 1) }, Cmd.none )

        ProgressSet value ->
            ( { model | progressValue = value }, Cmd.none )

        AlertDismiss ->
            ( { model | alertVisible = False }, Cmd.none )

        TextChanged value ->
            ( { model | textValue = value }, Cmd.none )

        SuccessTextChanged value ->
            ( { model | successValue = value }, Cmd.none )

        ErrorTextChanged value ->
            ( { model | errorValue = value }, Cmd.none )

        SearchChanged value ->
            ( { model | searchValue = value }, Cmd.none )

        CheckboxToggled checked ->
            ( { model | checkboxChecked = checked }, Cmd.none )

        RadioSelected value ->
            ( { model | radioSelected = Just value }, Cmd.none )

        SwitchToggled on ->
            ( { model | switchOn = on }, Cmd.none )

        NumberChanged value ->
            ( { model | numberValue = value }, Cmd.none )

        SelectToggled open ->
            ( { model | selectOpen = open }, Cmd.none )

        SelectChosen value ->
            ( { model | selectValue = Just value, selectOpen = False }, Cmd.none )

        ModalOpen ->
            ( { model | modalOpen = True }, Cmd.none )

        ModalClose ->
            ( { model | modalOpen = False }, Cmd.none )

        DropdownToggled open ->
            ( { model | dropdownOpen = open }, Cmd.none )

        AccordionToggled id open ->
            ( { model
                | accordionExpanded =
                    if open then
                        Just id

                    else
                        Nothing
              }
            , Cmd.none
            )

        SectionToggled open ->
            ( { model | sectionExpanded = open }, Cmd.none )

        TableSortBy key ->
            let
                newSort =
                    case model.tableSort of
                        Just s ->
                            if s.key == key then
                                Just { key = key, descending = not s.descending }

                            else
                                Just { key = key, descending = False }

                        Nothing ->
                            Just { key = key, descending = False }
            in
            ( { model | tableSort = newSort }, Cmd.none )

        DataListCheckToggled index ->
            let
                newChecked =
                    if List.member index model.dataListChecked then
                        List.filter (\i -> i /= index) model.dataListChecked

                    else
                        index :: model.dataListChecked
            in
            ( { model | dataListChecked = newChecked }, Cmd.none )

        DrawerToggled open ->
            ( { model | drawerOpen = open }, Cmd.none )

        TabSelected key ->
            ( { model | activeTab = key }, Cmd.none )

        BoxTabSelected key ->
            ( { model | activeBoxTab = key }, Cmd.none )

        CopyText text ->
            ( model, copyToClipboard text )

        TextAreaChanged value ->
            ( { model | textAreaValue = value }, Cmd.none )

        TileSelected value ->
            ( { model | selectedTile = Just value }, Cmd.none )

        ToggleViewMode mode ->
            ( { model | toggleViewMode = mode }, Cmd.none )

        SimpleListSelected item ->
            ( { model | simpleListActive = item }, Cmd.none )

        NotificationToggled ->
            ( { model | notificationExpanded = not model.notificationExpanded }, Cmd.none )

        ScrollToTop ->
            ( model, Cmd.none )

        SliderChanged value ->
            ( { model | sliderValue = value }, Cmd.none )

        WizardStepChanged step ->
            ( { model | wizardStep = step }, Cmd.none )

        WizardNext ->
            ( { model | wizardStep = min 2 (model.wizardStep + 1) }, Cmd.none )

        WizardBack ->
            ( { model | wizardStep = max 0 (model.wizardStep - 1) }, Cmd.none )

        WizardCancel ->
            ( { model | wizardStep = 0 }, Cmd.none )

        WizardFinish ->
            ( { model | wizardStep = 0 }, Cmd.none )

        MenuSearchChanged value ->
            ( { model | menuSearchValue = value }, Cmd.none )

        TextInputGroupChanged value ->
            ( { model | textInputGroupValue = value }, Cmd.none )

        BackdropToggled visible ->
            ( { model | backdropVisible = visible }, Cmd.none )

        MenuItemClicked _ ->
            ( model, Cmd.none )

        ToggleTheme ->
            ( { model
                | themeMode =
                    if model.themeMode == Light then
                        Dark

                    else
                        Light
              }
            , Cmd.none
            )

        ToastShow ->
            ( { model | toastVisible = True }, Cmd.none )

        ToastDismiss ->
            ( { model | toastVisible = False }, Cmd.none )

        DatePickerPrev ->
            let
                ( newYear, newMonth ) =
                    if model.datePickerMonth == 1 then
                        ( model.datePickerYear - 1, 12 )

                    else
                        ( model.datePickerYear, model.datePickerMonth - 1 )
            in
            ( { model | datePickerYear = newYear, datePickerMonth = newMonth }, Cmd.none )

        DatePickerNext ->
            let
                ( newYear, newMonth ) =
                    if model.datePickerMonth == 12 then
                        ( model.datePickerYear + 1, 1 )

                    else
                        ( model.datePickerYear, model.datePickerMonth + 1 )
            in
            ( { model | datePickerYear = newYear, datePickerMonth = newMonth }, Cmd.none )

        DatePickerSelect date ->
            ( { model | datePickerSelected = Just date }, Cmd.none )

        TreeToggle id ->
            ( { model
                | treeExpanded =
                    if List.member id model.treeExpanded then
                        List.filter (\x -> x /= id) model.treeExpanded

                    else
                        id :: model.treeExpanded
              }
            , Cmd.none
            )

        TreeSelect id ->
            ( { model | treeSelected = Just id }, Cmd.none )

        DualAdd id ->
            let
                item =
                    List.filter (\i -> i.id == id) model.dualAvailable
            in
            ( { model
                | dualAvailable = List.filter (\i -> i.id /= id) model.dualAvailable
                , dualChosen = model.dualChosen ++ item
              }
            , Cmd.none
            )

        DualRemove id ->
            let
                item =
                    List.filter (\i -> i.id == id) model.dualChosen
            in
            ( { model
                | dualChosen = List.filter (\i -> i.id /= id) model.dualChosen
                , dualAvailable = model.dualAvailable ++ item
              }
            , Cmd.none
            )

        DualAddAll ->
            ( { model
                | dualChosen = model.dualChosen ++ model.dualAvailable
                , dualAvailable = []
              }
            , Cmd.none
            )

        DualRemoveAll ->
            ( { model
                | dualAvailable = model.dualAvailable ++ model.dualChosen
                , dualChosen = []
              }
            , Cmd.none
            )

        UploadDragOver dragging ->
            ( { model | uploadDragOver = dragging }, Cmd.none )

        UploadClear ->
            ( { model | uploadFileName = Nothing }, Cmd.none )

        InlineEditStart ->
            ( { model | inlineEditing = True }, Cmd.none )

        InlineEditChange val ->
            ( { model | inlineValue = val }, Cmd.none )

        InlineEditSave ->
            ( { model | inlineEditing = False }, Cmd.none )

        InlineEditCancel ->
            ( { model | inlineEditing = False }, Cmd.none )

        LoginUsernameChanged val ->
            ( { model | loginUsername = val }, Cmd.none )

        LoginPasswordChanged val ->
            ( { model | loginPassword = val }, Cmd.none )

        LoginShowPasswordToggled ->
            ( { model | loginShowPassword = not model.loginShowPassword }, Cmd.none )

        LoginSubmit ->
            ( model, Cmd.none )


view : Model -> Browser.Document Msg
view model =
    let
        content =
            case model.section of
                Home ->
                    HomeView.view model

                Primitives ->
                    PrimitivesView.view model

                Feedback ->
                    FeedbackView.view model

                Forms ->
                    FormsView.view model

                Navigation ->
                    NavigationView.view model

                Layout ->
                    LayoutView.view model

                Overlays ->
                    OverlaysView.view model

                Content ->
                    ContentView.view model

                Data ->
                    DataView.view model
    in
    { title = "PatternFly 6 — Elm UI Guide"
    , body =
        [ Element.layout
            [ Element.width Element.fill
            , Element.height Element.fill
            ]
            (Layout.withShell model content)
        ]
    }


main : Program () Model Msg
main =
    Browser.document
        { init = init
        , update = update
        , view = view
        , subscriptions = \_ -> Sub.none
        }
