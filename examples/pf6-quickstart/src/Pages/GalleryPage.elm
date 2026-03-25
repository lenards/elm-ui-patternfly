module Pages.GalleryPage exposing (view)

import Element exposing (Element)
import Element.Background as Bg
import Element.Border as Border
import Element.Font as Font
import PF6.Card as Card
import PF6.Gallery as Gallery
import PF6.Theme as Theme exposing (Theme)
import PF6.Title as Title
import PF6.Tokens as Tokens


view : Theme -> Element msg
view theme =
    Element.column [ Element.width Element.fill, Element.spacing 24 ]
        [ Title.title "Gallery" |> Title.withH1 |> Title.toMarkup theme
        , Element.paragraph [ Font.size 14, Font.color (Theme.text theme) ]
            [ Element.text "Gallery provides a responsive grid of uniform items that wrap and maintain consistent sizing." ]
        , exampleSection theme "Basic gallery"
            (Gallery.gallery
                (List.map
                    (\i -> colorBox theme ("Item " ++ String.fromInt i) (Element.rgb255 200 220 255))
                    (List.range 1 8)
                )
                |> Gallery.withGutter
                |> Gallery.toMarkup theme
            )
        , exampleSection theme "Gallery with min width"
            (Gallery.gallery
                (List.map
                    (\i -> colorBox theme ("Card " ++ String.fromInt i) (Element.rgb255 220 255 220))
                    (List.range 1 6)
                )
                |> Gallery.withGutter
                |> Gallery.withMinWidthPx 200
                |> Gallery.toMarkup theme
            )
        ]


colorBox : Theme -> String -> Element.Color -> Element msg
colorBox theme label color =
    Element.el
        [ Bg.color color
        , Element.padding 24
        , Element.width Element.fill
        , Font.size 14
        , Font.color (Theme.text theme)
        , Border.width 1
        , Border.color (Element.rgba 0 0 0 0.1)
        , Border.rounded 4
        ]
        (Element.text label)


exampleSection : Theme -> String -> Element msg -> Element msg
exampleSection theme title content =
    Card.card [ content ]
        |> Card.withTitle title
        |> Card.toMarkup theme
