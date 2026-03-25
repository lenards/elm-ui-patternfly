module Pages.SliderPage exposing (view)

import Element exposing (Element)
import Element.Font as Font
import PF6.Card as Card
import PF6.Slider as Slider
import PF6.Theme as Theme exposing (Theme)
import PF6.Title as Title
import PF6.Tokens as Tokens


view :
    Theme
    ->
        { sliderValue : Float
        , onSliderChange : Float -> msg
        }
    -> Element msg
view theme config =
    Element.column [ Element.width Element.fill, Element.spacing 24 ]
        [ Title.title "Slider" |> Title.withH1 |> Title.toMarkup theme
        , Element.paragraph [ Font.size 14, Font.color (Theme.text theme) ]
            [ Element.text "Sliders allow users to select a value from a continuous range." ]
        , exampleSection theme "Basic slider"
            (Slider.slider
                { value = config.sliderValue
                , onChange = config.onSliderChange
                , min = 0
                , max = 100
                }
                |> Slider.withLabel "Volume"
                |> Slider.withShowValue
                |> Slider.toMarkup theme
            )
        , exampleSection theme "With step"
            (Slider.slider
                { value = config.sliderValue
                , onChange = config.onSliderChange
                , min = 0
                , max = 100
                }
                |> Slider.withLabel "Percentage"
                |> Slider.withStep 10
                |> Slider.withShowValue
                |> Slider.toMarkup theme
            )
        , exampleSection theme "Disabled"
            (Slider.slider
                { value = 50
                , onChange = config.onSliderChange
                , min = 0
                , max = 100
                }
                |> Slider.withLabel "Disabled slider"
                |> Slider.withDisabled
                |> Slider.withShowValue
                |> Slider.toMarkup theme
            )
        ]


exampleSection : Theme -> String -> Element msg -> Element msg
exampleSection theme title content =
    Card.card [ content ]
        |> Card.withTitle title
        |> Card.toMarkup theme
