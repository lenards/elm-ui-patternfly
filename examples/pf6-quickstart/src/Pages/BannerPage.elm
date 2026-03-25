module Pages.BannerPage exposing (view)

import Element exposing (Element)
import Element.Font as Font
import PF6.Banner as Banner
import PF6.Card as Card
import PF6.Theme as Theme exposing (Theme)
import PF6.Title as Title
import PF6.Tokens as Tokens


view : Theme -> Element msg
view theme =
    Element.column [ Element.width Element.fill, Element.spacing 24 ]
        [ Title.title "Banner" |> Title.withH1 |> Title.toMarkup theme
        , Element.paragraph [ Font.size 14, Font.color (Theme.text theme) ]
            [ Element.text "Banners display important, site-wide information above the page navigation." ]
        , exampleSection theme "Variants"
            (Element.column [ Element.width Element.fill, Element.spacing 12 ]
                [ Banner.banner "Default banner message" |> Banner.withDefault |> Banner.toMarkup theme
                , Banner.banner "Info banner message" |> Banner.withInfo |> Banner.toMarkup theme
                , Banner.banner "Success banner message" |> Banner.withSuccess |> Banner.toMarkup theme
                , Banner.banner "Warning banner message" |> Banner.withWarning |> Banner.toMarkup theme
                , Banner.banner "Danger banner message" |> Banner.withDanger |> Banner.toMarkup theme
                ]
            )
        , exampleSection theme "With link"
            (Banner.banner "Visit the "
                |> Banner.withInfo
                |> Banner.withLink { label = "PatternFly docs", href = "https://www.patternfly.org" }
                |> Banner.toMarkup theme
            )
        ]


exampleSection : Theme -> String -> Element msg -> Element msg
exampleSection theme title content =
    Card.card [ content ]
        |> Card.withTitle title
        |> Card.toMarkup theme
