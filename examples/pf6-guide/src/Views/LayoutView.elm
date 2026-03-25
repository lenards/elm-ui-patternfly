module Views.LayoutView exposing (view)

import Element exposing (Element)
import Element.Background as Bg
import Element.Border as Border
import Element.Font as Font
import PF6.BackToTop as BackToTop
import PF6.Brand as Brand
import PF6.Bullseye as Bullseye
import PF6.Button as Button
import PF6.Card as Card
import PF6.Drawer as Drawer
import PF6.Flex as Flex
import PF6.Gallery as Gallery
import PF6.Grid as Grid
import PF6.Level as Level
import PF6.Masthead as Masthead
import PF6.Panel as Panel
import PF6.Sidebar as Sidebar
import PF6.SkipToContent as SkipToContent
import PF6.Split as Split
import PF6.Stack as Stack
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


{-| A colored placeholder box for layout demos
-}
demoBox : String -> Element.Color -> Element Msg
demoBox label color =
    Element.el
        [ Bg.color color
        , Element.padding Tokens.spacerSm
        , Border.rounded Tokens.radiusSm
        , Element.width Element.shrink
        ]
        (Element.el [ Font.color Tokens.colorTextOnDark, Font.size Tokens.fontSizeSm ] (Element.text label))


{-| A colored placeholder box that fills width
-}
demoBoxFill : String -> Element.Color -> Element Msg
demoBoxFill label color =
    Element.el
        [ Bg.color color
        , Element.padding Tokens.spacerSm
        , Border.rounded Tokens.radiusSm
        , Element.width Element.fill
        ]
        (Element.el [ Font.color Tokens.colorTextOnDark, Font.size Tokens.fontSizeSm ] (Element.text label))


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

        -- BULLSEYE
        , section "Bullseye"
            [ Element.paragraph [ Font.size Tokens.fontSizeMd, Font.color Tokens.colorTextSubtle ]
                [ Element.text "Bullseye centers content vertically and horizontally in a container." ]
            , Element.el
                [ Element.width Element.fill
                , Element.height (Element.px 200)
                , Bg.color Tokens.colorBackgroundSecondary
                , Border.rounded Tokens.radiusMd
                ]
                (Bullseye.bullseye
                    (Card.card
                        [ Element.text "I am centered!" ]
                        |> Card.withTitle "Centered Card"
                        |> Card.withCompact
                        |> Card.toMarkup
                    )
                    |> Bullseye.withPadding Tokens.spacerMd
                    |> Bullseye.withMinHeight 200
                    |> Bullseye.toMarkup
                )
            ]

        -- STACK
        , section "Stack"
            [ Element.paragraph [ Font.size Tokens.fontSizeMd, Font.color Tokens.colorTextSubtle ]
                [ Element.text "Stack arranges items vertically. One or more items can fill remaining vertical space." ]
            , Element.el
                [ Element.width Element.fill
                , Element.height (Element.px 250)
                , Bg.color Tokens.colorBackgroundSecondary
                , Border.rounded Tokens.radiusMd
                , Element.padding Tokens.spacerSm
                ]
                (Stack.stack
                    [ Stack.stackItem (demoBoxFill "Header" Tokens.colorPrimary)
                    , Stack.stackItem (demoBoxFill "Content (fill)" Tokens.colorInfo) |> Stack.withFill
                    , Stack.stackItem (demoBoxFill "Footer" Tokens.colorPrimary)
                    ]
                    |> Stack.withGutter
                    |> Stack.toMarkup
                )
            ]

        -- SPLIT
        , section "Split"
            [ Element.paragraph [ Font.size Tokens.fontSizeMd, Font.color Tokens.colorTextSubtle ]
                [ Element.text "Split distributes items horizontally. Useful for title + actions headers." ]
            , Split.split
                [ Split.splitItem
                    (Element.el [ Font.bold, Font.size Tokens.fontSizeLg, Font.color Tokens.colorText ]
                        (Element.text "Page Title")
                    )
                    |> Split.withFill
                , Split.splitItem
                    (Element.row [ Element.spacing Tokens.spacerSm ]
                        [ Button.secondary { label = "Cancel", onPress = Nothing } |> Button.withSmallSize |> Button.toMarkup
                        , Button.primary { label = "Save", onPress = Nothing } |> Button.withSmallSize |> Button.toMarkup
                        ]
                    )
                ]
                |> Split.withGutter
                |> Split.toMarkup
            ]

        -- LEVEL
        , section "Level"
            [ Element.paragraph [ Font.size Tokens.fontSizeMd, Font.color Tokens.colorTextSubtle ]
                [ Element.text "Level distributes items evenly, centered horizontally." ]
            , Level.level
                [ demoBox "Status: Active" Tokens.colorSuccess
                , demoBox "CPU: 45%" Tokens.colorInfo
                , demoBox "Memory: 72%" Tokens.colorWarning
                , demoBox "Disk: 89%" Tokens.colorDanger
                ]
                |> Level.withGutter
                |> Level.toMarkup
            ]

        -- GALLERY
        , section "Gallery"
            [ Element.paragraph [ Font.size Tokens.fontSizeMd, Font.color Tokens.colorTextSubtle ]
                [ Element.text "Gallery creates a responsive grid of uniform items with consistent sizing." ]
            , Gallery.gallery
                (List.map
                    (\n ->
                        Card.card
                            [ Element.text ("Card content " ++ String.fromInt n) ]
                            |> Card.withTitle ("Card " ++ String.fromInt n)
                            |> Card.withCompact
                            |> Card.toMarkup
                    )
                    (List.range 1 6)
                )
                |> Gallery.withGutter
                |> Gallery.withMinWidthPx 180
                |> Gallery.withMaxWidthPx 300
                |> Gallery.toMarkup
            ]

        -- GRID
        , section "Grid"
            [ Element.paragraph [ Font.size Tokens.fontSizeMd, Font.color Tokens.colorTextSubtle ]
                [ Element.text "Grid provides a 12-column system. Items specify how many columns they span." ]
            , Grid.grid
                [ Grid.gridItem (demoBoxFill "Span 12" Tokens.colorPrimary)
                , Grid.gridItem (demoBoxFill "Span 6" Tokens.colorInfo) |> Grid.withSpan 6
                , Grid.gridItem (demoBoxFill "Span 6" Tokens.colorInfo) |> Grid.withSpan 6
                , Grid.gridItem (demoBoxFill "Span 4" Tokens.colorSuccess) |> Grid.withSpan 4
                , Grid.gridItem (demoBoxFill "Span 4" Tokens.colorSuccess) |> Grid.withSpan 4
                , Grid.gridItem (demoBoxFill "Span 4" Tokens.colorSuccess) |> Grid.withSpan 4
                , Grid.gridItem (demoBoxFill "Span 8" Tokens.colorWarning) |> Grid.withSpan 8
                , Grid.gridItem (demoBoxFill "Span 4" Tokens.colorDanger) |> Grid.withSpan 4
                ]
                |> Grid.withGutter
                |> Grid.toMarkup
            ]

        -- FLEX
        , section "Flex"
            [ Element.paragraph [ Font.size Tokens.fontSizeMd, Font.color Tokens.colorTextSubtle ]
                [ Element.text "Flex provides configurable direction, alignment, justification, and gap." ]
            , Element.column [ Element.spacing Tokens.spacerMd, Element.width Element.fill ]
                [ Element.el [ Font.size Tokens.fontSizeSm, Font.bold, Font.color Tokens.colorText ] (Element.text "Row with space-between:")
                , Flex.flex
                    [ Flex.flexItem (demoBox "Item 1" Tokens.colorPrimary)
                    , Flex.flexItem (demoBox "Item 2" Tokens.colorInfo)
                    , Flex.flexItem (demoBox "Item 3" Tokens.colorSuccess)
                    ]
                    |> Flex.withJustifySpaceBetween
                    |> Flex.withGapMd
                    |> Flex.toMarkup
                , Element.el [ Font.size Tokens.fontSizeSm, Font.bold, Font.color Tokens.colorText ] (Element.text "Column with center alignment:")
                , Flex.flex
                    [ Flex.flexItem (demoBox "Top" Tokens.colorPrimary)
                    , Flex.flexItem (demoBox "Middle" Tokens.colorInfo)
                    , Flex.flexItem (demoBox "Bottom" Tokens.colorSuccess)
                    ]
                    |> Flex.withColumn
                    |> Flex.withAlignCenter
                    |> Flex.withGapSm
                    |> Flex.toMarkup
                , Element.el [ Font.size Tokens.fontSizeSm, Font.bold, Font.color Tokens.colorText ] (Element.text "Row with grow item:")
                , Flex.flex
                    [ Flex.flexItem (demoBox "Fixed" Tokens.colorPrimary)
                    , Flex.flexItem (demoBoxFill "Grows" Tokens.colorInfo) |> Flex.withGrow
                    , Flex.flexItem (demoBox "Fixed" Tokens.colorPrimary)
                    ]
                    |> Flex.withGapMd
                    |> Flex.toMarkup
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
