module Pages.FlexPage exposing (view)

import Element exposing (Element)
import Element.Background as Bg
import Element.Border as Border
import Element.Font as Font
import PF6.Card as Card
import PF6.Flex as Flex
import PF6.Title as Title
import PF6.Tokens as Tokens


view : Element msg
view =
    Element.column [ Element.width Element.fill, Element.spacing 24 ]
        [ Title.title "Flex" |> Title.withH1 |> Title.toMarkup
        , Element.paragraph [ Font.size 14, Font.color Tokens.colorText ]
            [ Element.text "Flex provides a flexible layout with configurable direction, alignment, justification, wrapping, and gap." ]
        , exampleSection "Row (default)"
            (Flex.flex
                [ Flex.flexItem (colorBox "Item 1" (Element.rgb255 200 220 255))
                , Flex.flexItem (colorBox "Item 2" (Element.rgb255 220 255 220))
                , Flex.flexItem (colorBox "Item 3" (Element.rgb255 255 220 200))
                ]
                |> Flex.withGapMd
                |> Flex.toMarkup
            )
        , exampleSection "Column"
            (Flex.flex
                [ Flex.flexItem (colorBox "Item 1" (Element.rgb255 200 220 255))
                , Flex.flexItem (colorBox "Item 2" (Element.rgb255 220 255 220))
                , Flex.flexItem (colorBox "Item 3" (Element.rgb255 255 220 200))
                ]
                |> Flex.withColumn
                |> Flex.withGapMd
                |> Flex.toMarkup
            )
        , exampleSection "Justify space between"
            (Flex.flex
                [ Flex.flexItem (colorBox "Left" (Element.rgb255 200 220 255))
                , Flex.flexItem (colorBox "Center" (Element.rgb255 220 255 220))
                , Flex.flexItem (colorBox "Right" (Element.rgb255 255 220 200))
                ]
                |> Flex.withJustifySpaceBetween
                |> Flex.toMarkup
            )
        , exampleSection "Align center"
            (Element.el [ Element.height (Element.px 100), Element.width Element.fill ]
                (Flex.flex
                    [ Flex.flexItem (colorBox "Centered" (Element.rgb255 255 255 200))
                    ]
                    |> Flex.withAlignCenter
                    |> Flex.withJustifyCenter
                    |> Flex.toMarkup
                )
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
