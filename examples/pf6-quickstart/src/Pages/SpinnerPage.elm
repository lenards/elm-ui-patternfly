module Pages.SpinnerPage exposing (view)

import Element exposing (Element)
import Element.Font as Font
import PF6.Card as Card
import PF6.Spinner as Spinner
import PF6.Theme as Theme exposing (Theme)
import PF6.Title as Title
import PF6.Tokens as Tokens


view : Theme -> Element msg
view theme =
    Element.column [ Element.width Element.fill, Element.spacing 24 ]
        [ Title.title "Spinner" |> Title.withH1 |> Title.toMarkup theme
        , Element.paragraph [ Font.size 14, Font.color (Theme.text theme) ]
            [ Element.text "Spinners indicate that an action is in progress." ]
        , exampleSection theme "Sizes"
            (Element.wrappedRow [ Element.spacing 24 ]
                [ Element.column [ Element.spacing 4 ]
                    [ Spinner.spinner |> Spinner.withSmallSize |> Spinner.toMarkup theme
                    , Element.el [ Font.size 12, Font.color (Theme.textSubtle theme) ] (Element.text "Small")
                    ]
                , Element.column [ Element.spacing 4 ]
                    [ Spinner.spinner |> Spinner.withMediumSize |> Spinner.toMarkup theme
                    , Element.el [ Font.size 12, Font.color (Theme.textSubtle theme) ] (Element.text "Medium")
                    ]
                , Element.column [ Element.spacing 4 ]
                    [ Spinner.spinner |> Spinner.withLargeSize |> Spinner.toMarkup theme
                    , Element.el [ Font.size 12, Font.color (Theme.textSubtle theme) ] (Element.text "Large")
                    ]
                , Element.column [ Element.spacing 4 ]
                    [ Spinner.spinner |> Spinner.withXLargeSize |> Spinner.toMarkup theme
                    , Element.el [ Font.size 12, Font.color (Theme.textSubtle theme) ] (Element.text "Extra Large")
                    ]
                ]
            )
        ]


exampleSection : Theme -> String -> Element msg -> Element msg
exampleSection theme title content =
    Card.card [ content ]
        |> Card.withTitle title
        |> Card.toMarkup theme
