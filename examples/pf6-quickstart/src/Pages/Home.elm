module Pages.Home exposing (view)

import Element exposing (Element)
import Element.Font as Font
import PF6.Card as Card
import PF6.Theme as Theme exposing (Theme)
import PF6.Title as Title
import PF6.Tokens as Tokens


view : Theme -> Element msg
view theme =
    Element.column [ Element.width Element.fill, Element.spacing 32 ]
        [ Element.column [ Element.spacing 8 ]
            [ Title.title "PatternFly 6 Quickstart"
                |> Title.withH1
                |> Title.toMarkup theme
            , Element.paragraph
                [ Font.size 18, Font.color (Theme.textSubtle theme) ]
                [ Element.text "An elm-ui component showcase" ]
            ]
        , Element.paragraph [ Font.size 14, Font.color (Theme.text theme) ]
            [ Element.text "This quickstart demonstrates PatternFly 6 components built with "
            , Element.el [ Font.bold ] (Element.text "elm-ui")
            , Element.text ". Each component has its own page with interactive examples. Use the sidebar to navigate between components and layouts."
            ]
        , Element.wrappedRow [ Element.spacing 16 ]
            [ statCard theme "73" "Components"
            , statCard theme "7" "Layouts"
            , statCard theme "0.19.1" "Elm Version"
            ]
        , Title.title "Featured Components"
            |> Title.withH2
            |> Title.toMarkup theme
        , Element.wrappedRow [ Element.spacing 16 ]
            [ featureCard theme "button" "Button" "Trigger actions with various styles and sizes."
            , featureCard theme "card" "Card" "Rectangular containers for grouped content."
            , featureCard theme "table" "Table" "Organize data in sortable rows and columns."
            , featureCard theme "alert" "Alert" "Communicate status with contextual messages."
            , featureCard theme "modal" "Modal" "Present content in an overlay dialog."
            , featureCard theme "accordion" "Accordion" "Toggle visibility of content sections."
            ]
        ]


statCard : Theme -> String -> String -> Element msg
statCard theme value label =
    Card.card
        [ Element.column
            [ Element.centerX
            , Element.spacing 4
            , Element.padding 8
            ]
            [ Element.el
                [ Font.size 36
                , Font.bold
                , Font.color (Theme.primary theme)
                , Element.centerX
                ]
                (Element.text value)
            , Element.el
                [ Font.size 14
                , Font.color (Theme.textSubtle theme)
                , Element.centerX
                ]
                (Element.text label)
            ]
        ]
        |> Card.withCompact
        |> Card.toMarkup theme


featureCard : Theme -> String -> String -> String -> Element msg
featureCard theme fragment title description =
    Element.el [ Element.width (Element.px 280) ]
        (Card.card
            [ Element.paragraph [ Font.size 14, Font.color (Theme.text theme) ]
                [ Element.text description ]
            ]
            |> Card.withTitle title
            |> Card.withFooter
                (Element.el
                    [ Font.size 13
                    , Font.color (Theme.primary theme)
                    , Font.underline
                    , Element.pointer
                    ]
                    (Element.text ("View " ++ title ++ " examples"))
                )
            |> Card.toMarkup theme
        )
