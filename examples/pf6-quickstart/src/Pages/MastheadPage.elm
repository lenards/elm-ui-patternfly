module Pages.MastheadPage exposing (view)

import Element exposing (Element)
import Element.Font as Font
import PF6.Card as Card
import PF6.Masthead as Masthead
import PF6.Title as Title
import PF6.Tokens as Tokens


view : Element msg
view =
    Element.column [ Element.width Element.fill, Element.spacing 24 ]
        [ Title.title "Masthead" |> Title.withH1 |> Title.toMarkup
        , Element.paragraph [ Font.size 14, Font.color Tokens.colorText ]
            [ Element.text "The masthead is the top-level header bar of an application, containing the brand logo, navigation, and toolbar." ]
        , exampleSection "Basic masthead"
            (Masthead.masthead
                |> Masthead.withBrand (Element.el [ Font.bold, Font.size 16 ] (Element.text "MyApp"))
                |> Masthead.withContent (Element.el [ Font.size 14 ] (Element.text "Navigation items"))
                |> Masthead.toMarkup
            )
        , exampleSection "With toolbar"
            (Masthead.masthead
                |> Masthead.withBrand (Element.el [ Font.bold, Font.size 16 ] (Element.text "MyApp"))
                |> Masthead.withContent (Element.el [ Font.size 14 ] (Element.text "Nav"))
                |> Masthead.withToolbar (Element.el [ Font.size 14 ] (Element.text "User Menu"))
                |> Masthead.toMarkup
            )
        ]


exampleSection : String -> Element msg -> Element msg
exampleSection title content =
    Card.card [ content ]
        |> Card.withTitle title
        |> Card.toMarkup
