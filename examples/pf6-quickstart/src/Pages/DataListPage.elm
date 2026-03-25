module Pages.DataListPage exposing (view)

import Element exposing (Element)
import Element.Font as Font
import PF6.Card as Card
import PF6.DataList as DataList
import PF6.Title as Title
import PF6.Tokens as Tokens


view : Element msg
view =
    Element.column [ Element.width Element.fill, Element.spacing 24 ]
        [ Title.title "Data List" |> Title.withH1 |> Title.toMarkup
        , Element.paragraph [ Font.size 14, Font.color Tokens.colorText ]
            [ Element.text "Data lists display data in a flexible list format, suitable for data with varied display needs." ]
        , exampleSection "Basic data list"
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
                |> DataList.toMarkup
            )
        , exampleSection "Compact data list"
            (DataList.dataList
                [ DataList.item [ DataList.cell (Element.text "Item A") ]
                , DataList.item [ DataList.cell (Element.text "Item B") ]
                , DataList.item [ DataList.cell (Element.text "Item C") ]
                ]
                |> DataList.withCompact
                |> DataList.toMarkup
            )
        ]


exampleSection : String -> Element msg -> Element msg
exampleSection title content =
    Card.card [ content ]
        |> Card.withTitle title
        |> Card.toMarkup
