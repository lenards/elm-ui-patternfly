module Pages.SplitPage exposing (view)

import Element exposing (Element)
import Element.Background as Bg
import Element.Border as Border
import Element.Font as Font
import PF6.Card as Card
import PF6.Split as Split
import PF6.Theme as Theme exposing (Theme)
import PF6.Title as Title
import PF6.Tokens as Tokens


view : Theme -> Element msg
view theme =
    Element.column [ Element.width Element.fill, Element.spacing 24 ]
        [ Title.title "Split" |> Title.withH1 |> Title.toMarkup theme
        , Element.paragraph [ Font.size 14, Font.color (Theme.text theme) ]
            [ Element.text "Split distributes items horizontally. One or more items can fill remaining horizontal space." ]
        , exampleSection theme "Basic split"
            (Split.split
                [ Split.splitItem (colorBox theme "Left" (Element.rgb255 200 220 255))
                , Split.splitItem (colorBox theme "Fill" (Element.rgb255 220 255 220))
                    |> Split.withFill
                , Split.splitItem (colorBox theme "Right" (Element.rgb255 255 220 200))
                ]
                |> Split.toMarkup theme
            )
        , exampleSection theme "Split with gutter"
            (Split.split
                [ Split.splitItem (colorBox theme "A" (Element.rgb255 200 220 255))
                , Split.splitItem (colorBox theme "B (fill)" (Element.rgb255 220 255 220))
                    |> Split.withFill
                , Split.splitItem (colorBox theme "C" (Element.rgb255 255 220 200))
                ]
                |> Split.withGutter
                |> Split.toMarkup theme
            )
        , exampleSection theme "Split with wrap"
            (Split.split
                [ Split.splitItem (colorBox theme "Item 1" (Element.rgb255 200 220 255))
                , Split.splitItem (colorBox theme "Item 2" (Element.rgb255 220 255 220))
                , Split.splitItem (colorBox theme "Item 3" (Element.rgb255 255 220 200))
                , Split.splitItem (colorBox theme "Item 4" (Element.rgb255 255 255 200))
                ]
                |> Split.withGutter
                |> Split.withWrap
                |> Split.toMarkup theme
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
