module Pages.SimpleListPage exposing (view)

import Element exposing (Element)
import Element.Font as Font
import PF6.Card as Card
import PF6.SimpleList as SimpleList
import PF6.Theme as Theme exposing (Theme)
import PF6.Title as Title
import PF6.Tokens as Tokens


view : Theme -> msg -> Element msg
view theme noOp =
    Element.column [ Element.width Element.fill, Element.spacing 24 ]
        [ Title.title "Simple List" |> Title.withH1 |> Title.toMarkup theme
        , Element.paragraph [ Font.size 14, Font.color (Theme.text theme) ]
            [ Element.text "Simple lists provide a flat, selectable list of items." ]
        , exampleSection theme "Basic simple list"
            (SimpleList.simpleList
                [ SimpleList.simpleListItem "Item one" noOp
                , SimpleList.simpleListItem "Item two" noOp |> SimpleList.withItemActive
                , SimpleList.simpleListItem "Item three" noOp
                ]
                |> SimpleList.toMarkup theme
            )
        , exampleSection theme "With disabled item"
            (SimpleList.simpleList
                [ SimpleList.simpleListItem "Active item" noOp
                , SimpleList.simpleListItem "Disabled item" noOp |> SimpleList.withItemDisabled
                , SimpleList.simpleListItem "Another item" noOp
                ]
                |> SimpleList.toMarkup theme
            )
        ]


exampleSection : Theme -> String -> Element msg -> Element msg
exampleSection theme title content =
    Card.card [ content ]
        |> Card.withTitle title
        |> Card.toMarkup theme
