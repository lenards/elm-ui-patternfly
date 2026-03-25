module Pages.ActionListPage exposing (view)

import Element exposing (Element)
import Element.Font as Font
import PF6.ActionList as ActionList
import PF6.Button as Button
import PF6.Card as Card
import PF6.Theme as Theme exposing (Theme)
import PF6.Title as Title
import PF6.Tokens as Tokens


view : Theme -> msg -> Element msg
view theme noOp =
    Element.column [ Element.width Element.fill, Element.spacing 24 ]
        [ Title.title "Action List" |> Title.withH1 |> Title.toMarkup theme
        , Element.paragraph [ Font.size 14, Font.color (Theme.text theme) ]
            [ Element.text "An action list is a group of actions, controls, or buttons with set spacing." ]
        , exampleSection theme "Basic action list"
            (ActionList.actionList
                [ ActionList.actionItem
                    (Button.primary { label = "Next", onPress = Just noOp } |> Button.toMarkup theme)
                , ActionList.cancelItem
                    (Button.secondary { label = "Cancel", onPress = Just noOp } |> Button.toMarkup theme)
                ]
                |> ActionList.toMarkup theme
            )
        , exampleSection theme "Icons variant"
            (ActionList.actionList
                [ ActionList.iconItem (Element.text "\u{1F4BE}")
                , ActionList.iconItem (Element.text "\u{270F}\u{FE0F}")
                , ActionList.iconItem (Element.text "\u{1F5D1}")
                ]
                |> ActionList.withIcons
                |> ActionList.toMarkup theme
            )
        ]


exampleSection : Theme -> String -> Element msg -> Element msg
exampleSection theme title content =
    Card.card [ content ]
        |> Card.withTitle title
        |> Card.toMarkup theme
