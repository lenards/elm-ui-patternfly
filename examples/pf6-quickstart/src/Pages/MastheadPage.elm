module Pages.MastheadPage exposing (view)

import Element exposing (Element)
import Element.Font as Font
import PF6.Card as Card
import PF6.Masthead as Masthead
import PF6.Theme as Theme exposing (Theme)
import PF6.Title as Title
import PF6.Tokens as Tokens


view : Theme -> Element msg
view theme =
    Element.column [ Element.width Element.fill, Element.spacing 24 ]
        [ Title.title "Masthead" |> Title.withH1 |> Title.toMarkup theme
        , Element.paragraph [ Font.size 14, Font.color (Theme.text theme) ]
            [ Element.text "The masthead is the top-level header bar of an application, containing the brand logo, navigation, and toolbar." ]
        , exampleSection theme "Basic masthead"
            (Masthead.masthead
                |> Masthead.withBrand (Element.el [ Font.bold, Font.size 16 ] (Element.text "MyApp"))
                |> Masthead.withContent (Element.el [ Font.size 14 ] (Element.text "Navigation items"))
                |> Masthead.toMarkup theme
            )
        , exampleSection theme "With toolbar"
            (Masthead.masthead
                |> Masthead.withBrand (Element.el [ Font.bold, Font.size 16 ] (Element.text "MyApp"))
                |> Masthead.withContent (Element.el [ Font.size 14 ] (Element.text "Nav"))
                |> Masthead.withToolbar (Element.el [ Font.size 14 ] (Element.text "User Menu"))
                |> Masthead.toMarkup theme
            )
        ]


exampleSection : Theme -> String -> Element msg -> Element msg
exampleSection theme title content =
    Card.card [ content ]
        |> Card.withTitle title
        |> Card.toMarkup theme
