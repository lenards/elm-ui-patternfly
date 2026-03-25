module Pages.CardPage exposing (view)

import Element exposing (Element)
import Element.Font as Font
import PF6.Card as Card
import PF6.Title as Title
import PF6.Tokens as Tokens


view : Element msg
view =
    Element.column [ Element.width Element.fill, Element.spacing 24 ]
        [ Title.title "Card" |> Title.withH1 |> Title.toMarkup
        , Element.paragraph [ Font.size 14, Font.color Tokens.colorText ]
            [ Element.text "Cards are rectangular containers that group related content and actions." ]
        , exampleSection "Basic card"
            (Card.card
                [ Element.paragraph [ Font.size 14 ]
                    [ Element.text "This is a basic card with a title and body content. Cards symbolize units of information." ]
                ]
                |> Card.withTitle "Card title"
                |> Card.toMarkup
            )
        , exampleSection "Card with footer"
            (Card.card
                [ Element.paragraph [ Font.size 14 ]
                    [ Element.text "This card includes a footer area below the body." ]
                ]
                |> Card.withTitle "With footer"
                |> Card.withFooter
                    (Element.el [ Font.size 13, Font.color Tokens.colorTextSubtle ]
                        (Element.text "Footer content")
                    )
                |> Card.toMarkup
            )
        , exampleSection "Card variants"
            (Element.wrappedRow [ Element.spacing 16 ]
                [ Element.el [ Element.width (Element.px 240) ]
                    (Card.card
                        [ Element.text "Compact card with less padding." ]
                        |> Card.withTitle "Compact"
                        |> Card.withCompact
                        |> Card.toMarkup
                    )
                , Element.el [ Element.width (Element.px 240) ]
                    (Card.card
                        [ Element.text "Flat card with no shadow." ]
                        |> Card.withTitle "Flat"
                        |> Card.withFlat
                        |> Card.toMarkup
                    )
                , Element.el [ Element.width (Element.px 240) ]
                    (Card.card
                        [ Element.text "Rounded card with larger border radius." ]
                        |> Card.withTitle "Rounded"
                        |> Card.withRounded
                        |> Card.toMarkup
                    )
                ]
            )
        ]


exampleSection : String -> Element msg -> Element msg
exampleSection title content =
    Card.card [ content ]
        |> Card.withTitle title
        |> Card.toMarkup
