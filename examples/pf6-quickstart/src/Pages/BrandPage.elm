module Pages.BrandPage exposing (view)

import Element exposing (Element)
import Element.Font as Font
import PF6.Brand as Brand
import PF6.Card as Card
import PF6.Theme as Theme exposing (Theme)
import PF6.Title as Title
import PF6.Tokens as Tokens


view : Theme -> Element msg
view theme =
    Element.column [ Element.width Element.fill, Element.spacing 24 ]
        [ Title.title "Brand" |> Title.withH1 |> Title.toMarkup theme
        , Element.paragraph [ Font.size 14, Font.color (Theme.text theme) ]
            [ Element.text "A brand image with alt text, typically used in the masthead." ]
        , exampleSection theme "Basic brand"
            (Brand.brand { src = "brand-logo.svg", alt = "PatternFly logo" }
                |> Brand.withWidth 200
                |> Brand.toMarkup theme
            )
        , exampleSection theme "With explicit dimensions"
            (Brand.brand { src = "brand-logo.svg", alt = "PatternFly logo" }
                |> Brand.withWidth 300
                |> Brand.withHeight 50
                |> Brand.toMarkup theme
            )
        ]


exampleSection : Theme -> String -> Element msg -> Element msg
exampleSection theme title content =
    Card.card [ content ]
        |> Card.withTitle title
        |> Card.toMarkup theme
