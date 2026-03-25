module Pages.TilePage exposing (view)

import Element exposing (Element)
import Element.Font as Font
import PF6.Card as Card
import PF6.Theme as Theme exposing (Theme)
import PF6.Tile as Tile
import PF6.Title as Title
import PF6.Tokens as Tokens


view : Theme -> msg -> Element msg
view theme noOp =
    Element.column [ Element.width Element.fill, Element.spacing 24 ]
        [ Title.title "Tile" |> Title.withH1 |> Title.toMarkup theme
        , Element.paragraph [ Font.size 14, Font.color (Theme.text theme) ]
            [ Element.text "Tiles are selectable items that represent a choice, similar to radio buttons but with a larger click target." ]
        , exampleSection theme "Basic tiles"
            (Element.wrappedRow [ Element.spacing 12 ]
                [ Tile.tile { title = "Option A", onSelect = noOp } |> Tile.toMarkup theme
                , Tile.tile { title = "Option B", onSelect = noOp } |> Tile.withSelected |> Tile.toMarkup theme
                , Tile.tile { title = "Option C", onSelect = noOp } |> Tile.toMarkup theme
                ]
            )
        , exampleSection theme "Disabled tile"
            (Tile.tile { title = "Unavailable", onSelect = noOp }
                |> Tile.withDisabled
                |> Tile.toMarkup theme
            )
        , exampleSection theme "Stacked tiles"
            (Element.wrappedRow [ Element.spacing 12 ]
                [ Tile.tile { title = "Stacked A", onSelect = noOp } |> Tile.withStacked |> Tile.toMarkup theme
                , Tile.tile { title = "Stacked B", onSelect = noOp } |> Tile.withStacked |> Tile.withSelected |> Tile.toMarkup theme
                ]
            )
        ]


exampleSection : Theme -> String -> Element msg -> Element msg
exampleSection theme title content =
    Card.card [ content ]
        |> Card.withTitle title
        |> Card.toMarkup theme
