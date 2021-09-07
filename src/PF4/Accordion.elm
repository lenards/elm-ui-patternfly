module PF4.Accordion exposing
    ( Accordion, AccordionItem
    , accordion, accordionItem, defaultState, singleExpandState, multipleExpandState
    , State, Msg, update
    , toMarkupFor
    )

{-| An expandable component that fills the role of an accordian


# Definition

@docs Accordion, AccordionItem


# Constructor functions

@docs accordion, accordionItem, defaultState, singleExpandState, multipleExpandState


# Handling lifecycle of element

@docs State, Msg, update


# Rendering stateful element

@docs toMarkupFor

<https://www.patternfly.org/v4/components/accordion>

-}

import Dict exposing (Dict)
import Element exposing (Element)
import Element.Events as Events
import Murmur3
import PF4.Icons as Icons


{-| Opaque `Accordion` element that can produce `msg` messages
-}
type Accordion msg
    = Accordion (Options msg)


{-| Internal Accordion.Msg type for handling statefulness
-}
type Msg
    = Pressed String


{-| Opaque `State` representation of the `Accordion`.

To create a `State`, use one of the provided

-}
type alias State =
    Behavior


{-| Size

Current, Size is only defined as `Default`. Eventually there
will be `Default` and `Large` variants for `Size`.

-}
type Size
    = Default


type alias ItemId =
    String


type alias SelectedIds =
    Dict ItemId ItemId


type Behavior
    = SingleExpand ExpandState
    | MultipleExpand ExpandState


type ExpandState
    = None
    | Expanded SelectedIds


type alias Options msg =
    { bordered : Bool
    , size : Size
    , msgMapper : Msg -> msg
    , children : AccordionItems msg
    }


{-| -}
type alias AccordionItems msg =
    { behavior : Behavior
    , items : Dict String ( Int, AccordionItem msg )
    }


{-| Opaque `AccordionItem` element that can produce `msg` messages
-}
type AccordionItem msg
    = AccordionItem (ItemOptions msg)


{-| Compromises the options for the child item of an accordian

In the reference implementation of PatternFly 4 (PF4), the "item"
appears to be a wrapping container around a pair of elements:
a "toggle" & a "content". For the now, the implementation in elm-ui
we're flattening this into an item until there is a robust reason
to have it split into the two elements.

-}
type alias ItemOptions msg =
    { itemId : ItemId
    , title : String
    , content : Element msg
    , onPress : Msg
    }


{-| Constructs a default state with the default behavior

The default behavior is "Single Expand".

Only a single accordion can be open at a given time.

-}
defaultState : State
defaultState =
    singleExpandState


{-| Constructs a state with behavior of "Single Expand"

Only a single accordion can be open at a given time.

-}
singleExpandState : State
singleExpandState =
    SingleExpand None


{-| Constructs a state with behavior of "Multiple Expand"

Each accordion item clicked on will be opened. An open
accordion item clicked on will close.

-}
multipleExpandState : State
multipleExpandState =
    MultipleExpand None


{-| Constructs an accordian given a list of `(title, content)` and a message
mapper function.

The `msgMapper` needs to take a `PF4.Accordian.Msg` and transform it into
to the `msg` of your Elm application.

-}
accordion : (Msg -> msg) -> List ( String, Element msg ) -> Accordion msg
accordion msgMapper items =
    let
        accItems =
            { behavior = SingleExpand None
            , items =
                items
                    |> List.indexedMap Tuple.pair
                    |> List.map
                        (\( idx, ( title, content ) ) ->
                            ( idx
                            , accordionItem
                                { title = title
                                , content = content
                                }
                            )
                        )
                    |> List.foldr
                        (\( i, AccordionItem opts ) ->
                            Dict.insert opts.itemId ( i, AccordionItem opts )
                        )
                        Dict.empty
            }
    in
    Accordion
        { bordered = False
        , size = Default
        , msgMapper = msgMapper
        , children = accItems
        }


{-| Constructs an accordion item given a `title` and an `Element msg` as `content`
-}
accordionItem : { title : String, content : Element msg } -> AccordionItem msg
accordionItem { title, content } =
    let
        generatedId =
            Murmur3.hashString 650 title
                |> String.fromInt
    in
    AccordionItem
        { itemId = generatedId
        , title = title
        , content = content
        , onPress = Pressed generatedId
        }


