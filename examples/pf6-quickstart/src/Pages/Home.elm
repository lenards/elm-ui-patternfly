module Pages.Home exposing (view)

import Element exposing (Element)
import Element.Font as Font
import PF6.Card as Card
import PF6.Title as Title
import PF6.Tokens as Tokens


view : Element msg
view =
    Element.column [ Element.width Element.fill, Element.spacing 32 ]
        [ Element.column [ Element.spacing 8 ]
            [ Title.title "PatternFly 6 Quickstart"
                |> Title.withH1
                |> Title.toMarkup
            , Element.paragraph
                [ Font.size 18, Font.color Tokens.colorTextSubtle ]
                [ Element.text "An elm-ui component showcase" ]
            ]
        , Element.paragraph [ Font.size 14, Font.color Tokens.colorText ]
            [ Element.text "This quickstart demonstrates PatternFly 6 components built with "
            , Element.el [ Font.bold ] (Element.text "elm-ui")
            , Element.text ". Each component has its own page with interactive examples. Use the sidebar to navigate between components and layouts."
            ]
        , Element.wrappedRow [ Element.spacing 16 ]
            [ statCard "73" "Components"
            , statCard "7" "Layouts"
            , statCard "0.19.1" "Elm Version"
            ]
        , Title.title "Featured Components"
            |> Title.withH2
            |> Title.toMarkup
        , Element.wrappedRow [ Element.spacing 16 ]
            [ featureCard "button" "Button" "Trigger actions with various styles and sizes."
            , featureCard "card" "Card" "Rectangular containers for grouped content."
            , featureCard "table" "Table" "Organize data in sortable rows and columns."
            , featureCard "alert" "Alert" "Communicate status with contextual messages."
            , featureCard "modal" "Modal" "Present content in an overlay dialog."
            , featureCard "accordion" "Accordion" "Toggle visibility of content sections."
            ]
        ]


statCard : String -> String -> Element msg
statCard value label =
    Card.card
        [ Element.column
            [ Element.centerX
            , Element.spacing 4
            , Element.padding 8
            ]
            [ Element.el
                [ Font.size 36
                , Font.bold
                , Font.color Tokens.colorPrimary
                , Element.centerX
                ]
                (Element.text value)
            , Element.el
                [ Font.size 14
                , Font.color Tokens.colorTextSubtle
                , Element.centerX
                ]
                (Element.text label)
            ]
        ]
        |> Card.withCompact
        |> Card.toMarkup


featureCard : String -> String -> String -> Element msg
featureCard fragment title description =
    Element.el [ Element.width (Element.px 280) ]
        (Card.card
            [ Element.paragraph [ Font.size 14, Font.color Tokens.colorText ]
                [ Element.text description ]
            ]
            |> Card.withTitle title
            |> Card.withFooter
                (Element.el
                    [ Font.size 13
                    , Font.color Tokens.colorPrimary
                    , Font.underline
                    , Element.pointer
                    ]
                    (Element.text ("View " ++ title ++ " examples"))
                )
            |> Card.toMarkup
        )
