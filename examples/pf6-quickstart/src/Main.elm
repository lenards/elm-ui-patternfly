port module Main exposing (main)

import Browser
import Browser.Navigation as Nav
import Element
import PF6.Theme as Theme exposing (Mode(..), Theme)
import Pages.AccordionPage as AccordionPage
import Pages.ActionListPage as ActionListPage
import Pages.AlertPage as AlertPage
import Pages.AvatarPage as AvatarPage
import Pages.BackToTopPage as BackToTopPage
import Pages.BackdropPage as BackdropPage
import Pages.BadgePage as BadgePage
import Pages.BannerPage as BannerPage
import Pages.BrandPage as BrandPage
import Pages.BreadcrumbPage as BreadcrumbPage
import Pages.BullseyePage as BullseyePage
import Pages.ButtonPage as ButtonPage
import Pages.CardPage as CardPage
import Pages.CheckboxPage as CheckboxPage
import Pages.ClipboardCopyPage as ClipboardCopyPage
import Pages.CodeBlockPage as CodeBlockPage
import Pages.DataListPage as DataListPage
import Pages.DescriptionListPage as DescriptionListPage
import Pages.DividerPage as DividerPage
import Pages.DrawerPage as DrawerPage
import Pages.DropdownPage as DropdownPage
import Pages.EmptyStatePage as EmptyStatePage
import Pages.ExpandableSectionPage as ExpandableSectionPage
import Pages.FlexPage as FlexPage
import Pages.FormPage as FormPage
import Pages.GalleryPage as GalleryPage
import Pages.GridPage as GridPage
import Pages.HelperTextPage as HelperTextPage
import Pages.HintPage as HintPage
import Pages.Home as Home
import Pages.IconPage as IconPage
import Pages.InputGroupPage as InputGroupPage
import Pages.JumpLinksPage as JumpLinksPage
import Pages.LabelPage as LabelPage
import Pages.LevelPage as LevelPage
import Pages.ListPage as ListPage
import Pages.MastheadPage as MastheadPage
import Pages.MenuPage as MenuPage
import Pages.ModalPage as ModalPage
import Pages.NotificationBadgePage as NotificationBadgePage
import Pages.NotificationDrawerPage as NotificationDrawerPage
import Pages.NumberInputPage as NumberInputPage
import Pages.PageLayoutPage as PageLayoutPage
import Pages.PaginationPage as PaginationPage
import Pages.PanelPage as PanelPage
import Pages.PopoverPage as PopoverPage
import Pages.ProgressPage as ProgressPage
import Pages.ProgressStepperPage as ProgressStepperPage
import Pages.RadioPage as RadioPage
import Pages.SearchInputPage as SearchInputPage
import Pages.SelectPage as SelectPage
import Pages.SidebarLayoutPage as SidebarLayoutPage
import Pages.SimpleListPage as SimpleListPage
import Pages.SkeletonPage as SkeletonPage
import Pages.SkipToContentPage as SkipToContentPage
import Pages.SliderPage as SliderPage
import Pages.SpinnerPage as SpinnerPage
import Pages.SplitPage as SplitPage
import Pages.StackPage as StackPage
import Pages.SwitchPage as SwitchPage
import Pages.TablePage as TablePage
import Pages.TabsPage as TabsPage
import Pages.TextAreaPage as TextAreaPage
import Pages.TextInputGroupPage as TextInputGroupPage
import Pages.TextInputPage as TextInputPage
import Pages.TilePage as TilePage
import Pages.TimestampPage as TimestampPage
import Pages.TitlePage as TitlePage
import Pages.ToggleGroupPage as ToggleGroupPage
import Pages.ToolbarPage as ToolbarPage
import Pages.TooltipPage as TooltipPage
import Pages.TruncatePage as TruncatePage
import Pages.WizardPage as WizardPage
import Route exposing (Route(..))
import Shell
import Url exposing (Url)


type alias Model =
    { route : Route
    , key : Nav.Key
    , themeMode : Mode
    , componentsExpanded : Bool
    , layoutsExpanded : Bool
    , modalOpen : Bool
    , accordionExpanded : Maybe String
    , tabsActive : String
    , dropdownOpen : Bool
    , progressValue : Float
    , formText : String
    , checkboxChecked : Bool
    , drawerExpanded : Bool
    , expandableSectionExpanded : Bool
    , numberValue : Float
    , paginationPage : Int
    , popoverVisible : Bool
    , selectedRadio : String
    , searchValue : String
    , selectOpen : Bool
    , selectValue : Maybe String
    , sliderValue : Float
    , switchChecked : Bool
    , textAreaValue : String
    , textInputValue : String
    , textInputGroupValue : String
    , toggleGroupSelected : String
    , wizardStep : Int
    }


