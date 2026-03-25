module PF6.Flex exposing
    ( Flex, FlexItem
    , flex, flexItem
    , withColumn, withRow, withRowReverse, withColumnReverse
    , withWrap, withNoWrap
    , withJustifyStart, withJustifyCenter, withJustifyEnd, withJustifySpaceBetween
    , withAlignStart, withAlignCenter, withAlignEnd, withAlignStretch
    , withGap, withGapSm, withGapMd, withGapLg, withGapXl
    , withGrow, withShrink, withFlex1
    , toMarkup
    )

{-| PF6 Flex layout

Flexible layout with configurable direction, alignment, justification,
wrapping, and gap.

See: <https://www.patternfly.org/layouts/flex>


# Definition

@docs Flex, FlexItem


# Constructors

@docs flex, flexItem


# Direction

@docs withColumn, withRow, withRowReverse, withColumnReverse


# Wrapping

@docs withWrap, withNoWrap


# Justification

@docs withJustifyStart, withJustifyCenter, withJustifyEnd, withJustifySpaceBetween


# Alignment

@docs withAlignStart, withAlignCenter, withAlignEnd, withAlignStretch


# Gap

@docs withGap, withGapSm, withGapMd, withGapLg, withGapXl


# Item modifiers

@docs withGrow, withShrink, withFlex1


# Rendering

@docs toMarkup

-}

import Element exposing (Element)
import Html.Attributes
import PF6.Theme exposing (Theme)
import PF6.Tokens as Tokens


{-| Opaque Flex type
-}
type Flex msg
    = Flex (Options msg)


{-| Opaque FlexItem type
-}
type FlexItem msg
    = FlexItem (ItemOptions msg)


type Direction
    = Row
    | Column
    | RowReverse
    | ColumnReverse


type Justify
    = JustifyStart
    | JustifyCenter
    | JustifyEnd
    | JustifySpaceBetween


type Align
    = AlignStart
    | AlignCenter
    | AlignEnd
    | AlignStretch


type alias Options msg =
    { items : List (FlexItem msg)
    , direction : Direction
    , hasWrap : Bool
    , justify : Justify
    , align : Align
    , gap : Int
    }


type alias ItemOptions msg =
    { child : Element msg
    , grow : Bool
    , shrink : Bool
    , flex1 : Bool
    }


{-| Construct a Flex layout with a list of FlexItems
-}
flex : List (FlexItem msg) -> Flex msg
flex items =
    Flex
        { items = items
        , direction = Row
        , hasWrap = False
        , justify = JustifyStart
        , align = AlignStretch
        , gap = 0
        }


{-| Construct a FlexItem wrapping content
-}
flexItem : Element msg -> FlexItem msg
flexItem child =
    FlexItem { child = child, grow = False, shrink = False, flex1 = False }


{-| Set direction to column (vertical)
-}
withColumn : Flex msg -> Flex msg
withColumn (Flex opts) =
    Flex { opts | direction = Column }


{-| Set direction to row (horizontal, default)
-}
withRow : Flex msg -> Flex msg
withRow (Flex opts) =
    Flex { opts | direction = Row }


{-| Set direction to row-reverse
-}
withRowReverse : Flex msg -> Flex msg
withRowReverse (Flex opts) =
    Flex { opts | direction = RowReverse }


{-| Set direction to column-reverse
-}
withColumnReverse : Flex msg -> Flex msg
withColumnReverse (Flex opts) =
    Flex { opts | direction = ColumnReverse }


{-| Enable wrapping
-}
withWrap : Flex msg -> Flex msg
withWrap (Flex opts) =
    Flex { opts | hasWrap = True }


{-| Disable wrapping
-}
withNoWrap : Flex msg -> Flex msg
withNoWrap (Flex opts) =
    Flex { opts | hasWrap = False }


{-| Justify items to start
-}
withJustifyStart : Flex msg -> Flex msg
withJustifyStart (Flex opts) =
    Flex { opts | justify = JustifyStart }


{-| Justify items to center
-}
withJustifyCenter : Flex msg -> Flex msg
withJustifyCenter (Flex opts) =
    Flex { opts | justify = JustifyCenter }


{-| Justify items to end
-}
withJustifyEnd : Flex msg -> Flex msg
withJustifyEnd (Flex opts) =
    Flex { opts | justify = JustifyEnd }


{-| Justify items with space between
-}
withJustifySpaceBetween : Flex msg -> Flex msg
withJustifySpaceBetween (Flex opts) =
    Flex { opts | justify = JustifySpaceBetween }


