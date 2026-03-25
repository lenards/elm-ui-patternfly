module Pages.SliderPage exposing (view)

import Element exposing (Element)
import Element.Font as Font
import PF6.Card as Card
import PF6.Slider as Slider
import PF6.Title as Title
import PF6.Tokens as Tokens


view :
    { sliderValue : Float
    , onSliderChange : Float -> msg
    }
    -> Element msg
view config =
    Element.column [ Element.width Element.fill, Element.spacing 24 ]
        [ Title.title "Slider" |> Title.withH1 |> Title.toMarkup
        , Element.paragraph [ Font.size 14, Font.color Tokens.colorText ]
            [ Element.text "Sliders allow users to select a value from a continuous range." ]
        , exampleSection "Basic slider"
            (Slider.slider
                { value = config.sliderValue
                , onChange = config.onSliderChange
                , min = 0
                , max = 100
                }
                |> Slider.withLabel "Volume"
                |> Slider.withShowValue
                |> Slider.toMarkup
            )
        , exampleSection "With step"
            (Slider.slider
                { value = config.sliderValue
                , onChange = config.onSliderChange
                , min = 0
                , max = 100
                }
                |> Slider.withLabel "Percentage"
                |> Slider.withStep 10
                |> Slider.withShowValue
                |> Slider.toMarkup
            )
        , exampleSection "Disabled"
            (Slider.slider
                { value = 50
                , onChange = config.onSliderChange
                , min = 0
                , max = 100
                }
                |> Slider.withLabel "Disabled slider"
                |> Slider.withDisabled
                |> Slider.withShowValue
                |> Slider.toMarkup
            )
        ]


exampleSection : String -> Element msg -> Element msg
exampleSection title content =
    Card.card [ content ]
        |> Card.withTitle title
        |> Card.toMarkup
