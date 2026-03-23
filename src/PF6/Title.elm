module PF6.Title exposing
    ( Title
    , title
    , withH1, withH2, withH3, withH4, withH5, withH6
    , withExtraAttributes
    , toMarkup
    )

{-| PF6 Title component

Provides semantic heading levels (h1–h6) with PF6 typography sizing.

See: <https://www.patternfly.org/components/title>


# Definition

@docs Title


# Constructor

@docs title


# Heading level modifiers

@docs withH1, withH2, withH3, withH4, withH5, withH6


# Extra attributes

@docs withExtraAttributes


# Rendering

@docs toMarkup

-}

import Element exposing (Element)
import Element.Font as Font
import Element.Region as Region
import PF6.Tokens as Tokens


{-| Opaque Title type
-}
type Title msg
    = Title (Options msg)


type HeadingLevel
    = H1
    | H2
    | H3
    | H4
    | H5
    | H6


type alias Options msg =
    { text : String
    , level : HeadingLevel
    , extraAttrs : List (Element.Attribute msg)
    }


{-| Construct a Title — defaults to H1 sizing
-}
title : String -> Title msg
title text =
    Title
        { text = text
        , level = H1
        , extraAttrs = []
        }


{-| H1 — 2xl size (36px)
-}
withH1 : Title msg -> Title msg
withH1 (Title opts) =
    Title { opts | level = H1 }


{-| H2 — xl size (28px)
-}
withH2 : Title msg -> Title msg
withH2 (Title opts) =
    Title { opts | level = H2 }


{-| H3 — lg size (24px)
-}
withH3 : Title msg -> Title msg
withH3 (Title opts) =
    Title { opts | level = H3 }


{-| H4 — md size (20px)
-}
withH4 : Title msg -> Title msg
withH4 (Title opts) =
    Title { opts | level = H4 }


{-| H5 — default size (16px), bold
-}
withH5 : Title msg -> Title msg
withH5 (Title opts) =
    Title { opts | level = H5 }


{-| H6 — sm size (14px), bold
-}
withH6 : Title msg -> Title msg
withH6 (Title opts) =
    Title { opts | level = H6 }


{-| Append extra elm-ui attributes
-}
withExtraAttributes : List (Element.Attribute msg) -> Title msg -> Title msg
withExtraAttributes attrs (Title opts) =
    Title { opts | extraAttrs = opts.extraAttrs ++ attrs }


levelAttrs : HeadingLevel -> List (Element.Attribute msg)
levelAttrs level =
    case level of
        H1 ->
            [ Font.size Tokens.fontSize4xl
            , Font.bold
            , Region.heading 1
            ]

        H2 ->
            [ Font.size Tokens.fontSize3xl
            , Font.bold
            , Region.heading 2
            ]

        H3 ->
            [ Font.size Tokens.fontSize2xl
            , Font.bold
            , Region.heading 3
            ]

        H4 ->
            [ Font.size Tokens.fontSizeXl
            , Font.bold
            , Region.heading 4
            ]

        H5 ->
            [ Font.size Tokens.fontSizeLg
            , Font.bold
            , Region.heading 5
            ]

        H6 ->
            [ Font.size Tokens.fontSizeMd
            , Font.bold
            , Region.heading 6
            ]


{-| Render the Title as an `Element msg`
-}
toMarkup : Title msg -> Element msg
toMarkup (Title opts) =
    let
        attrs =
            levelAttrs opts.level
                ++ [ Font.color Tokens.colorText ]
                ++ opts.extraAttrs
    in
    Element.el attrs (Element.text opts.text)
