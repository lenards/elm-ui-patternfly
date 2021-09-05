module PF4.ChipGroup exposing
    ( ChipGroup, ChipsShown
    , group
    , withCategory, withClickMsg
    , toMarkup
    )

{-| A container component for `PF4.Chip` element(s)


# Definition

@docs ChipGroup, ChipsShown


# Constructor function

@docs group


# Configuration functions

@docs withCategory, withClickMsg


# Rendering element

@docs toMarkup

<https://www.patternfly.org/v4/components/chip-group>

-}

import Element exposing (Element)
import Element.Background as Bg
import Element.Border as Border
import Element.Input as Input
import PF4.Chip as Chip exposing (Chip)
import PF4.Icons as Icons


{-| Opaque `ChipGroup` element that can produce `msg` messages
-}
type ChipGroup msg
    = ChipGroup (Options msg)


{-| Defines how many `Chip`s to show when rendering.
-}
type ChipsShown
    = All
    | Show Int


defaultNumChips : Int
defaultNumChips =
    3


type alias Options msg =
    { chips : List (Chip msg)
    , category : Maybe String
    , numChips : ChipsShown
    , onClick : Maybe msg
    }


expandedText : Int -> String
expandedText remaining =
    String.fromInt remaining
        ++ "more"


defaultClose : Element msg
defaultClose =
    Icons.closeCircle


{-| Constructs a group of `Chip`s creates from the `List String`
-}
group : List String -> (String -> msg) -> ChipGroup msg
group chipList chipClickMsg =
    let
        chips =
            chipList
                |> List.map
                    (\c ->
                        Chip.chip c
                            |> Chip.withCloseMsg (chipClickMsg c)
                    )
    in
    ChipGroup
        { chips = chips
        , category = Nothing
        , numChips = Show defaultNumChips
        , onClick = Nothing
        }


{-| Configures group to have category
-}
withCategory : String -> ChipGroup msg -> ChipGroup msg
withCategory category (ChipGroup options) =
    ChipGroup { options | category = Just category }


{-| Configures what `msg` is produced by group `onClick`
-}
withClickMsg : msg -> ChipGroup msg -> ChipGroup msg
withClickMsg clickMsg (ChipGroup options) =
    ChipGroup { options | onClick = Just clickMsg }


{-| Given the custom type representation, renders as an `Element msg`.
-}
toMarkup : ChipGroup msg -> Element msg
toMarkup (ChipGroup options) =
    let
        parentEl =
            case options.category of
                Just categoryName ->
                    \attrs children ->
                        Element.el [] <|
                            Element.row (attrs ++ categoryAttrs_) <|
                                [ Element.el [] <|
                                    Element.text categoryName
                                , Element.row [] children
                                , Input.button
                                    [ Element.moveDown 2.0 ]
                                    { onPress = options.onClick
                                    , label = defaultClose
                                    }
                                ]

                Nothing ->
                    \attrs children ->
                        Element.el [] <|
                            Element.row attrs children

        categoryAttrs_ =
            [ Bg.color <| Element.rgb255 240 240 240
            , Border.rounded 3
            , Element.paddingEach
                { top = 4
                , right = 4
                , bottom = 4
                , left = 8
                }
            ]

        attrs_ =
            [ Element.spaceEvenly
            , Element.spacing 8
            ]
    in
    parentEl attrs_ <|
        (options.chips
            |> List.map Chip.toMarkup
        )
