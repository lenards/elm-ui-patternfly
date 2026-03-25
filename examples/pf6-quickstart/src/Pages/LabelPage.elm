module Pages.LabelPage exposing (view)

import Element exposing (Element)
import Element.Font as Font
import PF6.Card as Card
import PF6.Label as Label
import PF6.Theme as Theme exposing (Theme)
import PF6.Title as Title
import PF6.Tokens as Tokens


view : Theme -> Element msg
view theme =
    Element.column [ Element.width Element.fill, Element.spacing 24 ]
        [ Title.title "Label" |> Title.withH1 |> Title.toMarkup theme
        , Element.paragraph [ Font.size 14, Font.color (Theme.text theme) ]
            [ Element.text "Labels highlight an item's status for quick recognition." ]
        , exampleSection theme "Filled labels"
            (Element.wrappedRow [ Element.spacing 12 ]
                [ Label.label "Default" |> Label.withFill |> Label.toMarkup theme
                , Label.label "Blue" |> Label.withFill |> Label.withBlueColor |> Label.toMarkup theme
                , Label.label "Green" |> Label.withFill |> Label.withGreenColor |> Label.toMarkup theme
                , Label.label "Orange" |> Label.withFill |> Label.withOrangeColor |> Label.toMarkup theme
                , Label.label "Red" |> Label.withFill |> Label.withRedColor |> Label.toMarkup theme
                , Label.label "Purple" |> Label.withFill |> Label.withPurpleColor |> Label.toMarkup theme
                , Label.label "Cyan" |> Label.withFill |> Label.withCyanColor |> Label.toMarkup theme
                ]
            )
        , exampleSection theme "Outline labels"
            (Element.wrappedRow [ Element.spacing 12 ]
                [ Label.label "Default" |> Label.withOutline |> Label.toMarkup theme
                , Label.label "Blue" |> Label.withOutline |> Label.withBlueColor |> Label.toMarkup theme
                , Label.label "Green" |> Label.withOutline |> Label.withGreenColor |> Label.toMarkup theme
                , Label.label "Red" |> Label.withOutline |> Label.withRedColor |> Label.toMarkup theme
                ]
            )
        , exampleSection theme "Compact labels"
            (Element.wrappedRow [ Element.spacing 12 ]
                [ Label.label "Compact" |> Label.withCompact |> Label.toMarkup theme
                , Label.label "Compact blue" |> Label.withCompact |> Label.withBlueColor |> Label.toMarkup theme
                , Label.label "Compact green" |> Label.withCompact |> Label.withGreenColor |> Label.toMarkup theme
                ]
            )
        ]


exampleSection : Theme -> String -> Element msg -> Element msg
exampleSection theme title content =
    Card.card [ content ]
        |> Card.withTitle title
        |> Card.toMarkup theme
