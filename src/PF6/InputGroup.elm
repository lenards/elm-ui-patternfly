module PF6.InputGroup exposing
    ( InputGroup, InputGroupItem
    , inputGroup
    , inputGroupItem, inputGroupText
    , toMarkup
    )

{-| PF6 InputGroup component

Groups multiple form controls with shared borders.

See: <https://www.patternfly.org/components/input-group>


# Definition

@docs InputGroup, InputGroupItem


# Constructor

@docs inputGroup


# Item constructors

@docs inputGroupItem, inputGroupText


# Rendering

@docs toMarkup

-}

import Element exposing (Element)
import Element.Background as Bg
import Element.Border as Border
import Element.Font as Font
import PF6.Tokens as Tokens


{-| Opaque InputGroup type
-}
type InputGroup msg
    = InputGroup (List (InputGroupItem msg))


{-| An item within an InputGroup
-}
type InputGroupItem msg
    = ItemElement (Element msg)
    | ItemText String


{-| Construct an InputGroup from a list of items

    inputGroup
        [ inputGroupText "$"
        , inputGroupItem myTextInput
        , inputGroupText ".00"
        ]

-}
inputGroup : List (InputGroupItem msg) -> InputGroup msg
inputGroup items =
    InputGroup items


{-| Wrap an element as an input group item
-}
inputGroupItem : Element msg -> InputGroupItem msg
inputGroupItem el =
    ItemElement el


{-| A plain text segment in the input group
-}
inputGroupText : String -> InputGroupItem msg
inputGroupText text =
    ItemText text


type Position
    = First
    | Middle
    | Last
    | Only


positionOf : Int -> Int -> Position
positionOf index total =
    if total == 1 then
        Only

    else if index == 0 then
        First

    else if index == total - 1 then
        Last

    else
        Middle


borderRadiusFor : Position -> List (Element.Attribute msg)
borderRadiusFor pos =
    let
        r =
            Tokens.radiusMd
    in
    case pos of
        First ->
            [ Border.roundEach { topLeft = r, bottomLeft = r, topRight = 0, bottomRight = 0 } ]

        Last ->
            [ Border.roundEach { topLeft = 0, bottomLeft = 0, topRight = r, bottomRight = r } ]

        Middle ->
            [ Border.roundEach { topLeft = 0, bottomLeft = 0, topRight = 0, bottomRight = 0 } ]

        Only ->
            [ Border.rounded r ]


renderItem : Position -> InputGroupItem msg -> Element msg
renderItem pos item =
    case item of
        ItemElement el ->
            Element.el
                ([ Element.width Element.fill
                 ]
                    ++ borderRadiusFor pos
                )
                el

        ItemText text ->
            Element.el
                ([ Element.paddingXY Tokens.spacerSm Tokens.spacerSm
                 , Bg.color Tokens.colorBackgroundSecondary
                 , Font.size Tokens.fontSizeMd
                 , Font.color Tokens.colorText
                 , Border.solid
                 , Border.width 1
                 , Border.color Tokens.colorBorderDefault
                 , Element.centerY
                 ]
                    ++ borderRadiusFor pos
                )
                (Element.text text)


{-| Render the InputGroup as an `Element msg`
-}
toMarkup : InputGroup msg -> Element msg
toMarkup (InputGroup items) =
    let
        total =
            List.length items
    in
    Element.row
        [ Element.width Element.fill ]
        (List.indexedMap
            (\i item ->
                renderItem (positionOf i total) item
            )
            items
        )
