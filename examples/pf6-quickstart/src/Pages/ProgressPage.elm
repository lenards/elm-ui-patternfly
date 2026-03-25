module Pages.ProgressPage exposing (view)

import Element exposing (Element)
import Element.Font as Font
import PF6.Card as Card
import PF6.Progress as Progress
import PF6.Title as Title
import PF6.Tokens as Tokens


view : Float -> Element msg
view progressValue =
    Element.column [ Element.width Element.fill, Element.spacing 24 ]
        [ Title.title "Progress" |> Title.withH1 |> Title.toMarkup
        , Element.paragraph [ Font.size 14, Font.color Tokens.colorText ]
            [ Element.text "Progress bars communicate the status of an ongoing process." ]
        , exampleSection "Basic progress"
            (Element.column [ Element.width Element.fill, Element.spacing 16 ]
                [ Progress.progress progressValue
                    |> Progress.withTitle "Loading"
                    |> Progress.toMarkup
                , Progress.progress 100
                    |> Progress.withTitle "Complete"
                    |> Progress.withSuccess
                    |> Progress.toMarkup
                ]
            )
        , exampleSection "Status variants"
            (Element.column [ Element.width Element.fill, Element.spacing 16 ]
                [ Progress.progress 40
                    |> Progress.withTitle "In progress"
                    |> Progress.withInfo
                    |> Progress.toMarkup
                , Progress.progress 60
                    |> Progress.withTitle "Warning"
                    |> Progress.withWarning
                    |> Progress.toMarkup
                , Progress.progress 25
                    |> Progress.withTitle "Danger"
                    |> Progress.withDanger
                    |> Progress.toMarkup
                ]
            )
        , exampleSection "Sizes"
            (Element.column [ Element.width Element.fill, Element.spacing 16 ]
                [ Progress.progress 50
                    |> Progress.withTitle "Small"
                    |> Progress.withSmallSize
                    |> Progress.toMarkup
                , Progress.progress 50
                    |> Progress.withTitle "Default"
                    |> Progress.toMarkup
                , Progress.progress 50
                    |> Progress.withTitle "Large"
                    |> Progress.withLargeSize
                    |> Progress.toMarkup
                ]
            )
        ]


exampleSection : String -> Element msg -> Element msg
exampleSection title content =
    Card.card [ content ]
        |> Card.withTitle title
        |> Card.toMarkup
