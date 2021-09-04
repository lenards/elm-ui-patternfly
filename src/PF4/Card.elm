module PF4.Card exposing
    ( Card
    , asTitleIn
    , card
    , toMarkup
    , withBodyPadding
    , withBodyPaddingEach
    , withBodyPaddingXY
    , withBodySpaceEvenly
    , withBodySpacing
    , withBodySpacingXY
    , withFooter
    , withTitle
    )

import Element exposing (Attribute, Element)
import Element.Font as Font
import PF4.Title as Title


type Card msg
    = Card (Options msg)


type alias Options msg =
    { header : Maybe (CardHeader msg)
    , body : BodyOptions msg
    , footer : Maybe (Element msg)
    }


type CardHeader msg
    = Header (HeaderOptions msg)


type alias HeaderOptions msg =
    { title : Maybe (Title.Title msg)
    , actions : Maybe (Element msg)
    }


type alias BodyOptions msg =
    { contents : List (Element msg)
    , spacing : Attribute msg
    , padding : Attribute msg
    }


defaultBodySpacing : Attribute msg
defaultBodySpacing =
    Element.spacing 8


noPadding : Attribute msg
noPadding =
    Element.padding 0


defaultBody : List (Element msg) -> BodyOptions msg
defaultBody body =
    { contents = body
    , spacing = defaultBodySpacing
    , padding = noPadding
    }


getBodyAttributes : BodyOptions msg -> List (Attribute msg)
getBodyAttributes options =
    [ options.spacing, options.padding ]


blankHeaderOptions : HeaderOptions msg
blankHeaderOptions =
    { title = Nothing, actions = Nothing }


defaultTitle : String -> Title.Title msg
defaultTitle text =
    Title.title text
        |> Title.withExtraAttributes
            [ Font.extraBold ]
        |> Title.withSizeLg


card : List (Element msg) -> Card msg
card body =
    Card
        { header = Nothing
        , body = defaultBody body
        , footer = Nothing
        }


withTitle : String -> Card msg -> Card msg
withTitle heading (Card options) =
    Card
        { options
            | header =
                heading
                    |> defaultTitle
                    |> asTitleIn blankHeaderOptions
                    |> Header
                    |> Just
        }


withFooter : Element msg -> Card msg -> Card msg
withFooter element (Card options) =
    Card { options | footer = Just element }


asTitleIn : HeaderOptions msg -> Title.Title msg -> HeaderOptions msg
asTitleIn options newTitle =
    { options | title = Just newTitle }


withBodySpacing : Int -> Card msg -> Card msg
withBodySpacing spacingValue card_ =
    card_ |> updateBodySpacing_ (Element.spacing spacingValue)


withBodySpacingXY : Int -> Int -> Card msg -> Card msg
withBodySpacingXY spacingX spacingY card_ =
    card_ |> updateBodySpacing_ (Element.spacingXY spacingX spacingY)


withBodySpaceEvenly : Card msg -> Card msg
withBodySpaceEvenly card_ =
    card_ |> updateBodySpacing_ Element.spaceEvenly


updateBodySpacing_ : Attribute msg -> Card msg -> Card msg
updateBodySpacing_ spacingAttr (Card option) =
    let
        bodyOptions =
            option.body
    in
    Card
        { option
            | body = { bodyOptions | spacing = spacingAttr }
        }


withBodyPadding : Int -> Card msg -> Card msg
withBodyPadding paddingValue card_ =
    card_ |> updateBodyPadding_ (Element.padding paddingValue)


withBodyPaddingXY : Int -> Int -> Card msg -> Card msg
withBodyPaddingXY paddingX paddingY card_ =
    card_ |> updateBodyPadding_ (Element.paddingXY paddingX paddingY)


withBodyPaddingEach :
    { top : Int
    , right : Int
    , bottom : Int
    , left : Int
    }
    -> Card msg
    -> Card msg
withBodyPaddingEach paddingEach card_ =
    card_ |> updateBodyPadding_ (Element.paddingEach paddingEach)


updateBodyPadding_ : Attribute msg -> Card msg -> Card msg
updateBodyPadding_ paddingAttr (Card option) =
    let
        bodyOptions =
            option.body
    in
    Card
        { option
            | body = { bodyOptions | padding = paddingAttr }
        }


headerMarkup : Maybe (CardHeader msg) -> Element msg
headerMarkup mCardHeader =
    let
        markup_ (Header options) =
            Element.row [] <|
                [ options.title
                    |> Maybe.map
                        (\t ->
                            Title.toMarkup t
                        )
                    |> Maybe.withDefault
                        Element.none
                ]
    in
    mCardHeader
        |> Maybe.map markup_
        |> Maybe.withDefault
            Element.none


toMarkup : Card msg -> Element msg
toMarkup (Card options) =
    let
        attrs_ =
            [ Element.width Element.fill
            , Element.height Element.fill
            ]
                ++ getBodyAttributes options.body
    in
    Element.column attrs_ <|
        (options.header |> headerMarkup)
            :: options.body.contents
