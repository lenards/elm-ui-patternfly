module Pages.AvatarPage exposing (view)

import Element exposing (Element)
import Element.Font as Font
import PF6.Avatar as Avatar
import PF6.Card as Card
import PF6.Theme as Theme exposing (Theme)
import PF6.Title as Title
import PF6.Tokens as Tokens


view : Theme -> Element msg
view theme =
    Element.column [ Element.width Element.fill, Element.spacing 24 ]
        [ Title.title "Avatar" |> Title.withH1 |> Title.toMarkup theme
        , Element.paragraph [ Font.size 14, Font.color (Theme.text theme) ]
            [ Element.text "An avatar displays a user's profile image with optional border and size variants." ]
        , exampleSection theme "Sizes"
            (Element.wrappedRow [ Element.spacing 16 ]
                [ Avatar.avatar { src = "avatar.svg", alt = "Small avatar" }
                    |> Avatar.withSmallSize
                    |> Avatar.toMarkup theme
                , Avatar.avatar { src = "avatar.svg", alt = "Medium avatar" }
                    |> Avatar.withMediumSize
                    |> Avatar.toMarkup theme
                , Avatar.avatar { src = "avatar.svg", alt = "Large avatar" }
                    |> Avatar.withLargeSize
                    |> Avatar.toMarkup theme
                , Avatar.avatar { src = "avatar.svg", alt = "Extra-large avatar" }
                    |> Avatar.withXLargeSize
                    |> Avatar.toMarkup theme
                ]
            )
        , exampleSection theme "With border"
            (Avatar.avatar { src = "avatar.svg", alt = "Bordered avatar" }
                |> Avatar.withLargeSize
                |> Avatar.withBorder
                |> Avatar.toMarkup theme
            )
        ]


exampleSection : Theme -> String -> Element msg -> Element msg
exampleSection theme title content =
    Card.card [ content ]
        |> Card.withTitle title
        |> Card.toMarkup theme
