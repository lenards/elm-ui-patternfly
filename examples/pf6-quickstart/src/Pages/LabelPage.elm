module Pages.LabelPage exposing (view)

import Element exposing (Element)
import Element.Font as Font
import PF6.Card as Card
import PF6.Label as Label
import PF6.Title as Title
import PF6.Tokens as Tokens


view : Element msg
view =
    Element.column [ Element.width Element.fill, Element.spacing 24 ]
        [ Title.title "Label" |> Title.withH1 |> Title.toMarkup
        , Element.paragraph [ Font.size 14, Font.color Tokens.colorText ]
            [ Element.text "Labels highlight an item's status for quick recognition." ]
        , exampleSection "Filled labels"
            (Element.wrappedRow [ Element.spacing 12 ]
                [ Label.label "Default" |> Label.withFill |> Label.toMarkup
                , Label.label "Blue" |> Label.withFill |> Label.withBlueColor |> Label.toMarkup
                , Label.label "Green" |> Label.withFill |> Label.withGreenColor |> Label.toMarkup
                , Label.label "Orange" |> Label.withFill |> Label.withOrangeColor |> Label.toMarkup
                , Label.label "Red" |> Label.withFill |> Label.withRedColor |> Label.toMarkup
                , Label.label "Purple" |> Label.withFill |> Label.withPurpleColor |> Label.toMarkup
                , Label.label "Cyan" |> Label.withFill |> Label.withCyanColor |> Label.toMarkup
                ]
            )
        , exampleSection "Outline labels"
            (Element.wrappedRow [ Element.spacing 12 ]
                [ Label.label "Default" |> Label.withOutline |> Label.toMarkup
                , Label.label "Blue" |> Label.withOutline |> Label.withBlueColor |> Label.toMarkup
                , Label.label "Green" |> Label.withOutline |> Label.withGreenColor |> Label.toMarkup
                , Label.label "Red" |> Label.withOutline |> Label.withRedColor |> Label.toMarkup
                ]
            )
        , exampleSection "Compact labels"
            (Element.wrappedRow [ Element.spacing 12 ]
                [ Label.label "Compact" |> Label.withCompact |> Label.toMarkup
                , Label.label "Compact blue" |> Label.withCompact |> Label.withBlueColor |> Label.toMarkup
                , Label.label "Compact green" |> Label.withCompact |> Label.withGreenColor |> Label.toMarkup
                ]
            )
        ]


exampleSection : String -> Element msg -> Element msg
exampleSection title content =
    Card.card [ content ]
        |> Card.withTitle title
        |> Card.toMarkup
