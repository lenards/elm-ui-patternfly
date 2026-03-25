module Pages.GridPage exposing (view)

import Element exposing (Element)
import Element.Background as Bg
import Element.Border as Border
import Element.Font as Font
import PF6.Card as Card
import PF6.Grid as Grid
import PF6.Theme as Theme exposing (Theme)
import PF6.Title as Title
import PF6.Tokens as Tokens


view : Theme -> Element msg
view theme =
    Element.column [ Element.width Element.fill, Element.spacing 24 ]
        [ Title.title "Grid" |> Title.withH1 |> Title.toMarkup theme
        , Element.paragraph [ Font.size 14, Font.color (Theme.text theme) ]
            [ Element.text "Grid provides a 12-column layout system. Each item specifies how many columns it spans." ]
        , exampleSection theme "12-column grid"
            (Grid.grid
                [ Grid.gridItem (colorBox theme "Span 12" (Element.rgb255 200 220 255))
                , Grid.gridItem (colorBox theme "Span 6" (Element.rgb255 220 255 220))
                    |> Grid.withSpan 6
                , Grid.gridItem (colorBox theme "Span 6" (Element.rgb255 255 220 200))
                    |> Grid.withSpan 6
                , Grid.gridItem (colorBox theme "Span 4" (Element.rgb255 255 255 200))
                    |> Grid.withSpan 4
                , Grid.gridItem (colorBox theme "Span 4" (Element.rgb255 200 255 255))
                    |> Grid.withSpan 4
                , Grid.gridItem (colorBox theme "Span 4" (Element.rgb255 255 200 255))
                    |> Grid.withSpan 4
                , Grid.gridItem (colorBox theme "Span 3" (Element.rgb255 200 220 255))
                    |> Grid.withSpan 3
                , Grid.gridItem (colorBox theme "Span 3" (Element.rgb255 220 255 220))
                    |> Grid.withSpan 3
                , Grid.gridItem (colorBox theme "Span 3" (Element.rgb255 255 220 200))
                    |> Grid.withSpan 3
                , Grid.gridItem (colorBox theme "Span 3" (Element.rgb255 255 255 200))
                    |> Grid.withSpan 3
                ]
                |> Grid.withGutter
                |> Grid.toMarkup theme
            )
        ]


colorBox : Theme -> String -> Element.Color -> Element msg
colorBox theme label color =
    Element.el
        [ Bg.color color
        , Element.padding 16
        , Element.width Element.fill
        , Font.size 14
        , Font.color (Theme.text theme)
        , Border.width 1
        , Border.color (Element.rgba 0 0 0 0.1)
        , Element.centerX
        ]
        (Element.text label)


exampleSection : Theme -> String -> Element msg -> Element msg
exampleSection theme title content =
    Card.card [ content ]
        |> Card.withTitle title
        |> Card.toMarkup theme
