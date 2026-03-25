module PF6.DualListSelector exposing
    ( DualListSelector, Item
    , dualListSelector
    , withAvailableItems
    , withChosenItems
    , withAvailableTitle
    , withChosenTitle
    , withOnAdd
    , withOnRemove
    , withOnAddAll
    , withOnRemoveAll
    , withFilterText
    , toMarkup
    )

{-| PF6 DualListSelector component

Two-panel component for moving items between an "available" list and a "chosen"
list. The consumer manages the item lists and filtering; clicking an item in
the available panel calls `withOnAdd`, clicking in chosen calls `withOnRemove`.

See: <https://www.patternfly.org/components/dual-list-selector>


# Definition

@docs DualListSelector, Item


# Constructor

@docs dualListSelector


# Item modifiers

@docs withAvailableItems, withChosenItems


# Label modifiers

@docs withAvailableTitle, withChosenTitle


# Event modifiers

@docs withOnAdd, withOnRemove, withOnAddAll, withOnRemoveAll


# Filter modifiers

@docs withFilterText


# Rendering

@docs toMarkup

-}

import Element exposing (Element)
import Element.Background as Bg
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import Html.Attributes
import PF6.Theme as Theme exposing (Theme)
import PF6.Tokens as Tokens


{-| A selectable item with a unique id and display label
-}
type alias Item =
    { id : String
    , label : String
    }


{-| Opaque DualListSelector type
-}
type DualListSelector msg
    = DualListSelector (Options msg)


type alias Options msg =
    { available : List Item
    , chosen : List Item
    , availableTitle : String
    , chosenTitle : String
    , filterText : String
    , onAdd : Maybe (String -> msg)
    , onRemove : Maybe (String -> msg)
    , onAddAll : Maybe msg
    , onRemoveAll : Maybe msg
    }


{-| Construct an empty DualListSelector
-}
dualListSelector : DualListSelector msg
dualListSelector =
    DualListSelector
        { available = []
        , chosen = []
        , availableTitle = "Available"
        , chosenTitle = "Chosen"
        , filterText = ""
        , onAdd = Nothing
        , onRemove = Nothing
        , onAddAll = Nothing
        , onRemoveAll = Nothing
        }


{-| Set the list of available (left panel) items
-}
withAvailableItems : List Item -> DualListSelector msg -> DualListSelector msg
withAvailableItems items (DualListSelector opts) =
    DualListSelector { opts | available = items }


{-| Set the list of chosen (right panel) items
-}
withChosenItems : List Item -> DualListSelector msg -> DualListSelector msg
withChosenItems items (DualListSelector opts) =
    DualListSelector { opts | chosen = items }


{-| Set the label for the available (left) panel
-}
withAvailableTitle : String -> DualListSelector msg -> DualListSelector msg
withAvailableTitle title (DualListSelector opts) =
    DualListSelector { opts | availableTitle = title }


{-| Set the label for the chosen (right) panel
-}
withChosenTitle : String -> DualListSelector msg -> DualListSelector msg
withChosenTitle title (DualListSelector opts) =
    DualListSelector { opts | chosenTitle = title }


{-| Set the message sent with item id when an available item is clicked (adds it)
-}
withOnAdd : (String -> msg) -> DualListSelector msg -> DualListSelector msg
withOnAdd f (DualListSelector opts) =
    DualListSelector { opts | onAdd = Just f }


{-| Set the message sent with item id when a chosen item is clicked (removes it)
-}
withOnRemove : (String -> msg) -> DualListSelector msg -> DualListSelector msg
withOnRemove f (DualListSelector opts) =
    DualListSelector { opts | onRemove = Just f }


{-| Set the message sent when "Add all" is clicked
-}
withOnAddAll : msg -> DualListSelector msg -> DualListSelector msg
withOnAddAll msg (DualListSelector opts) =
    DualListSelector { opts | onAddAll = Just msg }


{-| Set the message sent when "Remove all" is clicked
-}
withOnRemoveAll : msg -> DualListSelector msg -> DualListSelector msg
withOnRemoveAll msg (DualListSelector opts) =
    DualListSelector { opts | onRemoveAll = Just msg }


