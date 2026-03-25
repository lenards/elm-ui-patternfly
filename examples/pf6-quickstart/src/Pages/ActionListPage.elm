module Pages.ActionListPage exposing (view)

import Element exposing (Element)
import Element.Font as Font
import PF6.ActionList as ActionList
import PF6.Button as Button
import PF6.Card as Card
import PF6.Title as Title
import PF6.Tokens as Tokens


view : msg -> Element msg
view noOp =
    Element.column [ Element.width Element.fill, Element.spacing 24 ]
        [ Title.title "Action List" |> Title.withH1 |> Title.toMarkup
        , Element.paragraph [ Font.size 14, Font.color Tokens.colorText ]
            [ Element.text "An action list is a group of actions, controls, or buttons with set spacing." ]
        , exampleSection "Basic action list"
            (ActionList.actionList
                [ ActionList.actionItem
                    (Button.primary { label = "Next", onPress = Just noOp } |> Button.toMarkup)
                , ActionList.cancelItem
                    (Button.secondary { label = "Cancel", onPress = Just noOp } |> Button.toMarkup)
                ]
                |> ActionList.toMarkup
            )
        , exampleSection "Icons variant"
            (ActionList.actionList
                [ ActionList.iconItem (Element.text "\u{1F4BE}")
                , ActionList.iconItem (Element.text "\u{270F}\u{FE0F}")
                , ActionList.iconItem (Element.text "\u{1F5D1}")
                ]
                |> ActionList.withIcons
                |> ActionList.toMarkup
            )
        ]


exampleSection : String -> Element msg -> Element msg
exampleSection title content =
    Card.card [ content ]
        |> Card.withTitle title
        |> Card.toMarkup
