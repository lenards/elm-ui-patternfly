module Pages.PopoverPage exposing (view)

import Element exposing (Element)
import Element.Font as Font
import PF6.Card as Card
import PF6.Popover as Popover
import PF6.Theme as Theme exposing (Theme)
import PF6.Title as Title
import PF6.Tokens as Tokens


view :
    Theme
    ->
        { popoverVisible : Bool
        , onToggle : Bool -> msg
        , onClose : msg
        }
    -> Element msg
view theme config =
    Element.column [ Element.width Element.fill, Element.spacing 24 ]
        [ Title.title "Popover" |> Title.withH1 |> Title.toMarkup theme
        , Element.paragraph [ Font.size 14, Font.color (Theme.text theme) ]
            [ Element.text "Popovers display rich content in an overlay anchored to a trigger element." ]
        , exampleSection theme "Basic popover"
            (Popover.popover
                { trigger = Element.el [ Element.padding 8, Font.size 14, Font.color (Theme.primary theme), Element.pointer ] (Element.text "[Click to toggle popover]")
                , isOpen = config.popoverVisible
                , onToggle = config.onToggle
                }
                |> Popover.withTitle "Popover title"
                |> Popover.withBody (Element.paragraph [ Font.size 14 ] [ Element.text "This is the popover body content. Popovers are useful for providing additional context." ])
                |> Popover.withOnClose config.onClose
                |> Popover.toMarkup theme
            )
        , exampleSection theme "Usage note"
            (Element.paragraph [ Font.size 14, Font.color (Theme.text theme) ]
                [ Element.text "Popovers support top, bottom, left, and right positioning and can include a title, body, and footer." ]
            )
        ]


exampleSection : Theme -> String -> Element msg -> Element msg
exampleSection theme title content =
    Card.card [ content ]
        |> Card.withTitle title
        |> Card.toMarkup theme
