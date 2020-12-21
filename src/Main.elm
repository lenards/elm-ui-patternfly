module Main exposing (..)

import Browser
import Components.Chip as Chip
import Components.Info as Info
import Element
import Html exposing (Html)



---- MODEL ----


type alias Model =
    { exampleChip : Maybe String
    , listOfChips : List String
    }


init : ( Model, Cmd Msg )
init =
    ( { exampleChip = Just "New Language"
      , listOfChips = []
      }
    , Cmd.none
    )



---- UPDATE ----


type Msg
    = NoOp
    | RemoveExampleChip


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        RemoveExampleChip ->
            ( { model | exampleChip = Nothing }
            , Cmd.none
            )



---- VIEW ----
{-
   <svg fill="currentColor" height="1em" width="1em" viewBox="0 0 512 512" aria-hidden="true" role="img" style="vertical-align: -0.125em;"><path d="M256 8C119.043 8 8 119.083 8 256c0 136.997 111.043 248 248 248s248-111.003 248-248C504 119.083 392.957 8 256 8zm0 110c23.196 0 42 18.804 42 42s-18.804 42-42 42-42-18.804-42-42 18.804-42 42-42zm56 254c0 6.627-5.373 12-12 12h-88c-6.627 0-12-5.373-12-12v-24c0-6.627 5.373-12 12-12h12v-64h-12c-6.627 0-12-5.373-12-12v-24c0-6.627 5.373-12 12-12h64c6.627 0 12 5.373 12 12v100h12c6.627 0 12 5.373 12 12v24z"></path></svg>
-}


view : Model -> Html Msg
view model =
    Element.layout [] <|
        Element.column
            [ Element.width
                (Element.fill
                    |> Element.maximum 960
                )
            , Element.centerX
            ]
            [ Info.info
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
            , Chip.chip "English"
                |> Chip.toMarkup
            , model.exampleChip
                |> Maybe.map
                    (\c ->
                        Chip.chip c
                            |> Chip.withClickMsg RemoveExampleChip
                            |> Chip.toMarkup
                    )
                |> Maybe.withDefault Element.none
            ]



---- PROGRAM ----


main : Program () Model Msg
main =
    Browser.element
        { view = view
        , init = \_ -> init
        , update = update
        , subscriptions = always Sub.none
        }
