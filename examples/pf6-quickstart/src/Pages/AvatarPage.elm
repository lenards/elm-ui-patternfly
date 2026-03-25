module Pages.AvatarPage exposing (view)

import Element exposing (Element)
import Element.Font as Font
import PF6.Avatar as Avatar
import PF6.Card as Card
import PF6.Title as Title
import PF6.Tokens as Tokens


view : Element msg
view =
    Element.column [ Element.width Element.fill, Element.spacing 24 ]
        [ Title.title "Avatar" |> Title.withH1 |> Title.toMarkup
        , Element.paragraph [ Font.size 14, Font.color Tokens.colorText ]
            [ Element.text "An avatar displays a user's profile image with optional border and size variants." ]
        , exampleSection "Sizes"
            (Element.wrappedRow [ Element.spacing 16 ]
                [ Avatar.avatar { src = "avatar.svg", alt = "Small avatar" }
                    |> Avatar.withSmallSize
                    |> Avatar.toMarkup
                , Avatar.avatar { src = "avatar.svg", alt = "Medium avatar" }
                    |> Avatar.withMediumSize
                    |> Avatar.toMarkup
                , Avatar.avatar { src = "avatar.svg", alt = "Large avatar" }
                    |> Avatar.withLargeSize
                    |> Avatar.toMarkup
                , Avatar.avatar { src = "avatar.svg", alt = "Extra-large avatar" }
                    |> Avatar.withXLargeSize
                    |> Avatar.toMarkup
                ]
            )
        , exampleSection "With border"
            (Avatar.avatar { src = "avatar.svg", alt = "Bordered avatar" }
                |> Avatar.withLargeSize
                |> Avatar.withBorder
                |> Avatar.toMarkup
            )
        ]


exampleSection : String -> Element msg -> Element msg
exampleSection title content =
    Card.card [ content ]
        |> Card.withTitle title
        |> Card.toMarkup
