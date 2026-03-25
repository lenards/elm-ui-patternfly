module Views.OverlaysView exposing (view)

import Element exposing (Element)
import Element.Background as Bg
import Element.Border as Border
import Element.Font as Font
import PF6.Accordion as Accordion
import PF6.Backdrop as Backdrop
import PF6.Button as Button
import PF6.Dropdown as Dropdown
import PF6.ExpandableSection as ExpandableSection
import PF6.Menu as Menu
import PF6.Modal as Modal
import PF6.Theme as Theme exposing (Theme)
import PF6.Tokens as Tokens
import PF6.Tooltip as Tooltip
import Types exposing (Model, Msg(..))


section : Theme -> String -> List (Element Msg) -> Element Msg
section theme heading items =
    Element.column
        [ Element.width Element.fill
        , Element.spacing Tokens.spacerMd
        , Element.padding Tokens.spacerMd
        , Bg.color (Theme.backgroundDefault theme)
        , Border.rounded Tokens.radiusMd
        , Border.solid
        , Border.width 1
        , Border.color (Theme.borderDefault theme)
        ]
        (Element.el [ Font.bold, Font.size Tokens.fontSizeLg, Font.color (Theme.text theme) ]
            (Element.text heading)
            :: items
        )


view : Model -> Element Msg
view model =
    let
        theme =
            Theme.fromMode model.themeMode
    in
    Element.column
        [ Element.width Element.fill
        , Element.spacing Tokens.spacerLg
        , Element.inFront
            (if model.modalOpen then
                Modal.modal
                    |> Modal.withTitle "Confirm action"
                    |> Modal.withBody
                        (Element.paragraph [ Font.size Tokens.fontSizeMd, Font.color Tokens.colorText ]
                            [ Element.text "Are you sure you want to perform this action? This cannot be undone." ]
                        )
                    |> Modal.withFooter
                        (Element.row [ Element.spacing Tokens.spacerSm ]
                            [ Button.primary { label = "Confirm", onPress = Just ModalClose }
                                |> Button.toMarkup theme
                            , Button.secondary { label = "Cancel", onPress = Just ModalClose }
                                |> Button.toMarkup theme
                            ]
                        )
                    |> Modal.withCloseMsg ModalClose
                    |> Modal.toMarkup theme

             else if model.backdropVisible then
                Backdrop.backdrop (BackdropToggled False)
                    |> Backdrop.withOpacity 0.3
                    |> Backdrop.toMarkup theme

             else
                Element.none
            )
        ]
        [ Element.el [ Font.size Tokens.fontSize2xl, Font.bold, Font.color (Theme.text theme) ]
            (Element.text "Overlays")

        -- MODAL
        , section theme
            "Modal"
            [ Element.column [ Element.spacing Tokens.spacerSm ]
                [ Button.primary { label = "Open modal", onPress = Just ModalOpen }
                    |> Button.toMarkup theme
                , Element.el [ Font.size Tokens.fontSizeSm, Font.color (Theme.textSubtle theme) ]
                    (Element.text
                        (if model.modalOpen then
                            "Modal is open — see overlay above"

                         else
                            "Modal is closed"
                        )
                    )
                ]
            ]

        -- TOOLTIP
        , section theme
            "Tooltip"
            [ Element.wrappedRow [ Element.spacing Tokens.spacerLg ]
                [ Tooltip.tooltip
                    { trigger =
                        Button.secondary { label = "Hover me (top)", onPress = Nothing }
                            |> Button.toMarkup theme
                    , content = "This tooltip appears above the trigger"
                    }
                    |> Tooltip.withTop
                    |> Tooltip.toMarkup theme
                , Tooltip.tooltip
                    { trigger =
                        Button.secondary { label = "Hover me (bottom)", onPress = Nothing }
                            |> Button.toMarkup theme
                    , content = "This tooltip appears below the trigger"
                    }
                    |> Tooltip.withBottom
                    |> Tooltip.toMarkup theme
                , Tooltip.tooltip
                    { trigger =
                        Button.secondary { label = "Hover me (left)", onPress = Nothing }
                            |> Button.toMarkup theme
                    , content = "This tooltip appears to the left"
                    }
                    |> Tooltip.withLeft
                    |> Tooltip.toMarkup theme
                , Tooltip.tooltip
                    { trigger =
                        Button.secondary { label = "Hover me (right)", onPress = Nothing }
                            |> Button.toMarkup theme
                    , content = "This tooltip appears to the right"
                    }
                    |> Tooltip.withRight
                    |> Tooltip.toMarkup theme
                ]
            ]

        -- DROPDOWN
        , section theme
            "Dropdown"
            [ Dropdown.dropdown
                { toggleLabel = "Actions"
                , isOpen = model.dropdownOpen
                , onToggle = DropdownToggled
                , items =
                    [ Dropdown.dropdownItem "Edit" NoOp
                    , Dropdown.dropdownItem "Duplicate" NoOp
                    , Dropdown.dropdownDivider
                    , Dropdown.dropdownItem "Delete" NoOp
                    ]
                }
                |> Dropdown.toMarkup theme
            ]

        -- ACCORDION
        , section theme
            "Accordion"
            [ Accordion.accordion
                [ Accordion.item
                    { title = "What is PatternFly?"
                    , body =
                        Element.paragraph [ Font.size Tokens.fontSizeMd, Font.color (Theme.text theme) ]
                            [ Element.text "PatternFly is an open source design system built to drive consistency and unify teams." ]
                    , isExpanded = model.accordionExpanded == Just "acc1"
                    , onToggle = AccordionToggled "acc1"
                    }
                , Accordion.item
                    { title = "What is elm-ui?"
                    , body =
                        Element.paragraph [ Font.size Tokens.fontSizeMd, Font.color (Theme.text theme) ]
                            [ Element.text "elm-ui is a library for creating interfaces in Elm. It provides layout, spacing, and styling primitives that generate HTML and CSS." ]
                    , isExpanded = model.accordionExpanded == Just "acc2"
                    , onToggle = AccordionToggled "acc2"
                    }
                , Accordion.item
                    { title = "Why combine them?"
                    , body =
                        Element.paragraph [ Font.size Tokens.fontSizeMd, Font.color (Theme.text theme) ]
                            [ Element.text "Combining PatternFly's design tokens and component patterns with elm-ui's type-safe layout system gives you a robust, accessible UI toolkit." ]
                    , isExpanded = model.accordionExpanded == Just "acc3"
                    , onToggle = AccordionToggled "acc3"
                    }
                ]
                |> Accordion.toMarkup theme
            ]

        -- MENU
        , section theme
            "Menu"
            [ Element.row [ Element.spacing Tokens.spacerLg, Element.width Element.fill ]
                [ Element.el [ Element.width (Element.px 280) ]
                    (Menu.menu
                        [ Menu.menuHeader "Actions"
                        , Menu.menuItem "Edit" (MenuItemClicked "edit")
                            |> Menu.withItemIcon (Element.text "\u{270F}")
                        , Menu.menuItem "Duplicate" (MenuItemClicked "duplicate")
                            |> Menu.withItemIcon (Element.text "\u{2398}")
                            |> Menu.withItemDescription "Create a copy"
                        , Menu.menuDivider
                        , Menu.menuItem "Share" (MenuItemClicked "share")
                            |> Menu.withItemSelected
                        , Menu.menuItem "Disabled item" (MenuItemClicked "disabled")
                            |> Menu.withItemDisabled
                        , Menu.menuDivider
                        , Menu.menuItem "Delete" (MenuItemClicked "delete")
                            |> Menu.withItemDanger
                            |> Menu.withItemIcon (Element.text "\u{2717}")
                        ]
                        |> Menu.withMaxHeight 300
                        |> Menu.toMarkup theme
                    )
                ]
            ]

        -- BACKDROP
        , section theme
            "Backdrop"
            [ Element.column [ Element.spacing Tokens.spacerSm ]
                [ Element.paragraph [ Font.size Tokens.fontSizeMd, Font.color (Theme.textSubtle theme) ]
                    [ Element.text "The Backdrop component provides a semi-transparent overlay. It is used internally by Modal. Click the button below to toggle a demo backdrop." ]
                , Button.secondary { label = "Toggle backdrop", onPress = Just (BackdropToggled (not model.backdropVisible)) }
                    |> Button.toMarkup theme
                ]
            ]

        -- EXPANDABLE SECTION
        , section theme
            "ExpandableSection"
            [ ExpandableSection.expandableSection
                { body =
                    Element.column [ Element.spacing Tokens.spacerSm ]
                        [ Element.paragraph [ Font.size Tokens.fontSizeMd, Font.color (Theme.textSubtle theme) ]
                            [ Element.text "These are advanced settings. Only modify if you know what you are doing." ]
                        , Element.text "• Debug mode: off"
                        , Element.text "• Verbose logging: off"
                        , Element.text "• Cache TTL: 300s"
                        ]
                , isExpanded = model.sectionExpanded
                , onToggle = SectionToggled
                }
                |> ExpandableSection.withToggleText "Hide advanced options"
                |> ExpandableSection.withToggleTextCollapsed "Show advanced options"
                |> ExpandableSection.toMarkup theme
            ]
        ]
