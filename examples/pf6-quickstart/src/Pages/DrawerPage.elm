module Pages.DrawerPage exposing (view)

import Element exposing (Element)
import Element.Background as Bg
import Element.Font as Font
import PF6.Card as Card
import PF6.Drawer as Drawer
import PF6.Title as Title
import PF6.Tokens as Tokens


view :
    { drawerExpanded : Bool
    , onToggle : msg
    }
    -> Element msg
view config =
    Element.column [ Element.width Element.fill, Element.spacing 24 ]
        [ Title.title "Drawer" |> Title.withH1 |> Title.toMarkup
        , Element.paragraph [ Font.size 14, Font.color Tokens.colorText ]
            [ Element.text "Drawers are sliding panels that provide supplemental content without leaving the page." ]
        , exampleSection "Inline drawer"
            (Drawer.drawer
                (Element.column [ Element.spacing 8, Element.padding 16 ]
                    [ Element.paragraph [ Font.size 14 ] [ Element.text "Main content area. The drawer panel slides in from the right." ]
                    , Element.el
                        [ Element.padding 8
                        , Bg.color Tokens.colorPrimary
                        , Font.color Tokens.colorTextOnDark
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
                |> Drawer.toMarkup
            )
        ]


exampleSection : String -> Element msg -> Element msg
exampleSection title content =
    Card.card [ content ]
        |> Card.withTitle title
        |> Card.toMarkup
