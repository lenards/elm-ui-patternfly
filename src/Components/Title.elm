module Components.Title exposing
    ( Title
    , asH1
    , asH2
    , asH3
    , asH4
    , asH5
    , asH6
    , title
    , toMarkup
    , withExtraAttributes
    , withRgb
    , withSize2xl
    , withSize3xl
    , withSize4xl
    , withSizeLg
    , withSizeMd
    , withSizeXl
    )

import Element exposing (Element)
import Element.Font as Font
import Element.Region as Region


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


withSizeMd : Title msg -> Title msg
withSizeMd (Title options) =
    Title
        { options
            | size = Medium 16
            , header =
                Just <|
                    fromTextSize (Medium 16)
        }


withSizeLg : Title msg -> Title msg
withSizeLg (Title options) =
    Title
        { options
            | size = Large 18
            , header =
                Just <|
                    fromTextSize (Large 18)
        }


withSizeXl : Title msg -> Title msg
withSizeXl (Title options) =
    Title
        { options
            | size = ExtraLarge 20
            , header =
                Just <|
                    fromTextSize (ExtraLarge 20)
        }


withSize2xl : Title msg -> Title msg
withSize2xl (Title options) =
    Title
        { options
            | size = TwoXLarge 24
            , header =
                Just <|
                    fromTextSize (TwoXLarge 24)
        }


withSize3xl : Title msg -> Title msg
withSize3xl (Title options) =
    Title
        { options
            | size = ThreeXLarge 28
            , header =
                Just <|
                    fromTextSize (ThreeXLarge 28)
        }


withSize4xl : Title msg -> Title msg
withSize4xl (Title options) =
    Title
        { options
            | size = FourXLarge 36
            , header =
                Just <|
                    fromTextSize (FourXLarge 36)
        }


asH1 : Title msg -> Title msg
asH1 (Title options) =
    Title
        { options
            | header = Just 1
        }


asH2 : Title msg -> Title msg
asH2 (Title options) =
    Title
        { options
            | header = Just 2
        }


asH3 : Title msg -> Title msg
asH3 (Title options) =
    Title
        { options
            | header = Just 3
        }


asH4 : Title msg -> Title msg
asH4 (Title options) =
    Title
        { options
            | header = Just 4
        }


asH5 : Title msg -> Title msg
asH5 (Title options) =
    Title
        { options
            | header = Just 5
        }


asH6 : Title msg -> Title msg
asH6 (Title options) =
    Title
        { options
            | header = Just 6
        }


withRgb : Int -> Int -> Int -> Title msg -> Title msg
withRgb r g b (Title options) =
    Title
        { options
            | color = Element.rgb255 r g b
        }


withExtraAttributes : List (Element.Attribute msg) -> Title msg -> Title msg
withExtraAttributes extras (Title options) =
    Title { options | attributes = extras }


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
