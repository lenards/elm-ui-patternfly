module Pages.EmptyStatePage exposing (view)

import Element exposing (Element)
import Element.Font as Font
import PF6.Button as Button
import PF6.Card as Card
import PF6.EmptyState as EmptyState
import PF6.Theme as Theme exposing (Theme)
import PF6.Title as Title
import PF6.Tokens as Tokens


view : Theme -> msg -> Element msg
view theme noOp =
    Element.column [ Element.width Element.fill, Element.spacing 24 ]
        [ Title.title "Empty State" |> Title.withH1 |> Title.toMarkup theme
        , Element.paragraph [ Font.size 14, Font.color (Theme.text theme) ]
            [ Element.text "Empty states are used when there is no data to display in a component or page." ]
        , exampleSection theme "Basic empty state"
            (EmptyState.emptyState
                |> EmptyState.withTitleH1 "No results found"
                |> EmptyState.withBody "No results match your filter criteria. Clear all filters and try again."
                |> EmptyState.withPrimaryAction
                    (Button.primary { label = "Clear filters", onPress = Just noOp } |> Button.toMarkup theme)
                |> EmptyState.toMarkup theme
            )
        , exampleSection theme "Small empty state"
            (EmptyState.emptyState
                |> EmptyState.withTitleH2 "No data available"
                |> EmptyState.withBody "There is nothing to display at this time."
                |> EmptyState.withSmallSize
                |> EmptyState.toMarkup theme
            )
        ]


exampleSection : Theme -> String -> Element msg -> Element msg
exampleSection theme title content =
    Card.card [ content ]
        |> Card.withTitle title
        |> Card.toMarkup theme
