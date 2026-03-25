module PF6.Grid exposing
    ( Grid, GridItem
    , grid, gridItem
    , withGutter, withSpan
    , toMarkup
    )

{-| PF6 Grid layout

12-column grid system. Each item specifies how many columns it spans.

See: <https://www.patternfly.org/layouts/grid>


# Definition

@docs Grid, GridItem


# Constructors

@docs grid, gridItem


# Modifiers

@docs withGutter, withSpan


# Rendering

@docs toMarkup

-}

import Element exposing (Element)
import Html.Attributes
import PF6.Tokens as Tokens


{-| Opaque Grid type
-}
type Grid msg
    = Grid (Options msg)


{-| Opaque GridItem type
-}
type GridItem msg
    = GridItem (ItemOptions msg)


type alias Options msg =
    { items : List (GridItem msg)
    , hasGutter : Bool
    }


type alias ItemOptions msg =
    { child : Element msg
    , span : Int
    }


{-| Construct a Grid with a list of GridItems
-}
grid : List (GridItem msg) -> Grid msg
grid items =
    Grid { items = items, hasGutter = False }


{-| Construct a GridItem wrapping content. Defaults to span 12 (full width).
-}
gridItem : Element msg -> GridItem msg
gridItem child =
    GridItem { child = child, span = 12 }


{-| Set column span (1-12) for a grid item
-}
withSpan : Int -> GridItem msg -> GridItem msg
withSpan s (GridItem opts) =
    GridItem { opts | span = clamp 1 12 s }


{-| Add medium gutter spacing between items
-}
withGutter : Grid msg -> Grid msg
withGutter (Grid opts) =
    Grid { opts | hasGutter = True }


{-| Render the Grid as an Element msg
-}
toMarkup : Grid msg -> Element msg
toMarkup (Grid opts) =
    let
        spacingAttr =
            if opts.hasGutter then
                Element.spacing Tokens.spacerMd

            else
                Element.spacing 0

        renderItem (GridItem item) =
            let
                pct =
                    toFloat item.span / 12 * 100

                widthStr =
                    if opts.hasGutter then
                        "calc(" ++ String.fromFloat pct ++ "% - " ++ String.fromInt Tokens.spacerMd ++ "px + " ++ String.fromFloat (toFloat Tokens.spacerMd * toFloat item.span / 12) ++ "px)"

                    else
                        String.fromFloat pct ++ "%"
            in
            Element.el
                [ Element.htmlAttribute (Html.Attributes.style "width" widthStr)
                , Element.htmlAttribute (Html.Attributes.style "flex-shrink" "0")
                ]
                (Element.el [ Element.width Element.fill ] item.child)
    in
    Element.wrappedRow
        [ Element.width Element.fill
        , spacingAttr
        ]
        (List.map renderItem opts.items)
