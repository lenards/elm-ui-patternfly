module Types exposing (Category, Model, Msg(..))


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
    }


type Msg
    = NoOp
    | NavSelected String
    | RemoveExampleChip
    | RemoveChip String
    | RemoveCategory
