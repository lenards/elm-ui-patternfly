module Pages.BreadcrumbPage exposing (view)

import Element exposing (Element)
import Element.Font as Font
import PF6.Breadcrumb as Breadcrumb
import PF6.Card as Card
import PF6.Theme as Theme exposing (Theme)
import PF6.Title as Title
import PF6.Tokens as Tokens


view : Theme -> Element msg
view theme =
    Element.column [ Element.width Element.fill, Element.spacing 24 ]
        [ Title.title "Breadcrumb" |> Title.withH1 |> Title.toMarkup theme
        , Element.paragraph [ Font.size 14, Font.color (Theme.text theme) ]
            [ Element.text "Breadcrumbs provide users with a sense of location within a hierarchy." ]
        , exampleSection theme "Basic breadcrumb"
            (Breadcrumb.breadcrumb
                [ Breadcrumb.item { label = "Home", href = "#" }
                , Breadcrumb.item { label = "Components", href = "#" }
                , Breadcrumb.currentItem "Breadcrumb"
                ]
                |> Breadcrumb.toMarkup theme
            )
        , exampleSection theme "Long breadcrumb"
            (Breadcrumb.breadcrumb
                [ Breadcrumb.item { label = "Home", href = "#" }
                , Breadcrumb.item { label = "Section", href = "#" }
                , Breadcrumb.item { label = "Subsection", href = "#" }
                , Breadcrumb.item { label = "Category", href = "#" }
                , Breadcrumb.currentItem "Current page"
                ]
                |> Breadcrumb.toMarkup theme
            )
        ]


exampleSection : Theme -> String -> Element msg -> Element msg
exampleSection theme title content =
    Card.card [ content ]
        |> Card.withTitle title
        |> Card.toMarkup theme
