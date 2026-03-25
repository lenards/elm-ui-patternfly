module Pages.BannerPage exposing (view)

import Element exposing (Element)
import Element.Font as Font
import PF6.Banner as Banner
import PF6.Card as Card
import PF6.Title as Title
import PF6.Tokens as Tokens


view : Element msg
view =
    Element.column [ Element.width Element.fill, Element.spacing 24 ]
        [ Title.title "Banner" |> Title.withH1 |> Title.toMarkup
        , Element.paragraph [ Font.size 14, Font.color Tokens.colorText ]
            [ Element.text "Banners display important, site-wide information above the page navigation." ]
        , exampleSection "Variants"
            (Element.column [ Element.width Element.fill, Element.spacing 12 ]
                [ Banner.banner "Default banner message" |> Banner.withDefault |> Banner.toMarkup
                , Banner.banner "Info banner message" |> Banner.withInfo |> Banner.toMarkup
                , Banner.banner "Success banner message" |> Banner.withSuccess |> Banner.toMarkup
                , Banner.banner "Warning banner message" |> Banner.withWarning |> Banner.toMarkup
                , Banner.banner "Danger banner message" |> Banner.withDanger |> Banner.toMarkup
                ]
            )
        , exampleSection "With link"
            (Banner.banner "Visit the "
                |> Banner.withInfo
                |> Banner.withLink { label = "PatternFly docs", href = "https://www.patternfly.org" }
                |> Banner.toMarkup
            )
        ]


exampleSection : String -> Element msg -> Element msg
exampleSection title content =
    Card.card [ content ]
        |> Card.withTitle title
        |> Card.toMarkup
