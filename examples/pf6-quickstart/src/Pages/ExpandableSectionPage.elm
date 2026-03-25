module Pages.ExpandableSectionPage exposing (view)

import Element exposing (Element)
import Element.Font as Font
import PF6.Card as Card
import PF6.ExpandableSection as ExpandableSection
import PF6.Title as Title
import PF6.Tokens as Tokens


view :
    { expanded : Bool
    , onToggle : Bool -> msg
    }
    -> Element msg
view config =
    Element.column [ Element.width Element.fill, Element.spacing 24 ]
        [ Title.title "Expandable Section" |> Title.withH1 |> Title.toMarkup
        , Element.paragraph [ Font.size 14, Font.color Tokens.colorText ]
            [ Element.text "Expandable sections toggle the visibility of content." ]
        , exampleSection "Basic expandable section"
            (ExpandableSection.expandableSection
                { isExpanded = config.expanded
                , onToggle = config.onToggle
                , body =
                    Element.paragraph [ Font.size 14 ]
                        [ Element.text "This content is revealed when the section is expanded. It can contain any type of content." ]
                }
                |> ExpandableSection.withToggleText "Show more"
                |> ExpandableSection.withToggleTextCollapsed "Show less"
                |> ExpandableSection.toMarkup
            )
        , exampleSection "Usage note"
            (Element.paragraph [ Font.size 14, Font.color Tokens.colorText ]
                [ Element.text "Expandable sections are useful for progressive disclosure of content, keeping the interface clean while allowing access to additional details." ]
            )
        ]


exampleSection : String -> Element msg -> Element msg
exampleSection title content =
    Card.card [ content ]
        |> Card.withTitle title
        |> Card.toMarkup
