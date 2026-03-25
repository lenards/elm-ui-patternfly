module Pages.PopoverPage exposing (view)

import Element exposing (Element)
import Element.Font as Font
import PF6.Card as Card
import PF6.Popover as Popover
import PF6.Title as Title
import PF6.Tokens as Tokens


view :
    { popoverVisible : Bool
    , onToggle : Bool -> msg
    , onClose : msg
    }
    -> Element msg
view config =
    Element.column [ Element.width Element.fill, Element.spacing 24 ]
        [ Title.title "Popover" |> Title.withH1 |> Title.toMarkup
        , Element.paragraph [ Font.size 14, Font.color Tokens.colorText ]
            [ Element.text "Popovers display rich content in an overlay anchored to a trigger element." ]
        , exampleSection "Basic popover"
            (Popover.popover
                { trigger = Element.el [ Element.padding 8, Font.size 14, Font.color Tokens.colorPrimary, Element.pointer ] (Element.text "[Click to toggle popover]")
                , isOpen = config.popoverVisible
                , onToggle = config.onToggle
                }
                |> Popover.withTitle "Popover title"
                |> Popover.withBody (Element.paragraph [ Font.size 14 ] [ Element.text "This is the popover body content. Popovers are useful for providing additional context." ])
                |> Popover.withOnClose config.onClose
                |> Popover.toMarkup
            )
        , exampleSection "Usage note"
            (Element.paragraph [ Font.size 14, Font.color Tokens.colorText ]
                [ Element.text "Popovers support top, bottom, left, and right positioning and can include a title, body, and footer." ]
            )
        ]


exampleSection : String -> Element msg -> Element msg
exampleSection title content =
    Card.card [ content ]
        |> Card.withTitle title
        |> Card.toMarkup
