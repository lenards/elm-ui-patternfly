module Pages.StackPage exposing (view)

import Element exposing (Element)
import Element.Background as Bg
import Element.Border as Border
import Element.Font as Font
import PF6.Card as Card
import PF6.Stack as Stack
import PF6.Theme as Theme exposing (Theme)
import PF6.Title as Title
import PF6.Tokens as Tokens


view : Theme -> Element msg
view theme =
    Element.column [ Element.width Element.fill, Element.spacing 24 ]
        [ Title.title "Stack" |> Title.withH1 |> Title.toMarkup theme
        , Element.paragraph [ Font.size 14, Font.color (Theme.text theme) ]
            [ Element.text "Stack arranges items vertically. One or more items can fill remaining vertical space." ]
        , exampleSection theme "Basic stack"
            (Element.el [ Element.width Element.fill, Element.height (Element.px 250) ]
                (Stack.stack
                    [ Stack.stackItem (colorBox theme "Header" (Element.rgb255 200 220 255))
                    , Stack.stackItem (colorBox theme "Content" (Element.rgb255 220 255 220))
                        |> Stack.withFill
                    , Stack.stackItem (colorBox theme "Footer" (Element.rgb255 255 220 200))
                    ]
                    |> Stack.toMarkup theme
                )
            )
        , exampleSection theme "Stack with gutter"
            (Element.el [ Element.width Element.fill, Element.height (Element.px 250) ]
                (Stack.stack
                    [ Stack.stackItem (colorBox theme "Top" (Element.rgb255 200 220 255))
                    , Stack.stackItem (colorBox theme "Fill area" (Element.rgb255 220 255 220))
                        |> Stack.withFill
                    , Stack.stackItem (colorBox theme "Bottom" (Element.rgb255 255 220 200))
                    ]
                    |> Stack.withGutter
                    |> Stack.toMarkup theme
                )
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
        ]
        (Element.text label)


exampleSection : Theme -> String -> Element msg -> Element msg
exampleSection theme title content =
    Card.card [ content ]
        |> Card.withTitle title
        |> Card.toMarkup theme
