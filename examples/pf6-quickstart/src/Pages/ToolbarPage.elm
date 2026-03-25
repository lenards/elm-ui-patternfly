module Pages.ToolbarPage exposing (view)

import Element exposing (Element)
import Element.Font as Font
import PF6.Button as Button
import PF6.Card as Card
import PF6.Title as Title
import PF6.Toolbar as Toolbar
import PF6.Tokens as Tokens


view : msg -> Element msg
view noOp =
    Element.column [ Element.width Element.fill, Element.spacing 24 ]
        [ Title.title "Toolbar" |> Title.withH1 |> Title.toMarkup
        , Element.paragraph [ Font.size 14, Font.color Tokens.colorText ]
            [ Element.text "Toolbars group actions, filters, and controls above a content area." ]
        , exampleSection "Basic toolbar"
            (Toolbar.toolbar
                [ Toolbar.toolbarItem (Element.el [ Font.size 14 ] (Element.text "Filter results"))
                , Toolbar.toolbarSeparator
                , Toolbar.toolbarItem (Button.primary { label = "Action", onPress = Just noOp } |> Button.toMarkup)
                ]
                |> Toolbar.toMarkup
            )
        , exampleSection "With item count"
            (Toolbar.toolbar
                [ Toolbar.toolbarItem (Element.el [ Font.size 14 ] (Element.text "Filters"))
                , Toolbar.toolbarItem (Button.secondary { label = "Apply", onPress = Just noOp } |> Button.toMarkup)
                ]
                |> Toolbar.withItemCount "37 items"
                |> Toolbar.toMarkup
            )
        , exampleSection "Grouped items"
            (Toolbar.toolbar
                [ Toolbar.toolbarGroup
                    [ Toolbar.toolbarItem (Button.secondary { label = "Edit", onPress = Just noOp } |> Button.toMarkup)
                    , Toolbar.toolbarItem (Button.secondary { label = "Clone", onPress = Just noOp } |> Button.toMarkup)
                    ]
                , Toolbar.toolbarSeparator
                , Toolbar.toolbarItem (Button.danger { label = "Delete", onPress = Just noOp } |> Button.toMarkup)
                ]
                |> Toolbar.toMarkup
            )
        ]


exampleSection : String -> Element msg -> Element msg
exampleSection title content =
    Card.card [ content ]
        |> Card.withTitle title
        |> Card.toMarkup
