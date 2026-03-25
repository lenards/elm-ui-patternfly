module PF6.Split exposing
    ( Split, SplitItem
    , split, splitItem
    , withFill, withWrap, withGutter
    , toMarkup
    )

{-| PF6 Split layout

Distributes items horizontally. One or more items can fill remaining horizontal
space. Supports wrapping.

See: <https://www.patternfly.org/layouts/split>


# Definition

@docs Split, SplitItem


# Constructors

@docs split, splitItem


# Modifiers

@docs withFill, withWrap, withGutter


# Rendering

@docs toMarkup

-}

import Element exposing (Element)
import PF6.Tokens as Tokens


{-| Opaque Split type
-}
type Split msg
    = Split (Options msg)


{-| Opaque SplitItem type
-}
type SplitItem msg
    = SplitItem (ItemOptions msg)


type alias Options msg =
    { items : List (SplitItem msg)
    , hasGutter : Bool
    , hasWrap : Bool
    }


type alias ItemOptions msg =
    { child : Element msg
    , isFill : Bool
    }


{-| Construct a Split with a list of SplitItems
-}
split : List (SplitItem msg) -> Split msg
split items =
    Split { items = items, hasGutter = False, hasWrap = False }


{-| Construct a SplitItem wrapping content
-}
splitItem : Element msg -> SplitItem msg
splitItem child =
    SplitItem { child = child, isFill = False }


{-| Make this item fill remaining horizontal space
-}
withFill : SplitItem msg -> SplitItem msg
withFill (SplitItem opts) =
    SplitItem { opts | isFill = True }


{-| Enable wrapping of items on resize
-}
withWrap : Split msg -> Split msg
withWrap (Split opts) =
    Split { opts | hasWrap = True }


{-| Add medium gutter spacing between items
-}
withGutter : Split msg -> Split msg
withGutter (Split opts) =
    Split { opts | hasGutter = True }


{-| Render the Split as an Element msg
-}
toMarkup : Split msg -> Element msg
toMarkup (Split opts) =
    let
        spacingAttr =
            if opts.hasGutter then
                Element.spacing Tokens.spacerMd

            else
                Element.spacing 0

        renderItem (SplitItem item) =
            if item.isFill then
                Element.el [ Element.width Element.fill ] item.child

            else
                item.child

        attrs =
            [ Element.width Element.fill, spacingAttr ]

        children =
            List.map renderItem opts.items

        rowFn =
            if opts.hasWrap then
                Element.wrappedRow

            else
                Element.row
    in
    rowFn attrs children
