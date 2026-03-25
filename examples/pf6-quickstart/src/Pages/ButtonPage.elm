module Pages.ButtonPage exposing (view)

import Element exposing (Element)
import Element.Font as Font
import PF6.Button as Button
import PF6.Card as Card
import PF6.Title as Title
import PF6.Tokens as Tokens


view : msg -> Element msg
view noOp =
    Element.column [ Element.width Element.fill, Element.spacing 24 ]
        [ Title.title "Button" |> Title.withH1 |> Title.toMarkup
        , Element.paragraph [ Font.size 14, Font.color Tokens.colorText ]
            [ Element.text "Buttons communicate and trigger actions a user can take." ]
        , exampleSection "Variants"
            (Element.wrappedRow [ Element.spacing 12 ]
                [ Button.primary { label = "Primary", onPress = Just noOp } |> Button.toMarkup
                , Button.secondary { label = "Secondary", onPress = Just noOp } |> Button.toMarkup
                , Button.danger { label = "Danger", onPress = Just noOp } |> Button.toMarkup
                , Button.warning { label = "Warning", onPress = Just noOp } |> Button.toMarkup
                , Button.tertiary { label = "Tertiary", onPress = Just noOp } |> Button.toMarkup
                , Button.link { label = "Link", onPress = Just noOp } |> Button.toMarkup
                ]
            )
        , exampleSection "Sizes"
            (Element.wrappedRow [ Element.spacing 12 ]
                [ Button.primary { label = "Large", onPress = Just noOp } |> Button.withLargeSize |> Button.toMarkup
                , Button.primary { label = "Default", onPress = Just noOp } |> Button.toMarkup
                , Button.primary { label = "Small", onPress = Just noOp } |> Button.withSmallSize |> Button.toMarkup
                ]
            )
        , exampleSection "Disabled"
            (Element.wrappedRow [ Element.spacing 12 ]
                [ Button.primary { label = "Disabled primary", onPress = Just noOp } |> Button.withDisabled |> Button.toMarkup
                , Button.secondary { label = "Disabled secondary", onPress = Just noOp } |> Button.withDisabled |> Button.toMarkup
                ]
            )
        ]


exampleSection : String -> Element msg -> Element msg
exampleSection title content =
    Card.card [ content ]
        |> Card.withTitle title
        |> Card.toMarkup