{-| Filter text applied to item labels in both panels
-}
withFilterText : String -> DualListSelector msg -> DualListSelector msg
withFilterText text (DualListSelector opts) =
    DualListSelector { opts | filterText = text }


filterItems : String -> List Item -> List Item
filterItems filterText items =
    if String.isEmpty filterText then
        items

    else
        List.filter
            (\item -> String.contains (String.toLower filterText) (String.toLower item.label))
            items


renderPanel : Theme -> String -> List Item -> Maybe (String -> msg) -> String -> Element msg
renderPanel theme title items onClickItem emptyText =
    let
        panelHeader =
            Element.el
                [ Font.bold
                , Font.size Tokens.fontSizeMd
                , Font.color (Theme.text theme)
                , Element.paddingEach { top = 0, right = 0, bottom = Tokens.spacerSm, left = 0 }
                ]
                (Element.text (title ++ " (" ++ String.fromInt (List.length items) ++ ")"))

        itemEl item =
            Input.button
                [ Element.width Element.fill
                , Element.paddingXY Tokens.spacerSm Tokens.spacerXs
                , Border.rounded Tokens.radiusSm
                , Element.mouseOver [ Bg.color (Theme.backgroundSecondary theme) ]
                ]
                { onPress = onClickItem |> Maybe.map (\f -> f item.id)
                , label =
                    Element.el
                        [ Font.size Tokens.fontSizeMd
                        , Font.color (Theme.text theme)
                        ]
                        (Element.text item.label)
                }

        listEl =
            if List.isEmpty items then
                Element.el
                    [ Element.width Element.fill
                    , Element.padding Tokens.spacerMd
                    , Font.color (Theme.textSubtle theme)
                    , Font.size Tokens.fontSizeMd
                    ]
                    (Element.text emptyText)

            else
                Element.column
                    [ Element.width Element.fill
                    , Element.spacing 0
                    ]
                    (List.map itemEl items)
    in
    Element.column
        [ Element.width (Element.fillPortion 1)
        , Element.height Element.fill
        , Bg.color (Theme.backgroundDefault theme)
        , Border.solid
        , Border.width 1
        , Border.color (Theme.borderDefault theme)
        , Border.rounded Tokens.radiusMd
        , Element.padding Tokens.spacerMd
        ]
        [ panelHeader
        , Element.el
            [ Element.width Element.fill
            , Element.height Element.fill
            , Element.scrollbarY
            , Element.htmlAttribute (Html.Attributes.style "min-height" "0")
            ]
            listEl
        ]


{-| Render the DualListSelector as an `Element msg`
-}
toMarkup : Theme -> DualListSelector msg -> Element msg
toMarkup theme (DualListSelector opts) =
    let
        filteredAvailable =
            filterItems opts.filterText opts.available

        filteredChosen =
            filterItems opts.filterText opts.chosen

        controlBtn label pressMsg =
            Input.button
                [ Bg.color (Theme.backgroundSecondary theme)
                , Border.rounded Tokens.radiusMd
                , Border.solid
                , Border.width 1
                , Border.color (Theme.borderDefault theme)
                , Element.paddingXY Tokens.spacerSm Tokens.spacerXs
                , Font.size Tokens.fontSizeSm
                , Font.color (Theme.text theme)
                ]
                { onPress = pressMsg
                , label = Element.text label
                }

        controls =
            Element.column
                [ Element.spacing Tokens.spacerSm
                , Element.centerY
                , Element.paddingXY Tokens.spacerSm 0
                ]
                [ controlBtn "Add all »" opts.onAddAll
                , controlBtn "« Remove all" opts.onRemoveAll
                ]
    in
    Element.row
        [ Element.width Element.fill
        , Element.height (Element.px 300)
        , Element.spacing 0
        ]
        [ renderPanel theme opts.availableTitle filteredAvailable opts.onAdd "No available items"
        , controls
        , renderPanel theme opts.chosenTitle filteredChosen opts.onRemove "No items chosen"
        ]
