module Pages.StackPage exposing (view)

import Element exposing (Element)
import Element.Background as Bg
import Element.Border as Border
import Element.Font as Font
import PF6.Card as Card
import PF6.Stack as Stack
import PF6.Title as Title
import PF6.Tokens as Tokens


view : Element msg
view =
    Element.column [ Element.width Element.fill, Element.spacing 24 ]
        [ Title.title "Stack" |> Title.withH1 |> Title.toMarkup
        , Element.paragraph [ Font.size 14, Font.color Tokens.colorText ]
            [ Element.text "Stack arranges items vertically. One or more items can fill remaining vertical space." ]
        , exampleSection "Basic stack"
            (Element.el [ Element.width Element.fill, Element.height (Element.px 250) ]
                (Stack.stack
                    [ Stack.stackItem (colorBox "Header" (Element.rgb255 200 220 255))
                    , Stack.stackItem (colorBox "Content" (Element.rgb255 220 255 220))
                        |> Stack.withFill
                    , Stack.stackItem (colorBox "Footer" (Element.rgb255 255 220 200))
                    ]
                    |> Stack.toMarkup
                )
            )
        , exampleSection "Stack with gutter"
            (Element.el [ Element.width Element.fill, Element.height (Element.px 250) ]
                (Stack.stack
                    [ Stack.stackItem (colorBox "Top" (Element.rgb255 200 220 255))
                    , Stack.stackItem (colorBox "Fill area" (Element.rgb255 220 255 220))
                        |> Stack.withFill
                    , Stack.stackItem (colorBox "Bottom" (Element.rgb255 255 220 200))
                    ]
                    |> Stack.withGutter
                    |> Stack.toMarkup
                )
            )
        ]


colorBox : String -> Element.Color -> Element msg
colorBox label color =
    Element.el
        [ Bg.color color
        , Element.padding 16
        , Element.width Element.fill
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
