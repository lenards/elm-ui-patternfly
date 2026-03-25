module Pages.RadioPage exposing (view)

import Element exposing (Element)
import Element.Font as Font
import PF6.Card as Card
import PF6.Radio as Radio
import PF6.Theme as Theme exposing (Theme)
import PF6.Title as Title
import PF6.Tokens as Tokens


view :
    Theme
    ->
        { selectedRadio : String
        , onRadioChange : String -> msg
        }
    -> Element msg
view theme config =
    Element.column [ Element.width Element.fill, Element.spacing 24 ]
        [ Title.title "Radio" |> Title.withH1 |> Title.toMarkup theme
        , Element.paragraph [ Font.size 14, Font.color (Theme.text theme) ]
            [ Element.text "Radios allow users to select a single option from a list of mutually exclusive options." ]
        , exampleSection theme "Basic radio group"
            (Element.column [ Element.spacing 12 ]
                [ Radio.radio { id = "radio-1", onChange = \_ -> config.onRadioChange "option1" }
                    |> Radio.withLabel "Option 1"
                    |> Radio.withChecked (config.selectedRadio == "option1")
                    |> Radio.toMarkup theme
                , Radio.radio { id = "radio-2", onChange = \_ -> config.onRadioChange "option2" }
                    |> Radio.withLabel "Option 2"
                    |> Radio.withChecked (config.selectedRadio == "option2")
                    |> Radio.toMarkup theme
                , Radio.radio { id = "radio-3", onChange = \_ -> config.onRadioChange "option3" }
                    |> Radio.withLabel "Option 3"
                    |> Radio.withChecked (config.selectedRadio == "option3")
                    |> Radio.toMarkup theme
                ]
            )
        , exampleSection theme "With description"
            (Element.column [ Element.spacing 12 ]
                [ Radio.radio { id = "radio-desc-1", onChange = \_ -> config.onRadioChange "small" }
                    |> Radio.withLabel "Small"
                    |> Radio.withDescription "1 CPU, 2 GB RAM"
                    |> Radio.withChecked (config.selectedRadio == "small")
                    |> Radio.toMarkup theme
                , Radio.radio { id = "radio-desc-2", onChange = \_ -> config.onRadioChange "medium" }
                    |> Radio.withLabel "Medium"
                    |> Radio.withDescription "2 CPU, 4 GB RAM"
                    |> Radio.withChecked (config.selectedRadio == "medium")
                    |> Radio.toMarkup theme
                ]
            )
        , exampleSection theme "Disabled"
            (Radio.radio { id = "radio-disabled", onChange = \_ -> config.onRadioChange config.selectedRadio }
                |> Radio.withLabel "Disabled option"
                |> Radio.withDisabled
                |> Radio.toMarkup theme
            )
        ]


exampleSection : Theme -> String -> Element msg -> Element msg
exampleSection theme title content =
    Card.card [ content ]
        |> Card.withTitle title
        |> Card.toMarkup theme
