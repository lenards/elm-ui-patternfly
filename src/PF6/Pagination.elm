module PF6.Pagination exposing
    ( Pagination
    , pagination
    , withPerPage, withTotalItems
    , withCompact, withSticky
    , toMarkup
    )

{-| PF6 Pagination component

Pagination provides navigation for paged content.

See: <https://www.patternfly.org/components/pagination>


# Definition

@docs Pagination


# Constructor

@docs pagination


# Configuration modifiers

@docs withPerPage, withTotalItems


# Display modifiers

@docs withCompact, withSticky


# Rendering

@docs toMarkup

-}

import Element exposing (Element)
import Element.Background as Bg
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import PF6.Theme as Theme exposing (Theme)
import PF6.Tokens as Tokens


{-| Opaque Pagination type
-}
type Pagination msg
    = Pagination (Options msg)


type alias Options msg =
    { page : Int
    , perPage : Int
    , totalItems : Int
    , onPageChange : Int -> msg
    , isCompact : Bool
    , isSticky : Bool
    }


{-| Construct a Pagination component

    pagination
        { page = model.currentPage
        , onPageChange = PageChanged
        }

-}
pagination : { page : Int, onPageChange : Int -> msg } -> Pagination msg
pagination { page, onPageChange } =
    Pagination
        { page = page
        , perPage = 10
        , totalItems = 0
        , onPageChange = onPageChange
        , isCompact = False
        , isSticky = False
        }


{-| Set items per page
-}
withPerPage : Int -> Pagination msg -> Pagination msg
withPerPage n (Pagination opts) =
    Pagination { opts | perPage = n }


{-| Set total item count (used to calculate total pages)
-}
withTotalItems : Int -> Pagination msg -> Pagination msg
withTotalItems n (Pagination opts) =
    Pagination { opts | totalItems = n }


{-| Compact variant — smaller controls
-}
withCompact : Pagination msg -> Pagination msg
withCompact (Pagination opts) =
    Pagination { opts | isCompact = True }


{-| Sticky — sticks to the top or bottom of a scrolling area
-}
withSticky : Pagination msg -> Pagination msg
withSticky (Pagination opts) =
    Pagination { opts | isSticky = True }


totalPages : Options msg -> Int
totalPages opts =
    if opts.perPage > 0 then
        ceiling (toFloat opts.totalItems / toFloat opts.perPage)

    else
        1


navButton : Theme -> String -> Maybe msg -> Element msg
navButton theme label onPress =
    Input.button
        [ Element.paddingXY Tokens.spacerSm Tokens.spacerXs
        , Border.rounded Tokens.radiusMd
        , Border.solid
        , Border.width 1
        , Border.color (Theme.borderDefault theme)
        , Bg.color (Theme.backgroundDefault theme)
        , Font.color
            (case onPress of
                Nothing ->
                    Theme.textSubtle theme

                Just _ ->
                    Theme.text theme
            )
        ]
        { onPress = onPress
        , label = Element.text label
        }


{-| Render the Pagination as an `Element msg`
-}
toMarkup : Theme -> Pagination msg -> Element msg
toMarkup theme (Pagination opts) =
    let
        total =
            totalPages opts

        isFirst =
            opts.page <= 1

        isLast =
            opts.page >= total

        rangeStart =
            (opts.page - 1) * opts.perPage + 1

        rangeEnd =
            min (opts.page * opts.perPage) opts.totalItems

        rangeText =
            if opts.totalItems > 0 then
                String.fromInt rangeStart
                    ++ " - "
                    ++ String.fromInt rangeEnd
                    ++ " of "
                    ++ String.fromInt opts.totalItems

            else
                String.fromInt opts.page ++ " of " ++ String.fromInt total

        firstBtn =
            navButton theme "«"
                (if isFirst then
                    Nothing

                 else
                    Just (opts.onPageChange 1)
                )

        prevBtn =
            navButton theme "‹"
                (if isFirst then
                    Nothing

                 else
                    Just (opts.onPageChange (opts.page - 1))
                )

        nextBtn =
            navButton theme "›"
                (if isLast then
                    Nothing

                 else
                    Just (opts.onPageChange (opts.page + 1))
                )

        lastBtn =
            navButton theme "»"
                (if isLast then
                    Nothing

                 else
                    Just (opts.onPageChange total)
                )

        pageDisplay =
            Element.el
                [ Font.size Tokens.fontSizeMd
                , Font.color (Theme.text theme)
                , Element.paddingXY Tokens.spacerSm 0
                ]
                (Element.text rangeText)
    in
    Element.row
        [ Element.spacing Tokens.spacerXs
        , Element.paddingXY 0 Tokens.spacerXs
        ]
        (if opts.isCompact then
            [ prevBtn, pageDisplay, nextBtn ]

         else
            [ pageDisplay, firstBtn, prevBtn, nextBtn, lastBtn ]
        )
