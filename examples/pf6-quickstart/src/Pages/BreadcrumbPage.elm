module Pages.BreadcrumbPage exposing (view)

import Element exposing (Element)
import Element.Font as Font
import PF6.Breadcrumb as Breadcrumb
import PF6.Card as Card
import PF6.Title as Title
import PF6.Tokens as Tokens


view : Element msg
view =
    Element.column [ Element.width Element.fill, Element.spacing 24 ]
        [ Title.title "Breadcrumb" |> Title.withH1 |> Title.toMarkup
        , Element.paragraph [ Font.size 14, Font.color Tokens.colorText ]
            [ Element.text "Breadcrumbs provide users with a sense of location within a hierarchy." ]
        , exampleSection "Basic breadcrumb"
            (Breadcrumb.breadcrumb
                [ Breadcrumb.item { label = "Home", href = "#" }
                , Breadcrumb.item { label = "Components", href = "#" }
                , Breadcrumb.currentItem "Breadcrumb"
                ]
                |> Breadcrumb.toMarkup
            )
        , exampleSection "Long breadcrumb"
            (Breadcrumb.breadcrumb
                [ Breadcrumb.item { label = "Home", href = "#" }
                , Breadcrumb.item { label = "Section", href = "#" }
                , Breadcrumb.item { label = "Subsection", href = "#" }
                , Breadcrumb.item { label = "Category", href = "#" }
                , Breadcrumb.currentItem "Current page"
                ]
                |> Breadcrumb.toMarkup
            )
        ]


exampleSection : String -> Element msg -> Element msg
exampleSection title content =
    Card.card [ content ]
        |> Card.withTitle title
        |> Card.toMarkup
