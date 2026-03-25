module Pages.PaginationPage exposing (view)

import Element exposing (Element)
import Element.Font as Font
import PF6.Card as Card
import PF6.Pagination as Pagination
import PF6.Theme as Theme exposing (Theme)
import PF6.Title as Title
import PF6.Tokens as Tokens


view :
    Theme
    ->
        { page : Int
        , onPageChange : Int -> msg
        }
    -> Element msg
view theme config =
    Element.column [ Element.width Element.fill, Element.spacing 24 ]
        [ Title.title "Pagination" |> Title.withH1 |> Title.toMarkup theme
        , Element.paragraph [ Font.size 14, Font.color (Theme.text theme) ]
            [ Element.text "Pagination allows users to navigate through large data sets by breaking content into pages." ]
        , exampleSection theme "Basic pagination"
            (Pagination.pagination { page = config.page, onPageChange = config.onPageChange }
                |> Pagination.withTotalItems 100
                |> Pagination.withPerPage 10
                |> Pagination.toMarkup theme
            )
        , exampleSection theme "Compact pagination"
            (Pagination.pagination { page = config.page, onPageChange = config.onPageChange }
                |> Pagination.withTotalItems 50
                |> Pagination.withPerPage 10
                |> Pagination.withCompact
                |> Pagination.toMarkup theme
            )
        ]


exampleSection : Theme -> String -> Element msg -> Element msg
exampleSection theme title content =
    Card.card [ content ]
        |> Card.withTitle title
        |> Card.toMarkup theme
