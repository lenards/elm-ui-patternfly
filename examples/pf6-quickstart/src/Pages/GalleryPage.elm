module Pages.GalleryPage exposing (view)

import Element exposing (Element)
import Element.Background as Bg
import Element.Border as Border
import Element.Font as Font
import PF6.Card as Card
import PF6.Gallery as Gallery
import PF6.Title as Title
import PF6.Tokens as Tokens


view : Element msg
view =
    Element.column [ Element.width Element.fill, Element.spacing 24 ]
        [ Title.title "Gallery" |> Title.withH1 |> Title.toMarkup
        , Element.paragraph [ Font.size 14, Font.color Tokens.colorText ]
            [ Element.text "Gallery provides a responsive grid of uniform items that wrap and maintain consistent sizing." ]
        , exampleSection "Basic gallery"
            (Gallery.gallery
                (List.map
                    (\i -> colorBox ("Item " ++ String.fromInt i) (Element.rgb255 200 220 255))
                    (List.range 1 8)
                )
                |> Gallery.withGutter
                |> Gallery.toMarkup
            )
        , exampleSection "Gallery with min width"
            (Gallery.gallery
                (List.map
                    (\i -> colorBox ("Card " ++ String.fromInt i) (Element.rgb255 220 255 220))
                    (List.range 1 6)
                )
                |> Gallery.withGutter
                |> Gallery.withMinWidthPx 200
                |> Gallery.toMarkup
            )
        ]


colorBox : String -> Element.Color -> Element msg
colorBox label color =
    Element.el
        [ Bg.color color
        , Element.padding 24
        , Element.width Element.fill
        , Font.size 14
        , Font.color Tokens.colorText
        , Border.width 1
        , Border.color (Element.rgba 0 0 0 0.1)
        , Border.rounded 4
        ]
        (Element.text label)


exampleSection : String -> Element msg -> Element msg
exampleSection title content =
    Card.card [ content ]
        |> Card.withTitle title
        |> Card.toMarkup
