module Pages.DataListPage exposing (view)

import Element exposing (Element)
import Element.Font as Font
import PF6.Card as Card
import PF6.DataList as DataList
import PF6.Theme as Theme exposing (Theme)
import PF6.Title as Title
import PF6.Tokens as Tokens


view : Theme -> Element msg
view theme =
    Element.column [ Element.width Element.fill, Element.spacing 24 ]
        [ Title.title "Data List" |> Title.withH1 |> Title.toMarkup theme
        , Element.paragraph [ Font.size 14, Font.color (Theme.text theme) ]
            [ Element.text "Data lists display data in a flexible list format, suitable for data with varied display needs." ]
        , exampleSection theme "Basic data list"
            (DataList.dataList
                [ DataList.item
                    [ DataList.cell (Element.text "Primary content")
                    , DataList.cell (Element.text "Secondary content")
                    ]
                , DataList.item
                    [ DataList.cell (Element.text "Second row primary")
                    , DataList.cell (Element.text "Second row secondary")
                    ]
                , DataList.item
                    [ DataList.cell (Element.text "Third row primary")
                    , DataList.cell (Element.text "Third row secondary")
                    ]
                ]
                |> DataList.toMarkup theme
            )
        , exampleSection theme "Compact data list"
            (DataList.dataList
                [ DataList.item [ DataList.cell (Element.text "Item A") ]
                , DataList.item [ DataList.cell (Element.text "Item B") ]
                , DataList.item [ DataList.cell (Element.text "Item C") ]
                ]
                |> DataList.withCompact
                |> DataList.toMarkup theme
            )
        ]


exampleSection : Theme -> String -> Element msg -> Element msg
exampleSection theme title content =
    Card.card [ content ]
        |> Card.withTitle title
        |> Card.toMarkup theme
