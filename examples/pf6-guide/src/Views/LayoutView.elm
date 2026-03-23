module Views.LayoutView exposing (view)

import Element exposing (Element)
import Element.Background as Bg
import Element.Border as Border
import Element.Font as Font
import PF6.Button as Button
import PF6.Card as Card
import PF6.Drawer as Drawer
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
