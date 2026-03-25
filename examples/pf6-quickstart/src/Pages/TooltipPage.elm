module Pages.TooltipPage exposing (view)

import Element exposing (Element)
import Element.Font as Font
import PF6.Button as Button
import PF6.Card as Card
import PF6.Theme as Theme exposing (Theme)
import PF6.Title as Title
import PF6.Tokens as Tokens
import PF6.Tooltip as Tooltip


view : Theme -> msg -> Element msg
view theme noOp =
    Element.column [ Element.width Element.fill, Element.spacing 24 ]
        [ Title.title "Tooltip" |> Title.withH1 |> Title.toMarkup theme
        , Element.paragraph [ Font.size 14, Font.color (Theme.text theme) ]
            [ Element.text "Tooltips display a short description when hovering over or focusing an element." ]
        , exampleSection theme "Tooltip positions"
            (Element.wrappedRow [ Element.spacing 24, Element.padding 32 ]
                [ Tooltip.tooltip
                    { trigger = Button.secondary { label = "Top", onPress = Just noOp } |> Button.toMarkup theme
                    , content = "Tooltip on top"
                    }
                    |> Tooltip.withTop
                    |> Tooltip.toMarkup theme
                , Tooltip.tooltip
                    { trigger = Button.secondary { label = "Bottom", onPress = Just noOp } |> Button.toMarkup theme
                    , content = "Tooltip on bottom"
                    }
                    |> Tooltip.withBottom
                    |> Tooltip.toMarkup theme
                , Tooltip.tooltip
                    { trigger = Button.secondary { label = "Left", onPress = Just noOp } |> Button.toMarkup theme
                    , content = "Tooltip on left"
                    }
                    |> Tooltip.withLeft
                    |> Tooltip.toMarkup theme
                , Tooltip.tooltip
                    { trigger = Button.secondary { label = "Right", onPress = Just noOp } |> Button.toMarkup theme
                    , content = "Tooltip on right"
                    }
                    |> Tooltip.withRight
                    |> Tooltip.toMarkup theme
                ]
            )
        ]


exampleSection : Theme -> String -> Element msg -> Element msg
exampleSection theme title content =
    Card.card [ content ]
        |> Card.withTitle title
        |> Card.toMarkup theme
