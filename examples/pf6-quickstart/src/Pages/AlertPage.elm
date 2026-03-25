module Pages.AlertPage exposing (view)

import Element exposing (Element)
import Element.Font as Font
import PF6.Alert as Alert
import PF6.Card as Card
import PF6.Title as Title
import PF6.Tokens as Tokens


view : msg -> Element msg
view noOp =
    Element.column [ Element.width Element.fill, Element.spacing 24 ]
        [ Title.title "Alert" |> Title.withH1 |> Title.toMarkup
        , Element.paragraph [ Font.size 14, Font.color Tokens.colorText ]
            [ Element.text "Alerts communicate status and provide brief, contextual information." ]
        , exampleSection "Alert variants"
            (Element.column [ Element.width Element.fill, Element.spacing 12 ]
                [ Alert.alert "Default alert title"
                    |> Alert.toMarkup
                , Alert.alert "Success alert title"
                    |> Alert.withSuccess
                    |> Alert.toMarkup
                , Alert.alert "Danger alert title"
                    |> Alert.withDanger
                    |> Alert.toMarkup
                , Alert.alert "Warning alert title"
                    |> Alert.withWarning
                    |> Alert.toMarkup
                , Alert.alert "Info alert title"
                    |> Alert.withInfo
                    |> Alert.toMarkup
                ]
            )
        , exampleSection "Inline alerts"
            (Element.column [ Element.width Element.fill, Element.spacing 12 ]
                [ Alert.alert "Inline success"
                    |> Alert.withSuccess
                    |> Alert.withInline
                    |> Alert.toMarkup
                , Alert.alert "Inline danger"
                    |> Alert.withDanger
                    |> Alert.withInline
                    |> Alert.toMarkup
                ]
            )
        , exampleSection "Dismissable alert"
            (Alert.alert "You can close this alert"
                |> Alert.withInfo
                |> Alert.withCloseMsg noOp
                |> Alert.toMarkup
            )
        ]


exampleSection : String -> Element msg -> Element msg
exampleSection title content =
    Card.card [ content ]
        |> Card.withTitle title
        |> Card.toMarkup