itemMarkup : Accordion msg -> State -> AccordionItem msg -> Element msg
itemMarkup (Accordion parentOpts) state (AccordionItem options) =
    let
        selected_ itemId_ =
            getExpandState state
                |> member itemId_

        attrs_ =
            [ Element.width Element.fill ]

        childAttrs_ =
            [ Element.width Element.fill
            , Element.pointer
            , Events.onClick
                (parentOpts.msgMapper options.onPress)
            ]

        iconAttrs_ =
            [ Element.alignRight ]

        ( iconForState, contentEl ) =
            if selected_ options.itemId then
                ( Icons.chevronDown, options.content )

            else
                ( Icons.chevronRight, Element.none )
    in
    Element.column attrs_ <|
        [ Element.row childAttrs_ <|
            [ Element.el [] <| Element.text options.title
            , Element.el iconAttrs_ iconForState
            ]
        , contentEl
        ]


{-| Using the state and component's options to render as an `Element msg`

Stateful PF4 components will have a `toMarkupFor`, as an "markup for a
particular _state_", instead of the `toMarkup` used for stateless
components.

-}
toMarkupFor : State -> Accordion msg -> Element msg
toMarkupFor state ((Accordion options) as acccordion_) =
    let
        attrs_ =
            [ Element.padding 8
            , Element.height Element.fill
            , Element.width Element.fill
            ]

        items_ =
            options.children.items
                |> Dict.values
                |> List.sortBy Tuple.first
                |> List.map Tuple.second

        itemMarkup_ =
            itemMarkup acccordion_ state
    in
    Element.column attrs_ <|
        (items_ |> List.map itemMarkup_)



-- Update & State handling functions


member : ItemId -> Maybe SelectedIds -> Bool
member itemId_ mIds =
    mIds
        |> Maybe.map (Dict.member itemId_)
        |> Maybe.withDefault False


insert : ItemId -> SelectedIds -> SelectedIds
insert itemId_ ids =
    ids |> Dict.insert itemId_ itemId_


allowMultipleSelected : Behavior -> Bool
allowMultipleSelected behavior =
    currentBehavior behavior |> Tuple.first


getExpandState : Behavior -> Maybe SelectedIds
getExpandState behavior =
    currentBehavior behavior |> Tuple.second


currentBehavior : Behavior -> ( Bool, Maybe SelectedIds )
currentBehavior behavior =
    let
        toMaybe state_ =
            case state_ of
                None ->
                    Nothing

                Expanded ids ->
                    Just ids
    in
    case behavior of
        SingleExpand state ->
            ( False, state |> toMaybe )

        MultipleExpand state ->
            ( True, state |> toMaybe )


{-| When toggling an `ItemId` we may end up with an empty collection

This functions returns an `ExpandState`, but it will not always be
the `Expanded SelectedIds` variant.

-}
handleToggle : ItemId -> SelectedIds -> ExpandState
handleToggle itemId selectedIds =
    let
        newSelectedIds =
            Dict.remove itemId selectedIds
    in
    if Dict.size newSelectedIds == 0 then
        None

    else
        Expanded newSelectedIds


updateSelectedIds : ItemId -> Bool -> Maybe SelectedIds -> ExpandState
updateSelectedIds itemId allowMultiple mSelectedIds =
    let
        selectId_ itemId_ ids_ =
            if allowMultiple then
                insert itemId_ ids_

            else
                insert itemId_ Dict.empty
    in
    mSelectedIds
        |> Maybe.map
            (\selectedIds ->
                if member itemId (Just selectedIds) then
                    -- when we toggle, we remove; might be empty
                    handleToggle itemId selectedIds

                else
                    Expanded (selectId_ itemId selectedIds)
            )
        |> Maybe.withDefault
            (Expanded (insert itemId Dict.empty))


{-| Handles updating the `state` given the `Msg`
-}
update : Msg -> State -> State
update msg state =
    let
        ( allowMultiple, mSelectedIds ) =
            currentBehavior state

        wrapState state_ =
            if allowMultiple then
                MultipleExpand state_

            else
                SingleExpand state_
    in
    case msg of
        Pressed itemId ->
            mSelectedIds
                |> updateSelectedIds
                    itemId
                    allowMultiple
                |> wrapState
