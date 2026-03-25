module Pages.PageLayoutPage exposing (view)

import Element exposing (Element)
import Element.Background as Bg
import Element.Font as Font
import PF6.Card as Card
import PF6.Page as Page
import PF6.Theme as Theme exposing (Theme)
import PF6.Title as Title
import PF6.Tokens as Tokens


view : Theme -> Element msg
view theme =
    Element.column [ Element.width Element.fill, Element.spacing 24 ]
        [ Title.title "Page" |> Title.withH1 |> Title.toMarkup theme
        , Element.paragraph [ Font.size 14, Font.color (Theme.text theme) ]
            [ Element.text "The Page component provides the overall page structure with masthead, sidebar, breadcrumbs, and main content areas." ]
        , exampleSection theme "Basic page structure"
            (Element.el [ Element.width Element.fill, Element.height (Element.px 300) ]
                (Page.page
                    (Element.el [ Element.padding 16, Font.size 14 ] (Element.text "Main content area"))
                    |> Page.withMasthead
                        (Element.el [ Bg.color (Element.rgb255 21 21 21), Element.width Element.fill, Element.padding 12, Font.color (Theme.textOnDark theme), Font.size 14 ]
                            (Element.text "Masthead")
                        )
                    |> Page.withSidebar
                        (Element.el [ Bg.color (Element.rgb255 245 245 245), Element.width Element.fill, Element.height Element.fill, Element.padding 12, Font.size 14 ]
                            (Element.text "Sidebar")
                        )
                    |> Page.toMarkup theme
                )
            )
        , exampleSection theme "Usage note"
            (Element.paragraph [ Font.size 14, Font.color (Theme.text theme) ]
                [ Element.text "The Page component is typically used as the root layout. It composes Masthead, Sidebar, Breadcrumb, and content areas." ]
            )
        ]


exampleSection : Theme -> String -> Element msg -> Element msg
exampleSection theme title content =
    Card.card [ content ]
        |> Card.withTitle title
        |> Card.toMarkup theme
