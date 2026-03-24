module Views.LayoutView exposing (view)

import Element exposing (Element)
import Element.Background as Bg
import Element.Border as Border
import Element.Font as Font
import PF6.BackToTop as BackToTop
import PF6.Brand as Brand
import PF6.Button as Button
import PF6.Card as Card
import PF6.Drawer as Drawer
import PF6.Masthead as Masthead
import PF6.Panel as Panel
import PF6.Sidebar as Sidebar
import PF6.SkipToContent as SkipToContent
import PF6.Tokens as Tokens
import Types exposing (Model, Msg(..))


section : String -> List (Element Msg) -> Element Msg
section heading items =
    Element.column
        [ Element.width Element.fill
        , Element.spacing Tokens.spacerMd
        , Element.padding Tokens.spacerMd
        , Bg.color Tokens.colorBackgroundDefault
        , Border.rounded Tokens.radiusMd
        , Border.solid
        , Border.width 1
        , Border.color Tokens.colorBorderDefault
        ]
        (Element.el [ Font.bold, Font.size Tokens.fontSizeLg, Font.color Tokens.colorText ]
            (Element.text heading)
            :: items
        )


view : Model -> Element Msg
view model =
    Element.column
        [ Element.width Element.fill
        , Element.spacing Tokens.spacerLg
        ]
        [ Element.el [ Font.size Tokens.fontSize2xl, Font.bold, Font.color Tokens.colorText ]
            (Element.text "Layout")

        -- SKIP TO CONTENT
        , section "SkipToContent"
            [ Element.column [ Element.spacing Tokens.spacerSm ]
                [ Element.paragraph [ Font.size Tokens.fontSizeMd, Font.color Tokens.colorTextSubtle ]
                    [ Element.text "SkipToContent provides an accessibility skip-navigation link that is visually hidden until focused via keyboard. Place it at the very top of the page layout." ]
                , SkipToContent.skipToContent { href = "#main-content", label = "Skip to main content" }
                    |> SkipToContent.toMarkup
                , Element.el [ Font.size Tokens.fontSizeSm, Font.color Tokens.colorTextSubtle ]
                    (Element.text "(Tab to this section to reveal the skip link)")
                ]
            ]

        -- CARD
        , section "Card"
            [ Element.wrappedRow [ Element.spacing Tokens.spacerMd ]
                [ Card.card
                    [ Element.paragraph [ Font.size Tokens.fontSizeMd, Font.color Tokens.colorTextSubtle ]
                        [ Element.text "A basic card with title and body content. Cards are used to group related information." ]
                    ]
                    |> Card.withTitle "Basic card"
                    |> Card.toMarkup
                , Card.card
                    [ Element.paragraph [ Font.size Tokens.fontSizeMd, Font.color Tokens.colorTextSubtle ]
                        [ Element.text "This card has a footer with action buttons." ]
                    , Element.el [ Element.paddingEach { top = Tokens.spacerSm, right = 0, bottom = 0, left = 0 } ]
                        (Button.primary { label = "View details", onPress = Nothing }
                            |> Button.withSmallSize
                            |> Button.toMarkup
                        )
                    ]
                    |> Card.withTitle "Card with actions"
                    |> Card.toMarkup
                , Card.card
                    [ Element.paragraph [ Font.size Tokens.fontSizeMd, Font.color Tokens.colorTextSubtle ]
                        [ Element.text "A flat card variant without the default box shadow." ]
                    ]
                    |> Card.withTitle "Flat card"
                    |> Card.withFlat
                    |> Card.toMarkup
                , Card.card
                    [ Element.paragraph [ Font.size Tokens.fontSizeMd, Font.color Tokens.colorTextSubtle ]
                        [ Element.text "A compact card with reduced padding." ]
                    ]
                    |> Card.withTitle "Compact card"
                    |> Card.withCompact
                    |> Card.toMarkup
                ]
            ]

        -- PANEL
        , section "Panel"
            [ Element.wrappedRow [ Element.spacing Tokens.spacerMd, Element.width Element.fill ]
                [ Panel.panel (Element.text "Basic panel content")
                    |> Panel.withBordered
                    |> Panel.toMarkup
                , Panel.panel (Element.text "Panel with header and footer")
                    |> Panel.withBordered
                    |> Panel.withHeader (Element.el [ Font.bold ] (Element.text "Panel Header"))
                    |> Panel.withFooter (Element.el [ Font.size Tokens.fontSizeSm, Font.color Tokens.colorTextSubtle ] (Element.text "Panel Footer"))
                    |> Panel.toMarkup
                , Panel.panel (Element.text "Raised panel with shadow")
                    |> Panel.withRaised
                    |> Panel.toMarkup
                ]
            ]

        -- SIDEBAR
        , section "Sidebar"
            [ Sidebar.sidebar
                { content =
                    Element.paragraph
                        [ Element.padding Tokens.spacerMd
                        , Font.size Tokens.fontSizeMd
                        , Font.color Tokens.colorTextSubtle
                        ]
                        [ Element.text "This is the main content area. The sidebar panel is on the left by default. You can use withPanelRight to move it." ]
                , panel =
                    Element.column
                        [ Element.padding Tokens.spacerMd
                        , Bg.color Tokens.colorBackgroundSecondary
                        , Element.width Element.fill
                        , Element.height Element.fill
                        , Element.spacing Tokens.spacerSm
                        ]
                        [ Element.el [ Font.bold, Font.size Tokens.fontSizeMd ] (Element.text "Sidebar Panel")
                        , Element.text "Navigation or filters here"
                        ]
                }
                |> Sidebar.withGutter
                |> Sidebar.withPanelWidth 180
                |> Sidebar.toMarkup
            ]

        -- MASTHEAD
        , section "Masthead"
            [ Masthead.masthead
                |> Masthead.withBrand
                    (Element.el [ Font.bold, Font.size Tokens.fontSizeLg, Font.color Tokens.colorTextOnDark ]
                        (Element.text "My App")
                    )
                |> Masthead.withContent
                    (Element.el [ Font.color (Element.rgb255 160 160 160), Font.size Tokens.fontSizeMd ]
                        (Element.text "Dashboard")
                    )
                |> Masthead.withToolbar
                    (Element.el [ Font.color Tokens.colorTextOnDark ] (Element.text "\u{2699}"))
                |> Masthead.toMarkup
            ]

        -- BACK TO TOP
        , section "BackToTop"
            [ Element.paragraph [ Font.size Tokens.fontSizeMd, Font.color Tokens.colorTextSubtle ]
                [ Element.text "The BackToTop button is rendered as a fixed-position element in the bottom-right corner. A demo button is shown below (non-fixed for visibility):" ]
            , Button.primary { label = "\u{2191} Back to top", onPress = Just ScrollToTop }
                |> Button.withSmallSize
                |> Button.toMarkup
            ]

        -- DRAWER
        , section "Drawer"
            [ Element.column [ Element.spacing Tokens.spacerSm, Element.width Element.fill ]
                [ Button.secondary { label = "Toggle drawer", onPress = Just (DrawerToggled (not model.drawerOpen)) }
                    |> Button.toMarkup
                , Drawer.drawer
                    (Element.paragraph
                        [ Font.size Tokens.fontSizeMd
                        , Font.color Tokens.colorTextSubtle
                        , Element.padding Tokens.spacerMd
                        ]
                        [ Element.text "Main content area. Click the button above to toggle the drawer panel. The drawer slides in from the right without pushing the main content." ]
                    )
                    |> Drawer.withPanelHead
                        (Element.el [ Font.bold, Font.size Tokens.fontSizeLg, Font.color Tokens.colorText, Element.padding Tokens.spacerMd ]
                            (Element.text "Drawer panel")
                        )
                    |> Drawer.withPanelBody
                        (Element.paragraph [ Font.size Tokens.fontSizeMd, Font.color Tokens.colorTextSubtle, Element.padding Tokens.spacerMd ]
                            [ Element.text "This is the drawer panel content. It slides in from the right side of the page." ]
                        )
                    |> Drawer.withExpanded model.drawerOpen
                    |> Drawer.toMarkup
                ]
            ]
        ]
