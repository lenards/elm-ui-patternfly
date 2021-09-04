module FirstChapter exposing (firstChapter)

import Element
import ElmBook.Chapter exposing (..)
import Html exposing (..)
import PF4.Button as Button
import PF4.Card as Card
import PF4.Created as Created
import Time


firstChapter : Chapter x
firstChapter =
    chapter "Simple PF4 Components"
        |> withComponent component
        |> render content


component : Html msg
component =
    Element.layout [] <|
        Element.column
            [ Element.width Element.fill
            , Element.height Element.fill
            ]
            [ Card.card
                [ Button.secondary
                    { label = "Example"
                    , onPress = Nothing
                    }
                    |> Button.toMarkup
                , Button.control
                    { label = "Example"
                    , onPress = Nothing
                    }
                    |> Button.toMarkup
                ]
                |> Card.withTitle "Buttons Example"
                |> Card.withBodyPadding 20
                |> Card.toMarkup
            , Card.card
                [ Created.created
                    { createdOn = Time.millisToPosix 1609468521866
                    , now = Time.millisToPosix 1609468694666
                    }
                    |> Created.toMarkup
                ]
                |> Card.withTitle "Created Example"
                |> Card.withBodyPadding 20
                |> Card.toMarkup
            ]


content : String
content =
    """
# Buttons & Created components

You can see some example usages for secondary and control Buttons.

Plus, a Created component that will use when some was created, in days.

<component />

Pretty neat, huh?
"""
