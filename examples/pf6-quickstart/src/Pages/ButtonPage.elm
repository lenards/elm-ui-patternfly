module Pages.ButtonPage exposing (view)

import Element exposing (Element)
import Element.Font as Font
import PF6.Button as Button
import PF6.Card as Card
import PF6.Theme as Theme exposing (Theme)
import PF6.Title as Title
import PF6.Tokens as Tokens


view : Theme -> msg -> Element msg
view theme noOp =
    Element.column [ Element.width Element.fill, Element.spacing 24 ]
        [ Title.title "Button" |> Title.withH1 |> Title.toMarkup theme
        , Element.paragraph [ Font.size 14, Font.color (Theme.text theme) ]
            [ Element.text "Buttons communicate and trigger actions a user can take." ]
        , exampleSection theme "Variants"
            (Element.wrappedRow [ Element.spacing 12 ]
                [ Button.primary { label = "Primary", onPress = Just noOp } |> Button.toMarkup theme
                , Button.secondary { label = "Secondary", onPress = Just noOp } |> Button.toMarkup theme
                , Button.danger { label = "Danger", onPress = Just noOp } |> Button.toMarkup theme
                , Button.warning { label = "Warning", onPress = Just noOp } |> Button.toMarkup theme
                , Button.tertiary { label = "Tertiary", onPress = Just noOp } |> Button.toMarkup theme
                , Button.link { label = "Link", onPress = Just noOp } |> Button.toMarkup theme
                ]
            )
        , exampleSection theme "Sizes"
            (Element.wrappedRow [ Element.spacing 12 ]
                [ Button.primary { label = "Large", onPress = Just noOp } |> Button.withLargeSize |> Button.toMarkup theme
                , Button.primary { label = "Default", onPress = Just noOp } |> Button.toMarkup theme
                , Button.primary { label = "Small", onPress = Just noOp } |> Button.withSmallSize |> Button.toMarkup theme
                ]
            )
        , exampleSection theme "Disabled"
            (Element.wrappedRow [ Element.spacing 12 ]
                [ Button.primary { label = "Disabled primary", onPress = Just noOp } |> Button.withDisabled |> Button.toMarkup theme
                , Button.secondary { label = "Disabled secondary", onPress = Just noOp } |> Button.withDisabled |> Button.toMarkup theme
                ]
            )
        ]


exampleSection : Theme -> String -> Element msg -> Element msg
exampleSection theme title content =
    Card.card [ content ]
        |> Card.withTitle title
        |> Card.toMarkup theme
