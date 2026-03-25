module PF6.Gallery exposing
    ( Gallery
    , gallery
    , withGutter, withMinWidthPx, withMaxWidthPx
    , toMarkup
    )

{-| PF6 Gallery layout

Responsive grid of uniform items. Items wrap and maintain consistent sizing.

See: <https://www.patternfly.org/layouts/gallery>


# Definition

@docs Gallery


# Constructor

@docs gallery


# Modifiers

@docs withGutter, withMinWidthPx, withMaxWidthPx


# Rendering

@docs toMarkup

-}

import Element exposing (Element)
import PF6.Tokens as Tokens


{-| Opaque Gallery type
-}
type Gallery msg
    = Gallery (Options msg)


type alias Options msg =
    { items : List (Element msg)
    , hasGutter : Bool
    , minWidth : Maybe Int
    , maxWidth : Maybe Int
    }


{-| Construct a Gallery with a list of items
-}
gallery : List (Element msg) -> Gallery msg
gallery items =
    Gallery
        { items = items
        , hasGutter = False
        , minWidth = Nothing
        , maxWidth = Nothing
        }


{-| Add medium gutter spacing between items
-}
withGutter : Gallery msg -> Gallery msg
withGutter (Gallery opts) =
    Gallery { opts | hasGutter = True }


{-| Set minimum width for each gallery item
-}
withMinWidthPx : Int -> Gallery msg -> Gallery msg
withMinWidthPx w (Gallery opts) =
    Gallery { opts | minWidth = Just w }


{-| Set maximum width for each gallery item
-}
withMaxWidthPx : Int -> Gallery msg -> Gallery msg
withMaxWidthPx w (Gallery opts) =
    Gallery { opts | maxWidth = Just w }


{-| Render the Gallery as an Element msg
-}
toMarkup : Gallery msg -> Element msg
toMarkup (Gallery opts) =
    let
        spacingAttr =
            if opts.hasGutter then
                Element.spacing Tokens.spacerMd

            else
                Element.spacing 0

        itemWidth =
            let
                base =
                    Element.fill

                withMin =
                    case opts.minWidth of
                        Just m ->
                            Element.minimum m base

                        Nothing ->
                            base

                withMax =
                    case opts.maxWidth of
                        Just m ->
                            Element.maximum m withMin

                        Nothing ->
                            withMin
            in
            withMax

        wrapItem child =
            Element.el [ Element.width itemWidth ] child
    in
    Element.wrappedRow
        [ Element.width Element.fill
        , spacingAttr
        ]
        (List.map wrapItem opts.items)
