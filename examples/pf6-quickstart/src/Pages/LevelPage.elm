module Pages.LevelPage exposing (view)

import Element exposing (Element)
import Element.Background as Bg
import Element.Border as Border
import Element.Font as Font
import PF6.Card as Card
import PF6.Level as Level
import PF6.Theme as Theme exposing (Theme)
import PF6.Title as Title
import PF6.Tokens as Tokens


view : Theme -> Element msg
view theme =
    Element.column [ Element.width Element.fill, Element.spacing 24 ]
        [ Title.title "Level" |> Title.withH1 |> Title.toMarkup theme
        , Element.paragraph [ Font.size 14, Font.color (Theme.text theme) ]
            [ Element.text "Level distributes items evenly across a horizontal row with space-between justification." ]
        , exampleSection theme "Basic level"
            (Level.level
                [ colorBox theme "Left item" (Element.rgb255 200 220 255)
                , colorBox theme "Center item" (Element.rgb255 220 255 220)
                , colorBox theme "Right item" (Element.rgb255 255 220 200)
                ]
                |> Level.toMarkup theme
            )
        , exampleSection theme "With gutter"
            (Level.level
                [ colorBox theme "Item A" (Element.rgb255 255 255 200)
                , colorBox theme "Item B" (Element.rgb255 200 255 255)
                ]
                |> Level.withGutter
                |> Level.toMarkup theme
            )
        ]


colorBox : Theme -> String -> Element.Color -> Element msg
colorBox theme label color =
    Element.el
        [ Bg.color color
        , Element.padding 16
        , Font.size 14
        , Font.color (Theme.text theme)
        , Border.width 1
        , Border.color (Element.rgba 0 0 0 0.1)
        ]
        (Element.text label)


exampleSection : Theme -> String -> Element msg -> Element msg
exampleSection theme title content =
    Card.card [ content ]
        |> Card.withTitle title
        |> Card.toMarkup theme