port copyToClipboard : String -> Cmd msg


type Msg
    = NoOp
    | CopyText String
    | UrlRequested Browser.UrlRequest
    | UrlChanged Url
    | NavigateTo Route
    | ToggleTheme
    | ToggleComponents
    | ToggleLayouts
    | ModalOpen
    | ModalClose
    | AccordionToggled String Bool
    | TabSelected String
    | DropdownToggled Bool
    | FormTextChanged String
    | CheckboxToggled Bool
    | DrawerToggled
    | ExpandableSectionToggled Bool
    | NumberValueChanged Float
    | PaginationPageChanged Int
    | PopoverToggled
    | PopoverClosed
    | RadioSelected String
    | SearchValueChanged String
    | SearchCleared
    | SelectToggled Bool
    | SelectChanged String
    | SliderChanged Float
    | SwitchToggled Bool
    | TextAreaChanged String
    | TextInputChanged String
    | TextInputGroupChanged String
    | ToggleGroupSelected String
    | WizardStepChanged Int
    | WizardNext
    | WizardBack


init : () -> Url -> Nav.Key -> ( Model, Cmd Msg )
init _ url key =
    ( { route = Route.routeFromUrl url
      , key = key
      , themeMode = Light
      , componentsExpanded = True
      , layoutsExpanded = False
      , modalOpen = False
      , accordionExpanded = Nothing
      , tabsActive = "tab1"
      , dropdownOpen = False
      , progressValue = 60
      , formText = ""
      , checkboxChecked = False
      , drawerExpanded = False
      , expandableSectionExpanded = False
      , numberValue = 1
      , paginationPage = 1
      , popoverVisible = False
      , selectedRadio = "option1"
      , searchValue = ""
      , selectOpen = False
      , selectValue = Nothing
      , sliderValue = 50
      , switchChecked = False
      , textAreaValue = ""
      , textInputValue = ""
      , textInputGroupValue = ""
      , toggleGroupSelected = "month"
      , wizardStep = 0
      }
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        CopyText text ->
            ( model, copyToClipboard text )

        UrlRequested request ->
            case request of
                Browser.Internal url ->
                    ( model, Nav.pushUrl model.key (Url.toString url) )

                Browser.External href ->
                    ( model, Nav.load href )

        UrlChanged url ->
            ( { model | route = Route.routeFromUrl url }, Cmd.none )

        NavigateTo route ->
            ( model
            , Nav.pushUrl model.key ("#" ++ Route.routeToFragment route)
            )

        ToggleTheme ->
            ( { model
                | themeMode =
                    case model.themeMode of
                        Light ->
                            Dark

                        Dark ->
                            Light
              }
            , Cmd.none
            )

        ToggleComponents ->
            ( { model | componentsExpanded = not model.componentsExpanded }, Cmd.none )

        ToggleLayouts ->
            ( { model | layoutsExpanded = not model.layoutsExpanded }, Cmd.none )

        ModalOpen ->
            ( { model | modalOpen = True }, Cmd.none )

        ModalClose ->
            ( { model | modalOpen = False }, Cmd.none )

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

        TabSelected key ->
            ( { model | tabsActive = key }, Cmd.none )

        DropdownToggled open ->
            ( { model | dropdownOpen = open }, Cmd.none )

        FormTextChanged value ->
            ( { model | formText = value }, Cmd.none )

        CheckboxToggled checked ->
            ( { model | checkboxChecked = checked }, Cmd.none )

        DrawerToggled ->
            ( { model | drawerExpanded = not model.drawerExpanded }, Cmd.none )

        ExpandableSectionToggled expanded ->
            ( { model | expandableSectionExpanded = expanded }, Cmd.none )

        NumberValueChanged value ->
            ( { model | numberValue = value }, Cmd.none )

        PaginationPageChanged page ->
            ( { model | paginationPage = page }, Cmd.none )

        PopoverToggled ->
            ( { model | popoverVisible = not model.popoverVisible }, Cmd.none )

        PopoverClosed ->
            ( { model | popoverVisible = False }, Cmd.none )

        RadioSelected value ->
            ( { model | selectedRadio = value }, Cmd.none )

        SearchValueChanged value ->
            ( { model | searchValue = value }, Cmd.none )

        SearchCleared ->
            ( { model | searchValue = "" }, Cmd.none )

        SelectToggled open ->
            ( { model | selectOpen = open }, Cmd.none )

        SelectChanged value ->
            ( { model | selectValue = Just value, selectOpen = False }, Cmd.none )

        SliderChanged value ->
            ( { model | sliderValue = value }, Cmd.none )

        SwitchToggled checked ->
            ( { model | switchChecked = checked }, Cmd.none )

        TextAreaChanged value ->
            ( { model | textAreaValue = value }, Cmd.none )

        TextInputChanged value ->
            ( { model | textInputValue = value }, Cmd.none )

        TextInputGroupChanged value ->
            ( { model | textInputGroupValue = value }, Cmd.none )

        ToggleGroupSelected value ->
            ( { model | toggleGroupSelected = value }, Cmd.none )

        WizardStepChanged step ->
            ( { model | wizardStep = step }, Cmd.none )

        WizardNext ->
            ( { model | wizardStep = min 2 (model.wizardStep + 1) }, Cmd.none )

        WizardBack ->
            ( { model | wizardStep = max 0 (model.wizardStep - 1) }, Cmd.none )


view : Model -> Browser.Document Msg
view model =
    let
        theme =
            Theme.fromMode model.themeMode

        pageContent =
            case model.route of
                Home ->
                    Home.view theme

                AccordionRoute ->
                    AccordionPage.view theme
                        { expanded = model.accordionExpanded
                        , onToggle = AccordionToggled
                        }

                ActionListRoute ->
                    ActionListPage.view theme NoOp

                AlertRoute ->
                    AlertPage.view theme NoOp

                AvatarRoute ->
                    AvatarPage.view theme

                BackdropRoute ->
                    BackdropPage.view theme

                BackToTopRoute ->
                    BackToTopPage.view theme NoOp

                BadgeRoute ->
                    BadgePage.view theme

                BannerRoute ->
                    BannerPage.view theme

                BrandRoute ->
                    BrandPage.view theme

                BreadcrumbRoute ->
                    BreadcrumbPage.view theme

                ButtonRoute ->
                    ButtonPage.view theme NoOp

                CardRoute ->
                    CardPage.view theme

                CheckboxRoute ->
                    CheckboxPage.view theme
                        { checkboxChecked = model.checkboxChecked
                        , onCheckboxToggle = CheckboxToggled
                        }

                ClipboardCopyRoute ->
                    ClipboardCopyPage.view theme CopyText

                CodeBlockRoute ->
                    CodeBlockPage.view theme

                DataListRoute ->
                    DataListPage.view theme

                DescriptionListRoute ->
                    DescriptionListPage.view theme

                DividerRoute ->
                    DividerPage.view theme

                DrawerRoute ->
                    DrawerPage.view theme
                        { drawerExpanded = model.drawerExpanded
                        , onToggle = DrawerToggled
                        }

                DropdownRoute ->
                    DropdownPage.view theme
                        { dropdownOpen = model.dropdownOpen
                        , onToggle = DropdownToggled
                        , noOp = NoOp
                        }

                EmptyStateRoute ->
                    EmptyStatePage.view theme NoOp

                ExpandableSectionRoute ->
                    ExpandableSectionPage.view theme
                        { expanded = model.expandableSectionExpanded
                        , onToggle = ExpandableSectionToggled
                        }

                FormRoute ->
                    FormPage.view theme
                        { formText = model.formText
                        , onTextChange = FormTextChanged
                        , checkboxChecked = model.checkboxChecked
                        , onCheckboxToggle = CheckboxToggled
                        }

                HelperTextRoute ->
                    HelperTextPage.view theme

                HintRoute ->
                    HintPage.view theme

                IconRoute ->
                    IconPage.view theme

                InputGroupRoute ->
                    InputGroupPage.view theme

                JumpLinksRoute ->
                    JumpLinksPage.view theme

                LabelRoute ->
                    LabelPage.view theme

                ListRoute ->
                    ListPage.view theme

                MastheadRoute ->
                    MastheadPage.view theme

                MenuRoute ->
                    MenuPage.view theme NoOp

                ModalRoute ->
                    ModalPage.view theme
                        { modalOpen = model.modalOpen
                        , onOpen = ModalOpen
                        , onClose = ModalClose
                        }

                NotificationBadgeRoute ->
                    NotificationBadgePage.view theme NoOp

                NotificationDrawerRoute ->
                    NotificationDrawerPage.view theme NoOp

                NumberInputRoute ->
                    NumberInputPage.view theme
                        { numberValue = model.numberValue
                        , onNumberChange = NumberValueChanged
                        }

                PageRoute ->
                    PageLayoutPage.view theme

                PaginationRoute ->
                    PaginationPage.view theme
                        { page = model.paginationPage
                        , onPageChange = PaginationPageChanged
                        }

                PanelRoute ->
                    PanelPage.view theme

                PopoverRoute ->
                    PopoverPage.view theme
                        { popoverVisible = model.popoverVisible
                        , onToggle = \_ -> PopoverToggled
                        , onClose = PopoverClosed
                        }

                ProgressRoute ->
                    ProgressPage.view theme model.progressValue

                ProgressStepperRoute ->
                    ProgressStepperPage.view theme

                RadioRoute ->
                    RadioPage.view theme
                        { selectedRadio = model.selectedRadio
                        , onRadioChange = RadioSelected
                        }

                SearchInputRoute ->
                    SearchInputPage.view theme
                        { searchValue = model.searchValue
                        , onSearchChange = SearchValueChanged
                        , onSearchClear = SearchCleared
                        }

                SelectRoute ->
                    SelectPage.view theme
                        { selectOpen = model.selectOpen
                        , selectValue = model.selectValue
                        , onSelectToggle = SelectToggled
                        , onSelectChange = SelectChanged
                        }

                SimpleListRoute ->
                    SimpleListPage.view theme NoOp

                SkeletonRoute ->
                    SkeletonPage.view theme

                SkipToContentRoute ->
                    SkipToContentPage.view theme

                SliderRoute ->
                    SliderPage.view theme
                        { sliderValue = model.sliderValue
                        , onSliderChange = SliderChanged
                        }

                SpinnerRoute ->
                    SpinnerPage.view theme

                SwitchRoute ->
                    SwitchPage.view theme
                        { switchChecked = model.switchChecked
                        , onSwitchToggle = SwitchToggled
                        }

                TableRoute ->
                    TablePage.view theme

                TabsRoute ->
                    TabsPage.view theme
                        { activeTab = model.tabsActive
                        , onTabSelect = TabSelected
                        }

                TextAreaRoute ->
                    TextAreaPage.view theme
                        { textAreaValue = model.textAreaValue
                        , onTextAreaChange = TextAreaChanged
                        }

                TextInputRoute ->
                    TextInputPage.view theme
                        { textInputValue = model.textInputValue
                        , onTextInputChange = TextInputChanged
                        }

                TextInputGroupRoute ->
                    TextInputGroupPage.view theme
                        { value = model.textInputGroupValue
                        , onChange = TextInputGroupChanged
                        }

                TileRoute ->
                    TilePage.view theme NoOp

                TimestampRoute ->
                    TimestampPage.view theme

                TitleRoute ->
                    TitlePage.view theme

                ToggleGroupRoute ->
                    ToggleGroupPage.view theme
                        { selected = model.toggleGroupSelected
                        , onSelect = ToggleGroupSelected
                        }

                ToolbarRoute ->
                    ToolbarPage.view theme NoOp

                TooltipRoute ->
                    TooltipPage.view theme NoOp

                TruncateRoute ->
                    TruncatePage.view theme

                WizardRoute ->
                    WizardPage.view theme
                        { wizardStep = model.wizardStep
                        , onWizardStepChange = WizardStepChanged
                        , onNext = WizardNext
                        , onBack = WizardBack
                        }

                BullseyeRoute ->
                    BullseyePage.view theme

                FlexRoute ->
                    FlexPage.view theme

                GalleryRoute ->
                    GalleryPage.view theme

                GridRoute ->
                    GridPage.view theme

                LevelRoute ->
                    LevelPage.view theme

                SidebarLayoutRoute ->
                    SidebarLayoutPage.view theme

                SplitRoute ->
                    SplitPage.view theme

                StackRoute ->
                    StackPage.view theme

                NotFound ->
                    Element.text "Page not found"
    in
    { title = Route.routeToTitle model.route ++ " — PF6 Quickstart"
    , body =
        [ Element.layout
            [ Element.width Element.fill
            , Element.height Element.fill
            ]
            (Shell.view
                { route = model.route
                , theme = theme
                , componentsExpanded = model.componentsExpanded
                , layoutsExpanded = model.layoutsExpanded
                , onToggleComponents = ToggleComponents
                , onToggleLayouts = ToggleLayouts
                , onNavigate = NavigateTo
                , onToggleTheme = ToggleTheme
                , themeMode = model.themeMode
                }
                pageContent
            )
        ]
    }


main : Program () Model Msg
main =
    Browser.application
        { init = init
        , update = update
        , view = view
        , subscriptions = \_ -> Sub.none
        , onUrlRequest = UrlRequested
        , onUrlChange = UrlChanged
        }
