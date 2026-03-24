module PF6.Truncate exposing
    ( Truncate, TruncationMode
    , truncate
    , withMaxChars, withMiddleTruncation, withEndTruncation
    , toMarkup
    )

{-| PF6 Truncate component

Text truncation with a tooltip showing the full text on hover.

See: <https://www.patternfly.org/components/truncate>


# Definition

@docs Truncate, TruncationMode


# Constructor

@docs truncate


# Modifiers

@docs withMaxChars, withMiddleTruncation, withEndTruncation


# Rendering

@docs toMarkup

-}

import Element exposing (Element)
import Element.Font as Font
import Html.Attributes
import PF6.Tokens as Tokens


{-| Opaque Truncate type
-}
type Truncate msg
    = Truncate Options


{-| Truncation mode
-}
type TruncationMode
    = End
    | Middle


type alias Options =
    { text : String
    , maxChars : Int
    , mode : TruncationMode
    }


{-| Construct a Truncate with text content

    truncate "This is a very long text string that should be truncated"
        |> withMaxChars 20
        |> toMarkup

-}
truncate : String -> Truncate msg
truncate text =
    Truncate
        { text = text
        , maxChars = 20
        , mode = End
        }


{-| Set the maximum number of visible characters
-}
withMaxChars : Int -> Truncate msg -> Truncate msg
withMaxChars n (Truncate opts) =
    Truncate { opts | maxChars = n }


{-| Truncate from the middle (keeps start and end visible)
-}
withMiddleTruncation : Truncate msg -> Truncate msg
withMiddleTruncation (Truncate opts) =
    Truncate { opts | mode = Middle }


{-| Truncate from the end (default)
-}
withEndTruncation : Truncate msg -> Truncate msg
withEndTruncation (Truncate opts) =
    Truncate { opts | mode = End }


truncateText : Options -> String
truncateText opts =
    if String.length opts.text <= opts.maxChars then
        opts.text

    else
        case opts.mode of
            End ->
                String.left opts.maxChars opts.text ++ "\u{2026}"

            Middle ->
                let
                    half =
                        opts.maxChars // 2
                in
                String.left half opts.text
                    ++ "\u{2026}"
                    ++ String.right half opts.text


{-| Render the Truncate as an `Element msg`
-}
toMarkup : Truncate msg -> Element msg
toMarkup (Truncate opts) =
    let
        displayText =
            truncateText opts

        needsTruncation =
            String.length opts.text > opts.maxChars

        tooltipAttr =
            if needsTruncation then
                [ Element.htmlAttribute (Html.Attributes.title opts.text) ]

            else
                []
    in
    Element.el
        ([ Font.size Tokens.fontSizeMd
         , Font.color Tokens.colorText
         ]
            ++ tooltipAttr
        )
        (Element.text displayText)
