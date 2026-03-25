module Pages.SidebarLayoutPage exposing (view)

import Element exposing (Element)
import Element.Background as Bg
import Element.Border as Border
import Element.Font as Font
import PF6.Card as Card
import PF6.Sidebar as SidebarLayout
import PF6.Title as Title
import PF6.Tokens as Tokens


view : Element msg
view =
    Element.column [ Element.width Element.fill, Element.spacing 24 ]
        [ Title.title "Sidebar" |> Title.withH1 |> Title.toMarkup
        , Element.paragraph [ Font.size 14, Font.color Tokens.colorText ]
            [ Element.text "The Sidebar layout creates a content area with a side panel, useful for navigation or filtering." ]
        , exampleSection "Basic sidebar layout"
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
                |> SidebarLayout.toMarkup
            )
        , exampleSection "Panel on right with gutter"
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
                |> SidebarLayout.toMarkup
            )
        ]


exampleSection : String -> Element msg -> Element msg
exampleSection title content =
    Card.card [ content ]
        |> Card.withTitle title
        |> Card.toMarkup
