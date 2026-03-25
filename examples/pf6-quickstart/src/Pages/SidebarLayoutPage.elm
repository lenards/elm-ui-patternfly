module Pages.SidebarLayoutPage exposing (view)

import Element exposing (Element)
import Element.Background as Bg
import Element.Border as Border
import Element.Font as Font
import PF6.Card as Card
import PF6.Sidebar as SidebarLayout
import PF6.Theme as Theme exposing (Theme)
import PF6.Title as Title
import PF6.Tokens as Tokens


view : Theme -> Element msg
view theme =
    Element.column [ Element.width Element.fill, Element.spacing 24 ]
        [ Title.title "Sidebar" |> Title.withH1 |> Title.toMarkup theme
        , Element.paragraph [ Font.size 14, Font.color (Theme.text theme) ]
            [ Element.text "The Sidebar layout creates a content area with a side panel, useful for navigation or filtering." ]
        , exampleSection theme "Basic sidebar layout"
            (SidebarLayout.sidebar
                { content =
                    Element.el
                        [ Bg.color (Element.rgb255 240 248 255)
                        , Element.padding 16
                        , Element.width Element.fill
                        , Element.height (Element.px 200)
                        , Font.size 14
                        ]
                        (Element.text "Main content area")
                , panel =
                    Element.el
                        [ Bg.color (Element.rgb255 245 245 245)
                        , Element.padding 16
                        , Element.width Element.fill
                        , Element.height (Element.px 200)
                        , Font.size 14
                        ]
                        (Element.text "Side panel")
                }
                |> SidebarLayout.toMarkup theme
            )
        , exampleSection theme "Panel on right with gutter"
            (SidebarLayout.sidebar
                { content =
                    Element.el
                        [ Bg.color (Element.rgb255 240 248 255)
                        , Element.padding 16
                        , Element.width Element.fill
                        , Element.height (Element.px 150)
                        , Font.size 14
                        ]
                        (Element.text "Content")
                , panel =
                    Element.el
                        [ Bg.color (Element.rgb255 245 245 245)
                        , Element.padding 16
                        , Element.width Element.fill
                        , Element.height (Element.px 150)
                        , Font.size 14
                        ]
                        (Element.text "Right panel")
                }
                |> SidebarLayout.withPanelRight
                |> SidebarLayout.withGutter
                |> SidebarLayout.toMarkup theme
            )
        ]


exampleSection : Theme -> String -> Element msg -> Element msg
exampleSection theme title content =
    Card.card [ content ]
        |> Card.withTitle title
        |> Card.toMarkup theme
