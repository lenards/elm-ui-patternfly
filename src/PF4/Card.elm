module PF4.Card exposing (..)

import Element exposing (Element)
import Element.Font as Font
import PF4.Title as Title


type Card msg
    = Card (Options msg)


type alias Options msg =
    { header : Maybe (CardHeader msg)
    , body : List (Element msg)
    , footer : Maybe (Element msg)
    }


type CardHeader msg
    = Header (HeaderOptions msg)


type alias HeaderOptions msg =
    { title : Maybe (Title.Title msg)
    , actions : Maybe (Element msg)
    }


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
        , body = body
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
            , Element.spacing 8
            ]
    in
    Element.column attrs_ <|
        (options.header |> headerMarkup)
            :: options.body
