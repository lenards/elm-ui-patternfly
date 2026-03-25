module Pages.BrandPage exposing (view)

import Element exposing (Element)
import Element.Font as Font
import PF6.Brand as Brand
import PF6.Card as Card
import PF6.Title as Title
import PF6.Tokens as Tokens


view : Element msg
view =
    Element.column [ Element.width Element.fill, Element.spacing 24 ]
        [ Title.title "Brand" |> Title.withH1 |> Title.toMarkup
        , Element.paragraph [ Font.size 14, Font.color Tokens.colorText ]
            [ Element.text "A brand image with alt text, typically used in the masthead." ]
        , exampleSection "Basic brand"
            (Brand.brand { src = "brand-logo.svg", alt = "PatternFly logo" }
                |> Brand.withWidth 200
                |> Brand.toMarkup
            )
        , exampleSection "With explicit dimensions"
            (Brand.brand { src = "brand-logo.svg", alt = "PatternFly logo" }
                |> Brand.withWidth 300
                |> Brand.withHeight 50
                |> Brand.toMarkup
            )
        ]


exampleSection : String -> Element msg -> Element msg
exampleSection title content =
    Card.card [ content ]
        |> Card.withTitle title
        |> Card.toMarkup
