module Pages.AlertPage exposing (view)

import Element exposing (Element)
import Element.Font as Font
import PF6.Alert as Alert
import PF6.Card as Card
import PF6.Theme as Theme exposing (Theme)
import PF6.Title as Title
import PF6.Tokens as Tokens


view : Theme -> msg -> Element msg
view theme noOp =
    Element.column [ Element.width Element.fill, Element.spacing 24 ]
        [ Title.title "Alert" |> Title.withH1 |> Title.toMarkup theme
        , Element.paragraph [ Font.size 14, Font.color (Theme.text theme) ]
            [ Element.text "Alerts communicate status and provide brief, contextual information." ]
        , exampleSection theme "Alert variants"
            (Element.column [ Element.width Element.fill, Element.spacing 12 ]
                [ Alert.alert "Default alert title"
                    |> Alert.toMarkup theme
                , Alert.alert "Success alert title"
                    |> Alert.withSuccess
                    |> Alert.toMarkup theme
                , Alert.alert "Danger alert title"
                    |> Alert.withDanger
                    |> Alert.toMarkup theme
                , Alert.alert "Warning alert title"
                    |> Alert.withWarning
                    |> Alert.toMarkup theme
                , Alert.alert "Info alert title"
                    |> Alert.withInfo
                    |> Alert.toMarkup theme
                ]
            )
        , exampleSection theme "Inline alerts"
            (Element.column [ Element.width Element.fill, Element.spacing 12 ]
                [ Alert.alert "Inline success"
                    |> Alert.withSuccess
                    |> Alert.withInline
                    |> Alert.toMarkup theme
                , Alert.alert "Inline danger"
                    |> Alert.withDanger
                    |> Alert.withInline
                    |> Alert.toMarkup theme
                ]
            )
        , exampleSection theme "Dismissable alert"
            (Alert.alert "You can close this alert"
                |> Alert.withInfo
                |> Alert.withCloseMsg noOp
                |> Alert.toMarkup theme
            )
        ]


exampleSection : Theme -> String -> Element msg -> Element msg
exampleSection theme title content =
    Card.card [ content ]
        |> Card.withTitle title
        |> Card.toMarkup theme
