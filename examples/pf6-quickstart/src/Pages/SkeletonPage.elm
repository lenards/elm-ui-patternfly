module Pages.SkeletonPage exposing (view)

import Element exposing (Element)
import Element.Font as Font
import PF6.Card as Card
import PF6.Skeleton as Skeleton
import PF6.Theme as Theme exposing (Theme)
import PF6.Title as Title
import PF6.Tokens as Tokens


view : Theme -> Element msg
view theme =
    Element.column [ Element.width Element.fill, Element.spacing 24 ]
        [ Title.title "Skeleton" |> Title.withH1 |> Title.toMarkup theme
        , Element.paragraph [ Font.size 14, Font.color (Theme.text theme) ]
            [ Element.text "Skeletons are placeholder loading indicators that mimic the layout of content before it loads." ]
        , exampleSection theme "Text lines"
            (Element.column [ Element.spacing 8, Element.width Element.fill ]
                [ Skeleton.skeleton |> Skeleton.withTextLine |> Skeleton.toMarkup theme
                , Skeleton.skeleton |> Skeleton.withTextLine |> Skeleton.withWidth 250 |> Skeleton.toMarkup theme
                , Skeleton.skeleton |> Skeleton.withTextLine |> Skeleton.withWidth 180 |> Skeleton.toMarkup theme
                ]
            )
        , exampleSection theme "Circle"
            (Skeleton.circleSkeleton |> Skeleton.toMarkup theme)
        , exampleSection theme "Square and rectangle"
            (Element.wrappedRow [ Element.spacing 16 ]
                [ Skeleton.skeleton |> Skeleton.withSquare |> Skeleton.toMarkup theme
                , Skeleton.skeleton |> Skeleton.withWidth 200 |> Skeleton.withHeight 100 |> Skeleton.toMarkup theme
                ]
            )
        ]


exampleSection : Theme -> String -> Element msg -> Element msg
exampleSection theme title content =
    Card.card [ content ]
        |> Card.withTitle title
        |> Card.toMarkup theme
