module PF4.Title exposing
    ( Title
    , title
    , withRgb
    , asH1, asH2, asH3, asH4, asH5, asH6
    , TextSize, withSizeMd, withSizeLg, withSizeXl, withSize2xl, withSize3xl, withSize4xl
    , withExtraAttributes
    , toMarkup
    )

{-| A title component serving as a semantic header element

<https://www.patternfly.org/v4/components/title>


# Definition

@docs Title


# Constructor function

@docs title


# Configuration function(s)

@docs withRgb


# Modifier functions, HTML semantics

@docs asH1, asH2, asH3, asH4, asH5, asH6


# Modifier functions, text sizing

@docs TextSize, withSizeMd, withSizeLg, withSizeXl, withSize2xl, withSize3xl, withSize4xl


# "Escape Hatch" for adding `Element.Attribute msg`

@docs withExtraAttributes


# Rendering element

@docs toMarkup

-}

import Element exposing (Element)
import Element.Font as Font
import Element.Region as Region


{-| Opaque `Title` element that can produce `msg` messages
-}
type Title msg
    = Title (Options msg)


type alias Options msg =
    { size : TextSize
    , text : String
    , color : Element.Color
    , attributes : List (Element.Attribute msg)
    , header : Maybe Int
    }


{-| Defined a vertical rhythm of text sizing

We may want to have some approach to doing a `scaled` definition of
these sizes from a relative measure, a la `rem` units in CSS.

Borrowed from the `elm-ui` documentation:

```
scaled : Int -> Float
scaled =
    Element.modular 16 1.25
```

So we'd allow you to pass in a defined "hierarchy" that would map the
TextSize values to the respective `Int` value.

-}
type TextSize
    = Medium Int
    | Large Int
    | ExtraLarge Int
    | TwoXLarge Int
    | ThreeXLarge Int
    | FourXLarge Int


defaultColor : Element.Color
defaultColor =
    Element.rgb255 21 21 21


getSize : TextSize -> Int
getSize textSize =
    case textSize of
        Medium size ->
            size

        Large size ->
            size

        ExtraLarge size ->
            size

        TwoXLarge size ->
            size

        ThreeXLarge size ->
            size

        FourXLarge size ->
            size


fromTextSize : TextSize -> Int
fromTextSize textSize =
    case textSize of
        Medium _ ->
            4

        Large _ ->
            3

        ExtraLarge _ ->
            2

        TwoXLarge _ ->
            1

        ThreeXLarge _ ->
            1

        FourXLarge _ ->
            1


{-| Configure text size to Md, or medium
-}
withSizeMd : Title msg -> Title msg
withSizeMd (Title options) =
    Title
        { options
            | size = Medium 16
            , header =
                Just <|
                    fromTextSize (Medium 16)
        }


{-| Configure text size to Lg, or large
-}
withSizeLg : Title msg -> Title msg
withSizeLg (Title options) =
    Title
        { options
            | size = Large 18
            , header =
                Just <|
                    fromTextSize (Large 18)
        }


{-| Configure text size to XL
-}
withSizeXl : Title msg -> Title msg
withSizeXl (Title options) =
    Title
        { options
            | size = ExtraLarge 20
            , header =
                Just <|
                    fromTextSize (ExtraLarge 20)
        }


{-| Configure text size to 2XL
-}
withSize2xl : Title msg -> Title msg
withSize2xl (Title options) =
    Title
        { options
            | size = TwoXLarge 24
            , header =
                Just <|
                    fromTextSize (TwoXLarge 24)
        }


{-| Configure text size to 3XL
-}
withSize3xl : Title msg -> Title msg
withSize3xl (Title options) =
    Title
        { options
            | size = ThreeXLarge 28
            , header =
                Just <|
                    fromTextSize (ThreeXLarge 28)
        }


{-| Configure text size to 4XL
-}
withSize4xl : Title msg -> Title msg
withSize4xl (Title options) =
    Title
        { options
            | size = FourXLarge 36
            , header =
                Just <|
                    fromTextSize (FourXLarge 36)
        }


{-| Alters semantics to appear as a `Element.Region.heading 1`
-}
asH1 : Title msg -> Title msg
asH1 (Title options) =
    Title
        { options
            | header = Just 1
        }


{-| Alters semantics to appear as a `Element.Region.heading 2`
-}
asH2 : Title msg -> Title msg
asH2 (Title options) =
    Title
        { options
            | header = Just 2
        }


{-| Alters semantics to appear as a `Element.Region.heading 3`
-}
asH3 : Title msg -> Title msg
asH3 (Title options) =
    Title
        { options
            | header = Just 3
        }


{-| Alters semantics to appear as a `Element.Region.heading 4`
-}
asH4 : Title msg -> Title msg
asH4 (Title options) =
    Title
        { options
            | header = Just 4
        }


{-| Alters semantics to appear as a `Element.Region.heading 5`
-}
asH5 : Title msg -> Title msg
asH5 (Title options) =
    Title
        { options
            | header = Just 5
        }


{-| Alters semantics to appear as a `Element.Region.heading 6`
-}
asH6 : Title msg -> Title msg
asH6 (Title options) =
    Title
        { options
            | header = Just 6
        }


{-| Changes the color of the text
-}
withRgb : Int -> Int -> Int -> Title msg -> Title msg
withRgb r g b (Title options) =
    Title
        { options
            | color = Element.rgb255 r g b
        }


{-| Adds a list of `Element.Attributes` to the element
-}
withExtraAttributes : List (Element.Attribute msg) -> Title msg -> Title msg
withExtraAttributes extras (Title options) =
    Title { options | attributes = extras }


{-| Constructs a `Title` element without any attributes

The default `Size` is `Medium 16`, use the various sizing
configuration `with` functions to alter it.

-}
title : String -> Title msg
title text =
    Title
        { size = Medium 16
        , text = text
        , color = defaultColor
        , attributes = []
        , header = Nothing
        }


nothingAttr : Element.Attribute msg
nothingAttr =
    Element.none |> Element.below


getHeader : Maybe Int -> Element.Attribute msg
getHeader maybeHeader =
    maybeHeader
        |> Maybe.map (\h -> Region.heading h)
        |> Maybe.withDefault nothingAttr


{-| Given the custom type representation, renders as an `Element msg`.
-}
toMarkup : Title msg -> Element msg
toMarkup (Title options) =
    let
        attrs_ =
            [ getHeader options.header
            , Font.bold
            , Font.color options.color
            , Font.size
                (options.size
                    |> getSize
                )
            ]
                ++ options.attributes
    in
    Element.el attrs_ <| Element.text options.text
