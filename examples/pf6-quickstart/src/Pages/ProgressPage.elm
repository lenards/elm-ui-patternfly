module Pages.ProgressPage exposing (view)

import Element exposing (Element)
import Element.Font as Font
import PF6.Card as Card
import PF6.Progress as Progress
import PF6.Theme as Theme exposing (Theme)
import PF6.Title as Title
import PF6.Tokens as Tokens


view : Theme -> Float -> Element msg
view theme progressValue =
    Element.column [ Element.width Element.fill, Element.spacing 24 ]
        [ Title.title "Progress" |> Title.withH1 |> Title.toMarkup theme
        , Element.paragraph [ Font.size 14, Font.color (Theme.text theme) ]
            [ Element.text "Progress bars communicate the status of an ongoing process." ]
        , exampleSection theme "Basic progress"
            (Element.column [ Element.width Element.fill, Element.spacing 16 ]
                [ Progress.progress progressValue
                    |> Progress.withTitle "Loading"
                    |> Progress.toMarkup theme
                , Progress.progress 100
                    |> Progress.withTitle "Complete"
                    |> Progress.withSuccess
                    |> Progress.toMarkup theme
                ]
            )
        , exampleSection theme "Status variants"
            (Element.column [ Element.width Element.fill, Element.spacing 16 ]
                [ Progress.progress 40
                    |> Progress.withTitle "In progress"
                    |> Progress.withInfo
                    |> Progress.toMarkup theme
                , Progress.progress 60
                    |> Progress.withTitle "Warning"
                    |> Progress.withWarning
                    |> Progress.toMarkup theme
                , Progress.progress 25
                    |> Progress.withTitle "Danger"
                    |> Progress.withDanger
                    |> Progress.toMarkup theme
                ]
            )
        , exampleSection theme "Sizes"
            (Element.column [ Element.width Element.fill, Element.spacing 16 ]
                [ Progress.progress 50
                    |> Progress.withTitle "Small"
                    |> Progress.withSmallSize
                    |> Progress.toMarkup theme
                , Progress.progress 50
                    |> Progress.withTitle "Default"
                    |> Progress.toMarkup theme
                , Progress.progress 50
                    |> Progress.withTitle "Large"
                    |> Progress.withLargeSize
                    |> Progress.toMarkup theme
                ]
            )
        ]


exampleSection : Theme -> String -> Element msg -> Element msg
exampleSection theme title content =
    Card.card [ content ]
        |> Card.withTitle title
        |> Card.toMarkup theme
