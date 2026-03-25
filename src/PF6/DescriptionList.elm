module PF6.DescriptionList exposing
    ( DescriptionList, DescriptionGroup
    , descriptionList
    , group
    , withHorizontal, withCompact, withAutoColumnSize, withColumnCount
    , withTermWidth
    , toMarkup
    )

{-| PF6 DescriptionList component

Description lists display term/value pairs, often used for metadata or details panels.

See: <https://www.patternfly.org/components/description-list>


# Definition

@docs DescriptionList, DescriptionGroup


# Constructor

@docs descriptionList


# Group constructor

@docs group


# Layout modifiers

@docs withHorizontal, withCompact, withAutoColumnSize, withColumnCount


# Width modifiers

@docs withTermWidth


# Rendering

@docs toMarkup

-}

import Element exposing (Element)
import Element.Font as Font
import PF6.Theme as Theme exposing (Theme)
import PF6.Tokens as Tokens


{-| Opaque DescriptionList type
-}
type DescriptionList msg
    = DescriptionList (Options msg)


{-| A term/value group
-}
type DescriptionGroup msg
    = DescriptionGroup (GroupOptions msg)


type alias GroupOptions msg =
    { term : String
    , descriptions : List (Element msg)
    }


type alias Options msg =
    { groups : List (DescriptionGroup msg)
    , isHorizontal : Bool
    , isCompact : Bool
    , columnCount : Maybe Int
    , termWidth : Maybe Int
    }


{-| Construct a DescriptionList from groups
-}
descriptionList : List (DescriptionGroup msg) -> DescriptionList msg
descriptionList groups =
    DescriptionList
        { groups = groups
        , isHorizontal = False
        , isCompact = False
        , columnCount = Nothing
        , termWidth = Nothing
        }


{-| Create a term/description group

    group "Name" [ Element.text "Alice" ]

-}
group : String -> List (Element msg) -> DescriptionGroup msg
group term descriptions =
    DescriptionGroup
        { term = term
        , descriptions = descriptions
        }


{-| Horizontal layout — term and descriptions side by side
-}
withHorizontal : DescriptionList msg -> DescriptionList msg
withHorizontal (DescriptionList opts) =
    DescriptionList { opts | isHorizontal = True }


{-| Compact — reduced spacing
-}
withCompact : DescriptionList msg -> DescriptionList msg
withCompact (DescriptionList opts) =
    DescriptionList { opts | isCompact = True }


{-| Auto column sizing
-}
withAutoColumnSize : DescriptionList msg -> DescriptionList msg
withAutoColumnSize (DescriptionList opts) =
    DescriptionList { opts | columnCount = Nothing }


{-| Fixed column count (1–3)
-}
withColumnCount : Int -> DescriptionList msg -> DescriptionList msg
withColumnCount n (DescriptionList opts) =
    DescriptionList { opts | columnCount = Just (clamp 1 3 n) }


{-| Fixed term width in pixels (useful for horizontal layout)
-}
withTermWidth : Int -> DescriptionList msg -> DescriptionList msg
withTermWidth px (DescriptionList opts) =
    DescriptionList { opts | termWidth = Just px }


renderGroup : Theme -> Options msg -> DescriptionGroup msg -> Element msg
renderGroup theme opts (DescriptionGroup g) =
    let
        spacing =
            if opts.isCompact then
                Tokens.spacerXs

            else
                Tokens.spacerSm

        termEl =
            Element.el
                [ Font.bold
                , Font.size Tokens.fontSizeMd
                , Font.color (Theme.text theme)
                , case opts.termWidth of
                    Just w ->
                        Element.width (Element.px w)

                    Nothing ->
                        Element.width Element.shrink
                ]
                (Element.text (g.term ++ ":"))

        descEls =
            Element.column
                [ Element.spacing Tokens.spacerXs
                , Element.width Element.fill
                ]
                (List.map
                    (\d ->
                        Element.el
                            [ Font.size Tokens.fontSizeMd
                            , Font.color (Theme.text theme)
                            ]
                            d
                    )
                    g.descriptions
                )
    in
    if opts.isHorizontal then
        Element.row
            [ Element.width Element.fill
            , Element.spacing spacing
            , Element.alignTop
            ]
            [ termEl, descEls ]

    else
        Element.column
            [ Element.spacing spacing ]
            [ termEl, descEls ]


{-| Render the DescriptionList as an `Element msg`
-}
toMarkup : Theme -> DescriptionList msg -> Element msg
toMarkup theme (DescriptionList opts) =
    let
        outerSpacing =
            if opts.isCompact then
                Tokens.spacerSm

            else
                Tokens.spacerMd

        groupEls =
            List.map (renderGroup theme opts) opts.groups
    in
    case opts.columnCount of
        Just 2 ->
            let
                half =
                    List.length groupEls // 2

                left =
                    List.take half groupEls

                right =
                    List.drop half groupEls
            in
            Element.row
                [ Element.width Element.fill
                , Element.spacing Tokens.spacerXl
                , Element.alignTop
                ]
                [ Element.column [ Element.width Element.fill, Element.spacing outerSpacing ] left
                , Element.column [ Element.width Element.fill, Element.spacing outerSpacing ] right
                ]

        Just 3 ->
            let
                third =
                    List.length groupEls // 3

                col1 =
                    List.take third groupEls

                col2 =
                    List.take third (List.drop third groupEls)

                col3 =
                    List.drop (third * 2) groupEls
            in
            Element.row
                [ Element.width Element.fill
                , Element.spacing Tokens.spacerXl
                , Element.alignTop
                ]
                [ Element.column [ Element.width Element.fill, Element.spacing outerSpacing ] col1
                , Element.column [ Element.width Element.fill, Element.spacing outerSpacing ] col2
                , Element.column [ Element.width Element.fill, Element.spacing outerSpacing ] col3
                ]

        _ ->
            Element.column
                [ Element.width Element.fill
                , Element.spacing outerSpacing
                ]
                groupEls
