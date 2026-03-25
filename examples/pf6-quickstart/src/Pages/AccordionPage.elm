module Pages.AccordionPage exposing (view)

import Element exposing (Element)
import Element.Font as Font
import PF6.Accordion as Accordion
import PF6.Card as Card
import PF6.Theme as Theme exposing (Theme)
import PF6.Title as Title
import PF6.Tokens as Tokens


view :
    Theme
    ->
        { expanded : Maybe String
        , onToggle : String -> Bool -> msg
        }
    -> Element msg
view theme config =
    let
        isExpanded id =
            config.expanded == Just id

        onToggle id open =
            config.onToggle id open
    in
    Element.column [ Element.width Element.fill, Element.spacing 24 ]
        [ Title.title "Accordion" |> Title.withH1 |> Title.toMarkup theme
        , Element.paragraph [ Font.size 14, Font.color (Theme.text theme) ]
            [ Element.text "Accordions toggle the visibility of sections of content." ]
        , exampleSection theme "Basic accordion"
            (Accordion.accordion
                [ Accordion.item
                    { title = "Item one"
                    , body = Element.paragraph [ Font.size 14 ] [ Element.text "This is the content for the first accordion item. Accordions are useful for organizing dense content." ]
                    , isExpanded = isExpanded "one"
                    , onToggle = onToggle "one"
                    }
                , Accordion.item
                    { title = "Item two"
                    , body = Element.paragraph [ Font.size 14 ] [ Element.text "This is the content for the second accordion item. Only one item is expanded at a time." ]
                    , isExpanded = isExpanded "two"
                    , onToggle = onToggle "two"
                    }
                , Accordion.item
                    { title = "Item three"
                    , body = Element.paragraph [ Font.size 14 ] [ Element.text "This is the content for the third accordion item." ]
                    , isExpanded = isExpanded "three"
                    , onToggle = onToggle "three"
                    }
                ]
                |> Accordion.toMarkup theme
            )
        , exampleSection theme "Bordered accordion"
            (Accordion.accordion
                [ Accordion.item
                    { title = "First section"
                    , body = Element.paragraph [ Font.size 14 ] [ Element.text "Bordered accordions add visual separation between items." ]
                    , isExpanded = isExpanded "b-one"
                    , onToggle = onToggle "b-one"
                    }
                , Accordion.item
                    { title = "Second section"
                    , body = Element.paragraph [ Font.size 14 ] [ Element.text "Each section has a distinct border." ]
                    , isExpanded = isExpanded "b-two"
                    , onToggle = onToggle "b-two"
                    }
                ]
                |> Accordion.withBordered
                |> Accordion.toMarkup theme
            )
        ]


exampleSection : Theme -> String -> Element msg -> Element msg
exampleSection theme title content =
    Card.card [ content ]
        |> Card.withTitle title
        |> Card.toMarkup theme
