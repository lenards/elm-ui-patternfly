module Pages.DrawerPage exposing (view)

import Element exposing (Element)
import Element.Background as Bg
import Element.Font as Font
import PF6.Card as Card
import PF6.Drawer as Drawer
import PF6.Theme as Theme exposing (Theme)
import PF6.Title as Title
import PF6.Tokens as Tokens


view :
    Theme
    ->
        { drawerExpanded : Bool
        , onToggle : msg
        }
    -> Element msg
view theme config =
    Element.column [ Element.width Element.fill, Element.spacing 24 ]
        [ Title.title "Drawer" |> Title.withH1 |> Title.toMarkup theme
        , Element.paragraph [ Font.size 14, Font.color (Theme.text theme) ]
            [ Element.text "Drawers are sliding panels that provide supplemental content without leaving the page." ]
        , exampleSection theme "Inline drawer"
            (Drawer.drawer
                (Element.column [ Element.spacing 8, Element.padding 16 ]
                    [ Element.paragraph [ Font.size 14 ] [ Element.text "Main content area. The drawer panel slides in from the right." ]
                    , Element.el
                        [ Element.padding 8
                        , Bg.color (Theme.primary theme)
                        , Font.color (Theme.textOnDark theme)
                        , Font.size 14
                        , Element.pointer
                        ]
                        (Element.text
                            (if config.drawerExpanded then
                                "Close panel"

                             else
                                "Open panel"
                            )
                        )
                    ]
                )
                |> Drawer.withPanel
                    (Element.column [ Element.padding 16, Element.spacing 8 ]
                        [ Element.el [ Font.bold, Font.size 14 ] (Element.text "Drawer panel")
                        , Element.paragraph [ Font.size 14 ] [ Element.text "This is the drawer panel content." ]
                        ]
                    )
                |> Drawer.withExpanded config.drawerExpanded
                |> Drawer.withInline
                |> Drawer.toMarkup theme
            )
        ]


exampleSection : Theme -> String -> Element msg -> Element msg
exampleSection theme title content =
    Card.card [ content ]
        |> Card.withTitle title
        |> Card.toMarkup theme
