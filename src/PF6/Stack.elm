module PF6.Stack exposing
    ( Stack, StackItem
    , stack, stackItem
    , withFill, withGutter
    , toMarkup
    )

{-| PF6 Stack layout

Arranges items vertically. One or more items can fill remaining vertical space.
No wrapping.

See: <https://www.patternfly.org/layouts/stack>


# Definition

@docs Stack, StackItem


# Constructors

@docs stack, stackItem


# Modifiers

@docs withFill, withGutter


# Rendering

@docs toMarkup

-}

import Element exposing (Element)
import PF6.Tokens as Tokens


{-| Opaque Stack type
-}
type Stack msg
    = Stack (Options msg)


{-| Opaque StackItem type
-}
type StackItem msg
    = StackItem (ItemOptions msg)


type alias Options msg =
    { items : List (StackItem msg)
    , hasGutter : Bool
    }


type alias ItemOptions msg =
    { child : Element msg
    , isFill : Bool
    }


{-| Construct a Stack with a list of StackItems
-}
stack : List (StackItem msg) -> Stack msg
stack items =
    Stack { items = items, hasGutter = False }


{-| Construct a StackItem wrapping content
-}
stackItem : Element msg -> StackItem msg
stackItem child =
    StackItem { child = child, isFill = False }


{-| Make this item fill remaining vertical space
-}
withFill : StackItem msg -> StackItem msg
withFill (StackItem opts) =
    StackItem { opts | isFill = True }


{-| Add medium gutter spacing between items
-}
withGutter : Stack msg -> Stack msg
withGutter (Stack opts) =
    Stack { opts | hasGutter = True }


{-| Render the Stack as an Element msg
-}
toMarkup : Stack msg -> Element msg
toMarkup (Stack opts) =
    let
        spacingAttr =
            if opts.hasGutter then
                Element.spacing Tokens.spacerMd

            else
                Element.spacing 0

        renderItem (StackItem item) =
            if item.isFill then
                Element.el
                    [ Element.width Element.fill
                    , Element.height Element.fill
                    ]
                    item.child

            else
                Element.el [ Element.width Element.fill ] item.child
    in
    Element.column
        [ Element.width Element.fill
        , Element.height Element.fill
        , spacingAttr
        ]
        (List.map renderItem opts.items)
