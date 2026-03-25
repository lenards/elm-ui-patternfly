module Pages.SwitchPage exposing (view)

import Element exposing (Element)
import Element.Font as Font
import PF6.Card as Card
import PF6.Switch as Switch
import PF6.Title as Title
import PF6.Tokens as Tokens


view :
    { switchChecked : Bool
    , onSwitchToggle : Bool -> msg
    }
    -> Element msg
view config =
    Element.column [ Element.width Element.fill, Element.spacing 24 ]
        [ Title.title "Switch" |> Title.withH1 |> Title.toMarkup
        , Element.paragraph [ Font.size 14, Font.color Tokens.colorText ]
            [ Element.text "Switches toggle between two states, typically on and off." ]
        , exampleSection "Basic switch"
            (Switch.switch { onChange = config.onSwitchToggle }
                |> Switch.withLabel "Notifications"
                |> Switch.withChecked config.switchChecked
                |> Switch.toMarkup
            )
        , exampleSection "With on/off labels"
            (Switch.switch { onChange = config.onSwitchToggle }
                |> Switch.withLabel "Dark mode"
                |> Switch.withLabelOff "Light mode"
                |> Switch.withChecked config.switchChecked
                |> Switch.toMarkup
            )
        , exampleSection "Disabled"
            (Element.column [ Element.spacing 12 ]
                [ Switch.switch { onChange = \_ -> config.onSwitchToggle config.switchChecked }
                    |> Switch.withLabel "Disabled off"
                    |> Switch.withDisabled
                    |> Switch.toMarkup
                , Switch.switch { onChange = \_ -> config.onSwitchToggle config.switchChecked }
                    |> Switch.withLabel "Disabled on"
                    |> Switch.withChecked True
                    |> Switch.withDisabled
                    |> Switch.toMarkup
                ]
            )
        ]


exampleSection : String -> Element msg -> Element msg
exampleSection title content =
    Card.card [ content ]
        |> Card.withTitle title
        |> Card.toMarkup
