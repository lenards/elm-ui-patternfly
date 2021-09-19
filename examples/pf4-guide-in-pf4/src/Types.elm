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
    }


type Msg
    = NoOp
    | NavSelected String
    | AccordionSelected PF4.Accordion.Msg
    | AccordionMultiSelected PF4.Accordion.Msg
    | RemoveExampleChip
    | RemoveChip String
    | RemoveCategory
    | ToggleExpandableSection
    | SwitchChanged Bool
