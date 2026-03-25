module Pages.SpinnerPage exposing (view)

import Element exposing (Element)
import Element.Font as Font
import PF6.Card as Card
import PF6.Spinner as Spinner
import PF6.Title as Title
import PF6.Tokens as Tokens


view : Element msg
view =
    Element.column [ Element.width Element.fill, Element.spacing 24 ]
        [ Title.title "Spinner" |> Title.withH1 |> Title.toMarkup
        , Element.paragraph [ Font.size 14, Font.color Tokens.colorText ]
            [ Element.text "Spinners indicate that an action is in progress." ]
        , exampleSection "Sizes"
            (Element.wrappedRow [ Element.spacing 24 ]
                [ Element.column [ Element.spacing 4 ]
                    [ Spinner.spinner |> Spinner.withSmallSize |> Spinner.toMarkup
                    , Element.el [ Font.size 12, Font.color Tokens.colorTextSubtle ] (Element.text "Small")
                    ]
                , Element.column [ Element.spacing 4 ]
                    [ Spinner.spinner |> Spinner.withMediumSize |> Spinner.toMarkup
                    , Element.el [ Font.size 12, Font.color Tokens.colorTextSubtle ] (Element.text "Medium")
                    ]
                , Element.column [ Element.spacing 4 ]
                    [ Spinner.spinner |> Spinner.withLargeSize |> Spinner.toMarkup
                    , Element.el [ Font.size 12, Font.color Tokens.colorTextSubtle ] (Element.text "Large")
                    ]
                , Element.column [ Element.spacing 4 ]
                    [ Spinner.spinner |> Spinner.withXLargeSize |> Spinner.toMarkup
                    , Element.el [ Font.size 12, Font.color Tokens.colorTextSubtle ] (Element.text "Extra Large")
                    ]
                ]
            )
        ]


exampleSection : String -> Element msg -> Element msg
exampleSection title content =
    Card.card [ content ]
        |> Card.withTitle title
        |> Card.toMarkup