{-| Align items to start
-}
withAlignStart : Flex msg -> Flex msg
withAlignStart (Flex opts) =
    Flex { opts | align = AlignStart }


{-| Align items to center
-}
withAlignCenter : Flex msg -> Flex msg
withAlignCenter (Flex opts) =
    Flex { opts | align = AlignCenter }


{-| Align items to end
-}
withAlignEnd : Flex msg -> Flex msg
withAlignEnd (Flex opts) =
    Flex { opts | align = AlignEnd }


{-| Stretch items to fill cross axis
-}
withAlignStretch : Flex msg -> Flex msg
withAlignStretch (Flex opts) =
    Flex { opts | align = AlignStretch }


{-| Set custom gap in pixels
-}
withGap : Int -> Flex msg -> Flex msg
withGap g (Flex opts) =
    Flex { opts | gap = g }


{-| Set small gap
-}
withGapSm : Flex msg -> Flex msg
withGapSm (Flex opts) =
    Flex { opts | gap = Tokens.spacerSm }


{-| Set medium gap
-}
withGapMd : Flex msg -> Flex msg
withGapMd (Flex opts) =
    Flex { opts | gap = Tokens.spacerMd }


{-| Set large gap
-}
withGapLg : Flex msg -> Flex msg
withGapLg (Flex opts) =
    Flex { opts | gap = Tokens.spacerLg }


{-| Set extra-large gap
-}
withGapXl : Flex msg -> Flex msg
withGapXl (Flex opts) =
    Flex { opts | gap = Tokens.spacerXl }


{-| Make item grow to fill available space
-}
withGrow : FlexItem msg -> FlexItem msg
withGrow (FlexItem opts) =
    FlexItem { opts | grow = True }


{-| Make item shrink
-}
withShrink : FlexItem msg -> FlexItem msg
withShrink (FlexItem opts) =
    FlexItem { opts | shrink = True }


{-| Set item to flex: 1 (grow and shrink equally)
-}
withFlex1 : FlexItem msg -> FlexItem msg
withFlex1 (FlexItem opts) =
    FlexItem { opts | flex1 = True }


{-| Render the Flex layout as an Element msg
-}
toMarkup : Theme -> Flex msg -> Element msg
toMarkup _ (Flex opts) =
    let
        isReversed =
            case opts.direction of
                RowReverse ->
                    True

                ColumnReverse ->
                    True

                _ ->
                    False

        isColumnDir =
            case opts.direction of
                Column ->
                    True

                ColumnReverse ->
                    True

                _ ->
                    False

        justifyAttrs =
            case opts.justify of
                JustifyStart ->
                    []

                JustifyCenter ->
                    if isColumnDir then
                        [ Element.centerY ]

                    else
                        [ Element.centerX ]

                JustifyEnd ->
                    if isColumnDir then
                        [ Element.alignBottom ]

                    else
                        [ Element.alignRight ]

                JustifySpaceBetween ->
                    [ Element.htmlAttribute (Html.Attributes.style "justify-content" "space-between") ]

        alignAttrs =
            case opts.align of
                AlignStart ->
                    if isColumnDir then
                        [ Element.alignLeft ]

                    else
                        [ Element.alignTop ]

                AlignCenter ->
                    if isColumnDir then
                        [ Element.centerX ]

                    else
                        [ Element.centerY ]

                AlignEnd ->
                    if isColumnDir then
                        [ Element.alignRight ]

                    else
                        [ Element.alignBottom ]

                AlignStretch ->
                    if isColumnDir then
                        [ Element.width Element.fill ]

                    else
                        [ Element.height Element.fill ]

        renderItem (FlexItem item) =
            let
                growAttr =
                    if item.flex1 || item.grow then
                        if isColumnDir then
                            [ Element.height Element.fill ]

                        else
                            [ Element.width Element.fill ]

                    else
                        []

                shrinkAttr =
                    if item.shrink then
                        [ Element.htmlAttribute (Html.Attributes.style "flex-shrink" "1") ]

                    else
                        []
            in
            Element.el (growAttr ++ shrinkAttr) item.child

        children =
            let
                rendered =
                    List.map renderItem opts.items
            in
            if isReversed then
                List.reverse rendered

            else
                rendered

        baseAttrs =
            [ Element.width Element.fill
            , Element.spacing opts.gap
            ]
                ++ justifyAttrs
                ++ alignAttrs
    in
    if isColumnDir then
        if opts.hasWrap then
            -- elm-ui doesn't have wrappedColumn, use column
            Element.column baseAttrs children

        else
            Element.column baseAttrs children

    else if opts.hasWrap then
        Element.wrappedRow baseAttrs children

    else
        Element.row baseAttrs children
