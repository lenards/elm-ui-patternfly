module PF4.ExpandableSection exposing (..)

import Element exposing (Element)
import Element.Events as Events
import PF4.Icons as Icons


{-| Opaque `ExpandableSection`element that can produce `msg` messages
-}
type ExpandableSection msg
    = ExpandableSection (Options msg)


type alias Options msg =
    { text : ExpandText
    , content : Element msg
    , variation : Variant
    , onPress : Maybe msg
    , state : State
    }


{-| Defines variation of ExpandableSection

Within the PatternFly design system, there is a "Disclosure variation"
that will be not immediately implemented.

Here we tempted the "YAGNI" gods ire. Please be merciful

-}
type Variant
    = Basic


type State
    = Open
    | Closed


type ExpandText
    = Static String
    | Dynamic OpenText ClosedText


type alias OpenText =
    String


type alias ClosedText =
    String


expandableSection :
    { text : String
    , content : Element msg
    , onPress : Maybe msg
    }
    -> ExpandableSection msg
expandableSection { text, content, onPress } =
    ExpandableSection
        { text = Static text
        , content = content
        , variation = Basic
        , onPress = onPress
        , state = Closed
        }


withDynamicText : { open : String, closed : String } -> ExpandableSection msg -> ExpandableSection msg
withDynamicText { open, closed } (ExpandableSection options) =
    ExpandableSection
        { options | text = Dynamic open closed }


withPressMsg : msg -> ExpandableSection msg -> ExpandableSection msg
withPressMsg onPress (ExpandableSection options) =
    ExpandableSection
        { options | onPress = Just onPress }


{-| Make the element not respond to `onPress`
-}
disableOnPress : ExpandableSection msg -> ExpandableSection msg
disableOnPress (ExpandableSection options) =
    ExpandableSection
        { options | onPress = Nothing }


{-| Requests the state change of the element to an expanded, or open state
-}
expandSection : ExpandableSection msg -> ExpandableSection msg
expandSection (ExpandableSection options) =
    ExpandableSection
        { options | state = Open }


{-| Requests the state change of the element to a collapsed, or closed state
-}
collapseSection : ExpandableSection msg -> ExpandableSection msg
collapseSection (ExpandableSection options) =
    ExpandableSection
        { options | state = Closed }


textMarkup : Options msg -> Element msg
textMarkup { state, text } =
    let
        ( iconForState, text_ ) =
            case ( state, text ) of
                ( Open, Static staticText ) ->
                    ( Icons.chevronDown, staticText )

                ( Open, Dynamic openText _ ) ->
                    ( Icons.chevronDown, openText )

                ( Closed, Static staticText ) ->
                    ( Icons.chevronRight, staticText )

                ( Closed, Dynamic _ closedText ) ->
                    ( Icons.chevronRight, closedText )
    in
    Element.row [] <|
        [ iconForState
        , Element.el [] <| Element.text text_
        ]


eventAttr : Options msg -> List (Element.Attribute msg)
eventAttr options =
    options.onPress
        |> Maybe.map
            (\onPressMsg -> [ Events.onClick onPressMsg ])
        |> Maybe.withDefault []


{-| Given the custom type representation, renders as an `Element msg`.
-}
toMarkup : ExpandableSection msg -> Element msg
toMarkup (ExpandableSection options) =
    let
        attrs_ =
            [ Element.height Element.fill
            , Element.width Element.fill
            ]
                ++ eventAttr options

        textEl =
            textMarkup options

        childAttrs_ =
            []

        contentEl =
            case options.state of
                Open ->
                    options.content

                Closed ->
                    Element.none
    in
    Element.column attrs_ <|
        [ textEl
        , contentEl
        ]
