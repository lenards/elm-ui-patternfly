module PF6.SimpleList exposing
    ( SimpleList, SimpleListItem
    , simpleList, simpleListItem
    , withItemActive, withItemDisabled
    , withGrouped
    , toMarkup
    )

{-| PF6 SimpleList component

A clickable list with selection, used for simple navigation or action lists.

See: <https://www.patternfly.org/components/simple-list>


# Definition

@docs SimpleList, SimpleListItem


# Constructors

@docs simpleList, simpleListItem


# Item modifiers

@docs withItemActive, withItemDisabled


# List modifiers

@docs withGrouped


# Rendering

@docs toMarkup

-}

import Element exposing (Element)
import Element.Background as Bg
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import PF6.Tokens as Tokens


{-| Opaque SimpleList type
-}
type SimpleList msg
    = SimpleList (Options msg)


{-| Opaque SimpleListItem type
-}
type SimpleListItem msg
    = SimpleListItem (ItemOptions msg)


type alias ItemOptions msg =
    { label : String
    , onClick : msg
    , isActive : Bool
    , isDisabled : Bool
    }


type alias Options msg =
    { items : List (SimpleListItem msg)
    , grouped : Bool
    }


{-| Construct a SimpleList

    simpleList
        [ simpleListItem "Option 1" (Selected "opt1") |> withItemActive
        , simpleListItem "Option 2" (Selected "opt2")
        , simpleListItem "Option 3" (Selected "opt3")
        ]

-}
simpleList : List (SimpleListItem msg) -> SimpleList msg
simpleList items =
    SimpleList
        { items = items
        , grouped = False
        }


{-| Construct a list item with label and click handler
-}
simpleListItem : String -> msg -> SimpleListItem msg
simpleListItem label onClick =
    SimpleListItem
        { label = label
        , onClick = onClick
        , isActive = False
        , isDisabled = False
        }


{-| Mark an item as active/selected
-}
withItemActive : SimpleListItem msg -> SimpleListItem msg
withItemActive (SimpleListItem opts) =
    SimpleListItem { opts | isActive = True }


{-| Disable an item
-}
withItemDisabled : SimpleListItem msg -> SimpleListItem msg
withItemDisabled (SimpleListItem opts) =
    SimpleListItem { opts | isDisabled = True }


{-| Display items in a grouped style with borders
-}
withGrouped : SimpleList msg -> SimpleList msg
withGrouped (SimpleList opts) =
    SimpleList { opts | grouped = True }


itemMarkup : SimpleListItem msg -> Element msg
itemMarkup (SimpleListItem opts) =
    let
        bgColor =
            if opts.isActive then
                Element.rgb255 215 235 255

            else
                Tokens.colorBackgroundDefault

        textColor =
            if opts.isDisabled then
                Tokens.colorTextSubtle

            else if opts.isActive then
                Tokens.colorPrimary

            else
                Tokens.colorText

        onPress =
            if opts.isDisabled then
                Nothing

            else
                Just opts.onClick

        leftBorder =
            if opts.isActive then
                Border.widthEach { top = 0, right = 0, bottom = 0, left = 3 }

            else
                Border.widthEach { top = 0, right = 0, bottom = 0, left = 0 }

        borderColor =
            if opts.isActive then
                Border.color Tokens.colorPrimary

            else
                Border.color (Element.rgba 0 0 0 0)
    in
    Input.button
        [ Element.width Element.fill
        , Element.paddingXY Tokens.spacerMd Tokens.spacerSm
        , Bg.color bgColor
        , Font.color textColor
        , Font.size Tokens.fontSizeMd
        , leftBorder
        , borderColor
        ]
        { onPress = onPress
        , label = Element.text opts.label
        }


{-| Render the SimpleList as an `Element msg`
-}
toMarkup : SimpleList msg -> Element msg
toMarkup (SimpleList opts) =
    let
        borderAttrs =
            if opts.grouped then
                [ Border.solid
                , Border.width 1
                , Border.color Tokens.colorBorderDefault
                , Border.rounded Tokens.radiusMd
                ]

            else
                []
    in
    Element.column
        ([ Element.width Element.fill
         ]
            ++ borderAttrs
        )
        (List.map itemMarkup opts.items)
