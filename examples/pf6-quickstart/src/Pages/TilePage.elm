module Pages.TilePage exposing (view)

import Element exposing (Element)
import Element.Font as Font
import PF6.Card as Card
import PF6.Tile as Tile
import PF6.Title as Title
import PF6.Tokens as Tokens


view : msg -> Element msg
view noOp =
    Element.column [ Element.width Element.fill, Element.spacing 24 ]
        [ Title.title "Tile" |> Title.withH1 |> Title.toMarkup
        , Element.paragraph [ Font.size 14, Font.color Tokens.colorText ]
            [ Element.text "Tiles are selectable items that represent a choice, similar to radio buttons but with a larger click target." ]
        , exampleSection "Basic tiles"
            (Element.wrappedRow [ Element.spacing 12 ]
                [ Tile.tile { title = "Option A", onSelect = noOp } |> Tile.toMarkup
                , Tile.tile { title = "Option B", onSelect = noOp } |> Tile.withSelected |> Tile.toMarkup
                , Tile.tile { title = "Option C", onSelect = noOp } |> Tile.toMarkup
                ]
            )
        , exampleSection "Disabled tile"
            (Tile.tile { title = "Unavailable", onSelect = noOp }
                |> Tile.withDisabled
                |> Tile.toMarkup
            )
        , exampleSection "Stacked tiles"
            (Element.wrappedRow [ Element.spacing 12 ]
                [ Tile.tile { title = "Stacked A", onSelect = noOp } |> Tile.withStacked |> Tile.toMarkup
                , Tile.tile { title = "Stacked B", onSelect = noOp } |> Tile.withStacked |> Tile.withSelected |> Tile.toMarkup
                ]
            )
        ]


exampleSection : String -> Element msg -> Element msg
exampleSection title content =
    Card.card [ content ]
        |> Card.withTitle title
        |> Card.toMarkup
