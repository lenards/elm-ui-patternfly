module Pages.SplitPage exposing (view)

import Element exposing (Element)
import Element.Background as Bg
import Element.Border as Border
import Element.Font as Font
import PF6.Card as Card
import PF6.Split as Split
import PF6.Title as Title
import PF6.Tokens as Tokens


view : Element msg
view =
    Element.column [ Element.width Element.fill, Element.spacing 24 ]
        [ Title.title "Split" |> Title.withH1 |> Title.toMarkup
        , Element.paragraph [ Font.size 14, Font.color Tokens.colorText ]
            [ Element.text "Split distributes items horizontally. One or more items can fill remaining horizontal space." ]
        , exampleSection "Basic split"
            (Split.split
                [ Split.splitItem (colorBox "Left" (Element.rgb255 200 220 255))
                , Split.splitItem (colorBox "Fill" (Element.rgb255 220 255 220))
                    |> Split.withFill
                , Split.splitItem (colorBox "Right" (Element.rgb255 255 220 200))
                ]
                |> Split.toMarkup
            )
        , exampleSection "Split with gutter"
            (Split.split
                [ Split.splitItem (colorBox "A" (Element.rgb255 200 220 255))
                , Split.splitItem (colorBox "B (fill)" (Element.rgb255 220 255 220))
                    |> Split.withFill
                , Split.splitItem (colorBox "C" (Element.rgb255 255 220 200))
                ]
                |> Split.withGutter
                |> Split.toMarkup
            )
        , exampleSection "Split with wrap"
            (Split.split
                [ Split.splitItem (colorBox "Item 1" (Element.rgb255 200 220 255))
                , Split.splitItem (colorBox "Item 2" (Element.rgb255 220 255 220))
                , Split.splitItem (colorBox "Item 3" (Element.rgb255 255 220 200))
                , Split.splitItem (colorBox "Item 4" (Element.rgb255 255 255 200))
                ]
                |> Split.withGutter
                |> Split.withWrap
                |> Split.toMarkup
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
