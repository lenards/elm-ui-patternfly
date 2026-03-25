module Pages.SearchInputPage exposing (view)

import Element exposing (Element)
import Element.Font as Font
import PF6.Card as Card
import PF6.SearchInput as SearchInput
import PF6.Title as Title
import PF6.Tokens as Tokens


view :
    { searchValue : String
    , onSearchChange : String -> msg
    , onSearchClear : msg
    }
    -> Element msg
view config =
    Element.column [ Element.width Element.fill, Element.spacing 24 ]
        [ Title.title "Search Input" |> Title.withH1 |> Title.toMarkup
        , Element.paragraph [ Font.size 14, Font.color Tokens.colorText ]
            [ Element.text "Search inputs allow users to search and filter content." ]
        , exampleSection "Basic search input"
            (SearchInput.searchInput { value = config.searchValue, onChange = config.onSearchChange }
                |> SearchInput.withPlaceholder "Search..."
                |> SearchInput.withAriaLabel "Search"
                |> SearchInput.toMarkup
            )
        , exampleSection "With clear button"
            (SearchInput.searchInput { value = config.searchValue, onChange = config.onSearchChange }
                |> SearchInput.withPlaceholder "Search with clear"
                |> SearchInput.withClearMsg config.onSearchClear
                |> SearchInput.toMarkup
            )
        ]


exampleSection : String -> Element msg -> Element msg
exampleSection title content =
    Card.card [ content ]
        |> Card.withTitle title
        |> Card.toMarkup
