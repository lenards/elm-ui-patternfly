module PF6.Accordion exposing
    ( Accordion, AccordionItem
    , accordion
    , item
    , withBordered, withDisplayLarge, withFixed
    , toMarkup
    )

{-| PF6 Accordion component

Accordions toggle the visibility of sections of content.

See: <https://www.patternfly.org/components/accordion>


# Definition

@docs Accordion, AccordionItem


# Constructor

@docs accordion


# Item constructor

@docs item


# Variant modifiers

@docs withBordered, withDisplayLarge, withFixed


# Rendering

@docs toMarkup

-}

import Element exposing (Element)
import Element.Background as Bg
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import PF6.Theme as Theme exposing (Theme)
import PF6.Tokens as Tokens


{-| Opaque Accordion type
-}
type Accordion msg
    = Accordion (Options msg)


{-| A single accordion item
-}
type AccordionItem msg
    = AccordionItem (ItemOptions msg)


type alias ItemOptions msg =
    { title : String
    , body : Element msg
    , isExpanded : Bool
    , onToggle : Bool -> msg
    }


type alias Options msg =
    { items : List (AccordionItem msg)
    , isBordered : Bool
    , isDisplayLarge : Bool
    , isFixed : Bool
    }


{-| Construct an Accordion from a list of items
-}
accordion : List (AccordionItem msg) -> Accordion msg
accordion items =
    Accordion
        { items = items
        , isBordered = False
        , isDisplayLarge = False
        , isFixed = False
        }


{-| Construct an AccordionItem

    item
        { title = "What is PatternFly?"
        , body = Element.text "PatternFly is..."
        , isExpanded = model.expanded == "pf"
        , onToggle = \open -> SetExpanded (if open then "pf" else "")
        }

-}
item :
    { title : String
    , body : Element msg
    , isExpanded : Bool
    , onToggle : Bool -> msg
    }
    -> AccordionItem msg
item config =
    AccordionItem
        { title = config.title
        , body = config.body
        , isExpanded = config.isExpanded
        , onToggle = config.onToggle
        }


{-| Add borders between items
-}
withBordered : Accordion msg -> Accordion msg
withBordered (Accordion opts) =
    Accordion { opts | isBordered = True }


{-| Larger heading text
-}
withDisplayLarge : Accordion msg -> Accordion msg
withDisplayLarge (Accordion opts) =
    Accordion { opts | isDisplayLarge = True }


{-| Fixed height accordion (overflow scrolls)
-}
withFixed : Accordion msg -> Accordion msg
withFixed (Accordion opts) =
    Accordion { opts | isFixed = True }


renderItem : Theme -> Options msg -> AccordionItem msg -> Element msg
renderItem theme opts (AccordionItem itemOpts) =
    let
        chevron =
            if itemOpts.isExpanded then
                "▲"

            else
                "▼"

        titleSize =
            if opts.isDisplayLarge then
                Tokens.fontSizeLg

            else
                Tokens.fontSizeMd

        headerEl =
            Input.button
                [ Element.width Element.fill
                , Element.paddingXY Tokens.spacerMd Tokens.spacerSm
                , Bg.color
                    (if itemOpts.isExpanded then
                        Theme.backgroundSecondary theme

                     else
                        Theme.backgroundDefault theme
                    )
                ]
                { onPress = Just (itemOpts.onToggle (not itemOpts.isExpanded))
                , label =
                    Element.row
                        [ Element.width Element.fill ]
                        [ Element.el
                            [ Font.size titleSize
                            , Font.bold
                            , Font.color (Theme.text theme)
                            , Element.width Element.fill
                            ]
                            (Element.text itemOpts.title)
                        , Element.el
                            [ Font.size Tokens.fontSizeSm
                            , Font.color (Theme.textSubtle theme)
                            ]
                            (Element.text chevron)
                        ]
                }

        bodyEl =
            if itemOpts.isExpanded then
                Element.el
                    [ Element.width Element.fill
                    , Element.padding Tokens.spacerMd
                    , Font.size Tokens.fontSizeMd
                    , Font.color (Theme.text theme)
                    ]
                    itemOpts.body

            else
                Element.none

        borderAttrs =
            if opts.isBordered then
                [ Border.solid
                , Border.width 1
                , Border.color (Theme.borderDefault theme)
                , Border.rounded Tokens.radiusMd
                ]

            else
                [ Border.widthEach { top = 0, right = 0, bottom = 1, left = 0 }
                , Border.color (Theme.borderSubtle theme)
                ]
    in
    Element.column
        ([ Element.width Element.fill ] ++ borderAttrs)
        [ headerEl
        , bodyEl
        ]


{-| Render the Accordion as an `Element msg`
-}
toMarkup : Theme -> Accordion msg -> Element msg
toMarkup theme (Accordion opts) =
    let
        heightAttr =
            if opts.isFixed then
                [ Element.height (Element.maximum 400 Element.fill)
                , Element.scrollbarY
                ]

            else
                []
    in
    Element.column
        ([ Element.width Element.fill
         , Element.spacing
            (if opts.isBordered then
                Tokens.spacerXs

             else
                0
            )
         ]
            ++ heightAttr
        )
        (List.map (renderItem theme opts) opts.items)
