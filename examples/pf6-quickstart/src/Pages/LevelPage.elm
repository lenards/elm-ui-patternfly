module Pages.LevelPage exposing (view)

import Element exposing (Element)
import Element.Background as Bg
import Element.Border as Border
import Element.Font as Font
import PF6.Card as Card
import PF6.Level as Level
import PF6.Title as Title
import PF6.Tokens as Tokens


view : Element msg
view =
    Element.column [ Element.width Element.fill, Element.spacing 24 ]
        [ Title.title "Level" |> Title.withH1 |> Title.toMarkup
        , Element.paragraph [ Font.size 14, Font.color Tokens.colorText ]
            [ Element.text "Level distributes items evenly across a horizontal row with space-between justification." ]
        , exampleSection "Basic level"
            (Level.level
                [ colorBox "Left item" (Element.rgb255 200 220 255)
                , colorBox "Center item" (Element.rgb255 220 255 220)
                , colorBox "Right item" (Element.rgb255 255 220 200)
                ]
                |> Level.toMarkup
            )
        , exampleSection "With gutter"
            (Level.level
                [ colorBox "Item A" (Element.rgb255 255 255 200)
                , colorBox "Item B" (Element.rgb255 200 255 255)
                ]
                |> Level.withGutter
                |> Level.toMarkup
            )
        ]


colorBox : String -> Element.Color -> Element msg
colorBox label color =
    Element.el
        [ Bg.color color
        , Element.padding 16
        , Font.size 14
        , Font.color Tokens.colorText
        , Border.width 1
        , Border.color (Element.rgba 0 0 0 0.1)
        ]
        (Element.text label)


exampleSection : String -> Element msg -> Element msg
exampleSection title content =
    Card.card [ content ]
        |> Card.withTitle title
        |> Card.toMarkup
