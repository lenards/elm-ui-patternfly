module Pages.SearchInputPage exposing (view)

import Element exposing (Element)
import Element.Font as Font
import PF6.Card as Card
import PF6.SearchInput as SearchInput
import PF6.Theme as Theme exposing (Theme)
import PF6.Title as Title
import PF6.Tokens as Tokens


view :
    Theme
    ->
        { searchValue : String
        , onSearchChange : String -> msg
        , onSearchClear : msg
        }
    -> Element msg
view theme config =
    Element.column [ Element.width Element.fill, Element.spacing 24 ]
        [ Title.title "Search Input" |> Title.withH1 |> Title.toMarkup theme
        , Element.paragraph [ Font.size 14, Font.color (Theme.text theme) ]
            [ Element.text "Search inputs allow users to search and filter content." ]
        , exampleSection theme "Basic search input"
            (SearchInput.searchInput { value = config.searchValue, onChange = config.onSearchChange }
                |> SearchInput.withPlaceholder "Search..."
                |> SearchInput.withAriaLabel "Search"
                |> SearchInput.toMarkup theme
            )
        , exampleSection theme "With clear button"
            (SearchInput.searchInput { value = config.searchValue, onChange = config.onSearchChange }
                |> SearchInput.withPlaceholder "Search with clear"
                |> SearchInput.withClearMsg config.onSearchClear
                |> SearchInput.toMarkup theme
            )
        ]


exampleSection : Theme -> String -> Element msg -> Element msg
exampleSection theme title content =
    Card.card [ content ]
        |> Card.withTitle title
        |> Card.toMarkup theme
