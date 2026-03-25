module Pages.ExpandableSectionPage exposing (view)

import Element exposing (Element)
import Element.Font as Font
import PF6.Card as Card
import PF6.ExpandableSection as ExpandableSection
import PF6.Theme as Theme exposing (Theme)
import PF6.Title as Title
import PF6.Tokens as Tokens


view :
    Theme
    ->
        { expanded : Bool
        , onToggle : Bool -> msg
        }
    -> Element msg
view theme config =
    Element.column [ Element.width Element.fill, Element.spacing 24 ]
        [ Title.title "Expandable Section" |> Title.withH1 |> Title.toMarkup theme
        , Element.paragraph [ Font.size 14, Font.color (Theme.text theme) ]
            [ Element.text "Expandable sections toggle the visibility of content." ]
        , exampleSection theme "Basic expandable section"
            (ExpandableSection.expandableSection
                { isExpanded = config.expanded
                , onToggle = config.onToggle
                , body =
                    Element.paragraph [ Font.size 14 ]
                        [ Element.text "This content is revealed when the section is expanded. It can contain any type of content." ]
                }
                |> ExpandableSection.withToggleText "Show more"
                |> ExpandableSection.withToggleTextCollapsed "Show less"
                |> ExpandableSection.toMarkup theme
            )
        , exampleSection theme "Usage note"
            (Element.paragraph [ Font.size 14, Font.color (Theme.text theme) ]
                [ Element.text "Expandable sections are useful for progressive disclosure of content, keeping the interface clean while allowing access to additional details." ]
            )
        ]


exampleSection : Theme -> String -> Element msg -> Element msg
exampleSection theme title content =
    Card.card [ content ]
        |> Card.withTitle title
        |> Card.toMarkup theme
