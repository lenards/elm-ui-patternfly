module Pages.ToolbarPage exposing (view)

import Element exposing (Element)
import Element.Font as Font
import PF6.Button as Button
import PF6.Card as Card
import PF6.Theme as Theme exposing (Theme)
import PF6.Title as Title
import PF6.Toolbar as Toolbar
import PF6.Tokens as Tokens


view : Theme -> msg -> Element msg
view theme noOp =
    Element.column [ Element.width Element.fill, Element.spacing 24 ]
        [ Title.title "Toolbar" |> Title.withH1 |> Title.toMarkup theme
        , Element.paragraph [ Font.size 14, Font.color (Theme.text theme) ]
            [ Element.text "Toolbars group actions, filters, and controls above a content area." ]
        , exampleSection theme "Basic toolbar"
            (Toolbar.toolbar
                [ Toolbar.toolbarItem (Element.el [ Font.size 14 ] (Element.text "Filter results"))
                , Toolbar.toolbarSeparator
                , Toolbar.toolbarItem (Button.primary { label = "Action", onPress = Just noOp } |> Button.toMarkup theme)
                ]
                |> Toolbar.toMarkup theme
            )
        , exampleSection theme "With item count"
            (Toolbar.toolbar
                [ Toolbar.toolbarItem (Element.el [ Font.size 14 ] (Element.text "Filters"))
                , Toolbar.toolbarItem (Button.secondary { label = "Apply", onPress = Just noOp } |> Button.toMarkup theme)
                ]
                |> Toolbar.withItemCount "37 items"
                |> Toolbar.toMarkup theme
            )
        , exampleSection theme "Grouped items"
            (Toolbar.toolbar
                [ Toolbar.toolbarGroup
                    [ Toolbar.toolbarItem (Button.secondary { label = "Edit", onPress = Just noOp } |> Button.toMarkup theme)
                    , Toolbar.toolbarItem (Button.secondary { label = "Clone", onPress = Just noOp } |> Button.toMarkup theme)
                    ]
                , Toolbar.toolbarSeparator
                , Toolbar.toolbarItem (Button.danger { label = "Delete", onPress = Just noOp } |> Button.toMarkup theme)
                ]
                |> Toolbar.toMarkup theme
            )
        ]


exampleSection : Theme -> String -> Element msg -> Element msg
exampleSection theme title content =
    Card.card [ content ]
        |> Card.withTitle title
        |> Card.toMarkup theme
