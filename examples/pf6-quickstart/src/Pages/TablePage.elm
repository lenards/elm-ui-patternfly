module Pages.TablePage exposing (view)

import Element exposing (Element)
import Element.Font as Font
import PF6.Card as Card
import PF6.Table as Table
import PF6.Theme as Theme exposing (Theme)
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


view : Theme -> Element msg
view theme =
    Element.column [ Element.width Element.fill, Element.spacing 24 ]
        [ Title.title "Table" |> Title.withH1 |> Title.toMarkup theme
        , Element.paragraph [ Font.size 14, Font.color (Theme.text theme) ]
            [ Element.text "Tables organize and display data efficiently in rows and columns." ]
        , exampleSection theme "Basic table"
            (Table.table
                { columns =
                    [ Table.column { key = "name", label = "Name", view = \p -> Element.text p.name }
                    , Table.column { key = "role", label = "Role", view = \p -> Element.text p.role }
                    , Table.column { key = "status", label = "Status", view = \p -> Element.text p.status }
                    ]
                , rows = sampleData
                }
                |> Table.toMarkup theme
            )
        , exampleSection theme "Striped table"
            (Table.table
                { columns =
                    [ Table.column { key = "name", label = "Name", view = \p -> Element.text p.name }
                    , Table.column { key = "role", label = "Role", view = \p -> Element.text p.role }
                    , Table.column { key = "status", label = "Status", view = \p -> Element.text p.status }
                    ]
                , rows = sampleData
                }
                |> Table.withStriped
                |> Table.toMarkup theme
            )
        , exampleSection theme "Compact bordered table"
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
                |> Table.toMarkup theme
            )
        ]


exampleSection : Theme -> String -> Element msg -> Element msg
exampleSection theme title content =
    Card.card [ content ]
        |> Card.withTitle title
        |> Card.toMarkup theme
