module Pages.TablePage exposing (view)

import Element exposing (Element)
import Element.Font as Font
import PF6.Card as Card
import PF6.Table as Table
import PF6.Title as Title
import PF6.Tokens as Tokens


type alias Person =
    { name : String
    , role : String
    , status : String
    }


sampleData : List Person
sampleData =
    [ { name = "Alice", role = "Engineer", status = "Active" }
    , { name = "Bob", role = "Designer", status = "Active" }
    , { name = "Carol", role = "Manager", status = "Inactive" }
    , { name = "Dave", role = "Engineer", status = "Active" }
    , { name = "Eve", role = "Analyst", status = "Active" }
    ]


view : Element msg
view =
    Element.column [ Element.width Element.fill, Element.spacing 24 ]
        [ Title.title "Table" |> Title.withH1 |> Title.toMarkup
        , Element.paragraph [ Font.size 14, Font.color Tokens.colorText ]
            [ Element.text "Tables organize and display data efficiently in rows and columns." ]
        , exampleSection "Basic table"
            (Table.table
                { columns =
                    [ Table.column { key = "name", label = "Name", view = \p -> Element.text p.name }
                    , Table.column { key = "role", label = "Role", view = \p -> Element.text p.role }
                    , Table.column { key = "status", label = "Status", view = \p -> Element.text p.status }
                    ]
                , rows = sampleData
                }
                |> Table.toMarkup
            )
        , exampleSection "Striped table"
            (Table.table
                { columns =
                    [ Table.column { key = "name", label = "Name", view = \p -> Element.text p.name }
                    , Table.column { key = "role", label = "Role", view = \p -> Element.text p.role }
                    , Table.column { key = "status", label = "Status", view = \p -> Element.text p.status }
                    ]
                , rows = sampleData
                }
                |> Table.withStriped
                |> Table.toMarkup
            )
        , exampleSection "Compact bordered table"
            (Table.table
                { columns =
                    [ Table.column { key = "name", label = "Name", view = \p -> Element.text p.name }
                    , Table.column { key = "role", label = "Role", view = \p -> Element.text p.role }
                    , Table.column { key = "status", label = "Status", view = \p -> Element.text p.status }
                    ]
                , rows = sampleData
                }
                |> Table.withCompact
                |> Table.withBordered
                |> Table.toMarkup
            )
        ]


exampleSection : String -> Element msg -> Element msg
exampleSection title content =
    Card.card [ content ]
        |> Card.withTitle title
        |> Card.toMarkup
