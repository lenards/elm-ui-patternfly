module PF6.Card exposing
    ( Card
    , card
    , withTitle, withFooter, withActions
    , withSelectable, withSelected, withFlat, withCompact, withRounded
    , withBodyPadding, withBodyPaddingXY, withBodySpacing
    , toMarkup
    )

{-| PF6 Card component

A card is a square or rectangular container that can contain any kind of content.
Cards symbolize units of information, and each one acts as an entry point for users to access more details.

See: <https://www.patternfly.org/components/card>


# Definition

@docs Card


# Constructor

@docs card


# Header & Footer

@docs withTitle, withFooter, withActions


# Variant modifiers

@docs withSelectable, withSelected, withFlat, withCompact, withRounded


# Layout modifiers

@docs withBodyPadding, withBodyPaddingXY, withBodySpacing


# Rendering

@docs toMarkup

-}

import Element exposing (Attribute, Element)
import Element.Background as Bg
import Element.Border as Border
import Element.Font as Font
import Html.Attributes
import PF6.Theme as Theme exposing (Theme)
import PF6.Tokens as Tokens


{-| Opaque Card type
-}
type Card msg
    = Card (Options msg)


type alias Options msg =
    { title : Maybe String
    , body : List (Element msg)
    , footer : Maybe (Element msg)
    , actions : Maybe (Element msg)
    , isSelectable : Bool
    , isSelected : Bool
    , isFlat : Bool
    , isCompact : Bool
    , isRounded : Bool
    , bodyPadding : Attribute msg
    , bodySpacing : Attribute msg
    }


defaultOptions : List (Element msg) -> Options msg
defaultOptions body =
    { title = Nothing
    , body = body
    , footer = Nothing
    , actions = Nothing
    , isSelectable = False
    , isSelected = False
    , isFlat = False
    , isCompact = False
    , isRounded = False
    , bodyPadding = Element.padding Tokens.spacerMd
    , bodySpacing = Element.spacing Tokens.spacerSm
    }


{-| Construct a Card with body content
-}
card : List (Element msg) -> Card msg
card body =
    Card (defaultOptions body)


{-| Add a title to the card header
-}
withTitle : String -> Card msg -> Card msg
withTitle t (Card opts) =
    Card { opts | title = Just t }


{-| Add footer content
-}
withFooter : Element msg -> Card msg -> Card msg
withFooter el (Card opts) =
    Card { opts | footer = Just el }


{-| Add actions element to the card header (top-right)
-}
withActions : Element msg -> Card msg -> Card msg
withActions el (Card opts) =
    Card { opts | actions = Just el }


{-| Make the card selectable (adds hover/cursor pointer behavior)
-}
withSelectable : Card msg -> Card msg
withSelectable (Card opts) =
    Card { opts | isSelectable = True }


{-| Mark the card as currently selected
-}
withSelected : Card msg -> Card msg
withSelected (Card opts) =
    Card { opts | isSelected = True }


{-| Flat card — no box shadow
-}
withFlat : Card msg -> Card msg
withFlat (Card opts) =
    Card { opts | isFlat = True }


{-| Compact card — reduced padding
-}
withCompact : Card msg -> Card msg
withCompact (Card opts) =
    Card { opts | isCompact = True }


{-| Rounded card — larger border radius
-}
withRounded : Card msg -> Card msg
withRounded (Card opts) =
    Card { opts | isRounded = True }


{-| Set body padding
-}
withBodyPadding : Int -> Card msg -> Card msg
withBodyPadding p (Card opts) =
    Card { opts | bodyPadding = Element.padding p }


{-| Set body padding on x and y axes
-}
withBodyPaddingXY : Int -> Int -> Card msg -> Card msg
withBodyPaddingXY x y (Card opts) =
    Card { opts | bodyPadding = Element.paddingXY x y }


{-| Set spacing between body elements
-}
withBodySpacing : Int -> Card msg -> Card msg
withBodySpacing s (Card opts) =
    Card { opts | bodySpacing = Element.spacing s }


headerMarkup : Theme -> Options msg -> Element msg
headerMarkup theme opts =
    case ( opts.title, opts.actions ) of
        ( Nothing, Nothing ) ->
            Element.none

        _ ->
            let
                titleEl =
                    opts.title
                        |> Maybe.map
                            (\t ->
                                Element.el
                                    [ Font.bold
                                    , Font.size Tokens.fontSizeLg
                                    , Font.color (Theme.text theme)
                                    ]
                                    (Element.text t)
                            )
                        |> Maybe.withDefault Element.none

                actionsEl =
                    opts.actions |> Maybe.withDefault Element.none
            in
            Element.row
                [ Element.width Element.fill
                , Element.padding
                    (if opts.isCompact then
                        Tokens.spacerSm

                     else
                        Tokens.spacerMd
                    )
                , Border.widthEach { top = 0, right = 0, bottom = 1, left = 0 }
                , Border.color (Theme.borderSubtle theme)
                ]
                [ Element.el [ Element.width Element.fill ] titleEl
                , actionsEl
                ]


footerMarkup : Theme -> Options msg -> Element msg
footerMarkup theme opts =
    case opts.footer of
        Nothing ->
            Element.none

        Just el ->
            Element.el
                [ Element.width Element.fill
                , Element.padding
                    (if opts.isCompact then
                        Tokens.spacerSm

                     else
                        Tokens.spacerMd
                    )
                , Border.widthEach { top = 1, right = 0, bottom = 0, left = 0 }
                , Border.color (Theme.borderSubtle theme)
                ]
                el


{-| Render the Card as an `Element msg`
-}
toMarkup : Theme -> Card msg -> Element msg
toMarkup theme (Card opts) =
    let
        radius =
            if opts.isRounded then
                Tokens.radiusLg

            else
                Tokens.radiusMd

        borderColor =
            if opts.isSelected then
                Theme.primary theme

            else
                Theme.borderDefault theme

        borderWidth =
            if opts.isSelected then
                2

            else
                1

        shadowAttr =
            if opts.isFlat then
                []

            else
                [ Element.htmlAttribute
                    (Html.Attributes.style "box-shadow" "0 0.25rem 0.5rem 0rem rgba(3,3,3,0.12), 0 0 0.25rem 0 rgba(3,3,3,0.06)")
                ]

        bodyPad =
            if opts.isCompact then
                Element.padding Tokens.spacerSm

            else
                opts.bodyPadding
    in
    Element.column
        ([ Element.width Element.fill
         , Bg.color (Theme.backgroundDefault theme)
         , Border.rounded radius
         , Border.solid
         , Border.width borderWidth
         , Border.color borderColor
         , opts.bodySpacing
         ]
            ++ shadowAttr
        )
        [ headerMarkup theme opts
        , Element.column
            [ Element.width Element.fill
            , bodyPad
            , opts.bodySpacing
            ]
            opts.body
        , footerMarkup theme opts
        ]
