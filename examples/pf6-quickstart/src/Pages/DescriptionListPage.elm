module Pages.DescriptionListPage exposing (view)

import Element exposing (Element)
import Element.Font as Font
import PF6.Card as Card
import PF6.DescriptionList as DescriptionList
import PF6.Theme as Theme exposing (Theme)
import PF6.Title as Title
import PF6.Tokens as Tokens


view : Theme -> Element msg
view theme =
    Element.column [ Element.width Element.fill, Element.spacing 24 ]
        [ Title.title "Description List" |> Title.withH1 |> Title.toMarkup theme
        , Element.paragraph [ Font.size 14, Font.color (Theme.text theme) ]
            [ Element.text "Description lists display term/value pairs, often used for metadata or details panels." ]
        , exampleSection theme "Vertical (default)"
            (DescriptionList.descriptionList
                [ DescriptionList.group "Name" [ Element.text "John Doe" ]
                , DescriptionList.group "Email" [ Element.text "john@example.com" ]
                , DescriptionList.group "Role" [ Element.text "Administrator" ]
                ]
                |> DescriptionList.toMarkup theme
            )
        , exampleSection theme "Horizontal"
            (DescriptionList.descriptionList
                [ DescriptionList.group "Status" [ Element.text "Active" ]
                , DescriptionList.group "Created" [ Element.text "2024-01-15" ]
                , DescriptionList.group "Last login" [ Element.text "2 hours ago" ]
                ]
                |> DescriptionList.withHorizontal
                |> DescriptionList.toMarkup theme
            )
        , exampleSection theme "Compact"
            (DescriptionList.descriptionList
                [ DescriptionList.group "CPU" [ Element.text "4 cores" ]
                , DescriptionList.group "Memory" [ Element.text "16 GB" ]
                , DescriptionList.group "Storage" [ Element.text "500 GB SSD" ]
                ]
                |> DescriptionList.withCompact
                |> DescriptionList.toMarkup theme
            )
        ]


exampleSection : Theme -> String -> Element msg -> Element msg
exampleSection theme title content =
    Card.card [ content ]
        |> Card.withTitle title
        |> Card.toMarkup theme
