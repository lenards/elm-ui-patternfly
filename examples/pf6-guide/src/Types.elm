module Types exposing (Model, Msg(..), Section(..))

import PF6.Theme exposing (Mode(..))


type Section
    = Home
    | Primitives
    | Feedback
    | Forms
    | Navigation
    | Layout
    | Overlays
    | Content
    | Data


type alias Model =
    { section : Section

    -- Primitives state
    , badgeCount : Int

    -- Feedback state
    , progressValue : Float
    , alertVisible : Bool

    -- Forms state
    , textValue : String
    , successValue : String
    , errorValue : String
    , searchValue : String
    , checkboxChecked : Bool
    , radioSelected : Maybe String
    , switchOn : Bool
    , numberValue : Float
    , selectOpen : Bool
    , selectValue : Maybe String

    -- Overlays state
    , modalOpen : Bool
    , dropdownOpen : Bool
    , accordionExpanded : Maybe String
    , sectionExpanded : Bool

    -- Data state
    , tableSort : Maybe { key : String, descending : Bool }
    , dataListChecked : List Int

    -- Drawer state
    , drawerOpen : Bool

    -- Navigation state
    , activeTab : String
    , activeBoxTab : String

    -- New component state
    , textAreaValue : String
    , selectedTile : Maybe String
    , toggleViewMode : String
    , simpleListActive : String
    , notificationExpanded : Bool

    -- New PF6 component state
    , sliderValue : Float
    , wizardStep : Int
    , menuSearchValue : String
    , textInputGroupValue : String
    , backdropVisible : Bool
    , themeMode : Mode
    }


type Msg
    = NoOp
    | NavSelected Section
    | BadgeIncrement
    | BadgeDecrement
    | ProgressSet Float
    | AlertDismiss
    | TextChanged String
    | SuccessTextChanged String
    | ErrorTextChanged String
    | SearchChanged String
    | CheckboxToggled Bool
    | RadioSelected String
    | SwitchToggled Bool
    | NumberChanged Float
    | SelectToggled Bool
    | SelectChosen String
    | ModalOpen
    | ModalClose
    | DropdownToggled Bool
    | AccordionToggled String Bool
    | SectionToggled Bool
    | TableSortBy String
    | DataListCheckToggled Int
    | DrawerToggled Bool
    | TabSelected String
    | BoxTabSelected String
    | CopyText String
      -- New component messages
    | TextAreaChanged String
    | TileSelected String
    | ToggleViewMode String
    | SimpleListSelected String
    | NotificationToggled
    | ScrollToTop
      -- New PF6 component messages
    | SliderChanged Float
    | WizardStepChanged Int
    | WizardNext
    | WizardBack
    | WizardCancel
    | WizardFinish
    | MenuSearchChanged String
    | TextInputGroupChanged String
    | BackdropToggled Bool
    | MenuItemClicked String
    | ToggleTheme
