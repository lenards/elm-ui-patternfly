module Types exposing (Category, Model, Msg(..))

import PF4.Accordion


type alias Category =
    { name : String
    , items : List String
    }


type alias Model =
    { exampleChip : Maybe String
    , listOfChips : List String
    , category : Maybe Category
    , navItems : List String
    , selectedNav : String
    , accordionState : PF4.Accordion.State
    , accordionMultiState : PF4.Accordion.State
    , sectionExpanded : Bool
    , checked : Bool
    , activeMenuId : String
    , selectedRadio : Maybe String
    }


type Msg
    = NoOp
    | AccordionSelected PF4.Accordion.Msg
    | AccordionMultiSelected PF4.Accordion.Msg
    | LauncherClicked String
    | NavSelected String
    | RadioSelected String
    | RemoveExampleChip
    | RemoveChip String
    | RemoveCategory
    | SwitchChanged Bool
    | ToggleExpandableSection
