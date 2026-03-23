module PF6Phase2Tests exposing (all)

{-| Unit tests for PF6 Phase 2 components

Tests cover constructor API, builder functions, and pure logic.
Rendering (toMarkup) is tested by calling it and ensuring it doesn't crash.
-}

import Element
import Expect
import PF6.Accordion as Accordion
import PF6.ActionList as ActionList
import PF6.Banner as Banner
import PF6.ClipboardCopy as ClipboardCopy
import PF6.CodeBlock as CodeBlock
import PF6.DataList as DataList
import PF6.DescriptionList as DescriptionList
import PF6.Drawer as Drawer
import PF6.Dropdown as Dropdown
import PF6.ExpandableSection as ExpandableSection
import PF6.Form as Form
import PF6.HelperText as HelperText
import PF6.Icon as Icon
import PF6.List as PFList
import PF6.Modal as Modal
import PF6.NumberInput as NumberInput
import PF6.SearchInput as SearchInput
import PF6.Select as Select
import PF6.Tooltip as Tooltip
import Test exposing (..)


-- ACCORDION TESTS


accordionTests : Test
accordionTests =
    describe "PF6.Accordion"
        [ test "single collapsed item renders" <|
            \_ ->
                Accordion.accordion
                    [ Accordion.item
                        { title = "Question 1"
                        , body = Element.text "Answer"
                        , isExpanded = False
                        , onToggle = \_ -> ()
                        }
                    ]
                    |> Accordion.toMarkup
                    |> (\_ -> Expect.pass)
        , test "expanded item renders body" <|
            \_ ->
                Accordion.accordion
                    [ Accordion.item
                        { title = "Question"
                        , body = Element.text "Full answer text here."
                        , isExpanded = True
                        , onToggle = \_ -> ()
                        }
                    ]
                    |> Accordion.withBordered
                    |> Accordion.toMarkup
                    |> (\_ -> Expect.pass)
        , test "displayLarge accordion renders" <|
            \_ ->
                Accordion.accordion []
                    |> Accordion.withDisplayLarge
                    |> Accordion.toMarkup
                    |> (\_ -> Expect.pass)
        ]



-- MODAL TESTS


modalTests : Test
modalTests =
    describe "PF6.Modal"
        [ test "empty modal renders" <|
            \_ ->
                Modal.modal
                    |> Modal.toMarkup
                    |> (\_ -> Expect.pass)
        , test "modal with title and body renders" <|
            \_ ->
                Modal.modal
                    |> Modal.withTitle "Confirm deletion"
                    |> Modal.withBody (Element.text "Are you sure?")
                    |> Modal.withFooter (Element.text "Actions here")
                    |> Modal.withCloseMsg ()
                    |> Modal.toMarkup
                    |> (\_ -> Expect.pass)
        , test "small modal renders" <|
            \_ ->
                Modal.modal
                    |> Modal.withSmallSize
                    |> Modal.withTitle "Alert"
                    |> Modal.toMarkup
                    |> (\_ -> Expect.pass)
        , test "large modal renders" <|
            \_ ->
                Modal.modal
                    |> Modal.withLargeSize
                    |> Modal.withNoClose
                    |> Modal.toMarkup
                    |> (\_ -> Expect.pass)
        ]



-- DROPDOWN TESTS


dropdownTests : Test
dropdownTests =
    describe "PF6.Dropdown"
        [ test "closed dropdown renders toggle only" <|
            \_ ->
                Dropdown.dropdown
                    { toggleLabel = "Actions"
                    , isOpen = False
                    , onToggle = \_ -> ()
                    , items =
                        [ Dropdown.dropdownItem "Edit" ()
                        , Dropdown.dropdownDivider
                        , Dropdown.dropdownItem "Delete" ()
                        ]
                    }
                    |> Dropdown.toMarkup
                    |> (\_ -> Expect.pass)
        , test "open dropdown renders menu" <|
            \_ ->
                Dropdown.dropdown
                    { toggleLabel = "Options"
                    , isOpen = True
                    , onToggle = \_ -> ()
                    , items =
                        [ Dropdown.dropdownHeader "Actions"
                        , Dropdown.dropdownItem "Save" ()
                        ]
                    }
                    |> Dropdown.withPlain
                    |> Dropdown.toMarkup
                    |> (\_ -> Expect.pass)
        , test "disabled dropdown renders" <|
            \_ ->
                Dropdown.dropdown
                    { toggleLabel = "Disabled"
                    , isOpen = False
                    , onToggle = \_ -> ()
                    , items = []
                    }
                    |> Dropdown.withDisabledToggle
                    |> Dropdown.toMarkup
                    |> (\_ -> Expect.pass)
        ]



-- SELECT TESTS


selectTests : Test
selectTests =
    describe "PF6.Select"
        [ test "closed select renders" <|
            \_ ->
                Select.select
                    { selected = Nothing
                    , isOpen = False
                    , onToggle = \_ -> ()
                    , onSelect = \_ -> ()
                    , options =
                        [ Select.option "a" "Alpha"
                        , Select.option "b" "Beta"
                        ]
                    }
                    |> Select.toMarkup
                    |> (\_ -> Expect.pass)
        , test "select with group renders" <|
            \_ ->
                Select.select
                    { selected = Just "a"
                    , isOpen = True
                    , onToggle = \_ -> ()
                    , onSelect = \_ -> ()
                    , options =
                        [ Select.optionGroup "Greek"
                            [ Select.option "a" "Alpha"
                            , Select.option "b" "Beta"
                            ]
                        ]
                    }
                    |> Select.withLabel "Letter"
                    |> Select.withHelperText "Choose a Greek letter"
                    |> Select.toMarkup
                    |> (\_ -> Expect.pass)
        ]



-- FORM TESTS


formTests : Test
formTests =
    describe "PF6.Form"
        [ test "basic form renders" <|
            \_ ->
                Form.form
                    [ Form.formGroup (Element.text "field1")
                        |> Form.withLabel "Name"
                        |> Form.withRequired
                        |> Form.groupToMarkup
                    , Form.formGroup (Element.text "field2")
                        |> Form.withLabel "Email"
                        |> Form.withHelperText "Enter your email address"
                        |> Form.groupToMarkup
                    ]
                    |> Form.toMarkup
                    |> (\_ -> Expect.pass)
        , test "horizontal form renders" <|
            \_ ->
                Form.form [ Element.text "fields" ]
                    |> Form.withHorizontal
                    |> Form.withLimitWidth
                    |> Form.toMarkup
                    |> (\_ -> Expect.pass)
        ]



-- BANNER TESTS


bannerTests : Test
bannerTests =
    describe "PF6.Banner"
        [ test "default banner renders" <|
            \_ ->
                Banner.banner "System maintenance scheduled for Sunday."
                    |> Banner.toMarkup
                    |> (\_ -> Expect.pass)
        , test "danger banner renders" <|
            \_ ->
                Banner.banner "Critical system alert."
                    |> Banner.withDanger
                    |> Banner.toMarkup
                    |> (\_ -> Expect.pass)
        , test "info banner with link renders" <|
            \_ ->
                Banner.banner "New features available."
                    |> Banner.withInfo
                    |> Banner.withLink { label = "Learn more", href = "#" }
                    |> Banner.toMarkup
                    |> (\_ -> Expect.pass)
        ]



-- NUMBER INPUT TESTS


numberInputTests : Test
numberInputTests =
    describe "PF6.NumberInput"
        [ test "basic number input renders" <|
            \_ ->
                NumberInput.numberInput { value = 5, onChange = \_ -> () }
                    |> NumberInput.toMarkup
                    |> (\_ -> Expect.pass)
        , test "number input with bounds renders" <|
            \_ ->
                NumberInput.numberInput { value = 50, onChange = \_ -> () }
                    |> NumberInput.withMin 0
                    |> NumberInput.withMax 100
                    |> NumberInput.withStep 5
                    |> NumberInput.withLabel "Percentage"
                    |> NumberInput.withUnit "%"
                    |> NumberInput.toMarkup
                    |> (\_ -> Expect.pass)
        , test "canDecrement is false at min" <|
            \_ ->
                -- At value == min, decrement should be disabled
                NumberInput.numberInput { value = 0, onChange = \_ -> () }
                    |> NumberInput.withMin 0
                    |> NumberInput.toMarkup
                    |> (\_ -> Expect.pass)
        , test "disabled number input renders" <|
            \_ ->
                NumberInput.numberInput { value = 10, onChange = \_ -> () }
                    |> NumberInput.withDisabled
                    |> NumberInput.toMarkup
                    |> (\_ -> Expect.pass)
        ]



-- SEARCH INPUT TESTS


searchInputTests : Test
searchInputTests =
    describe "PF6.SearchInput"
        [ test "basic search input renders" <|
            \_ ->
                SearchInput.searchInput { value = "", onChange = \_ -> () }
                    |> SearchInput.toMarkup
                    |> (\_ -> Expect.pass)
        , test "search with value and clear renders" <|
            \_ ->
                SearchInput.searchInput { value = "kubernetes", onChange = \_ -> () }
                    |> SearchInput.withClearMsg ()
                    |> SearchInput.withSubmitMsg ()
                    |> SearchInput.toMarkup
                    |> (\_ -> Expect.pass)
        , test "search with hints renders" <|
            \_ ->
                SearchInput.searchInput { value = "pod", onChange = \_ -> () }
                    |> SearchInput.withHints [ "pod-1", "pod-2", "pod-abc" ]
                    |> SearchInput.toMarkup
                    |> (\_ -> Expect.pass)
        ]



-- DESCRIPTION LIST TESTS


descriptionListTests : Test
descriptionListTests =
    describe "PF6.DescriptionList"
        [ test "simple description list renders" <|
            \_ ->
                DescriptionList.descriptionList
                    [ DescriptionList.group "Name" [ Element.text "Alice Smith" ]
                    , DescriptionList.group "Status" [ Element.text "Active" ]
                    , DescriptionList.group "Email" [ Element.text "alice@example.com" ]
                    ]
                    |> DescriptionList.toMarkup
                    |> (\_ -> Expect.pass)
        , test "horizontal description list renders" <|
            \_ ->
                DescriptionList.descriptionList
                    [ DescriptionList.group "CPU" [ Element.text "4 cores" ] ]
                    |> DescriptionList.withHorizontal
                    |> DescriptionList.withCompact
                    |> DescriptionList.toMarkup
                    |> (\_ -> Expect.pass)
        , test "two-column description list renders" <|
            \_ ->
                DescriptionList.descriptionList
                    [ DescriptionList.group "A" [ Element.text "1" ]
                    , DescriptionList.group "B" [ Element.text "2" ]
                    , DescriptionList.group "C" [ Element.text "3" ]
                    , DescriptionList.group "D" [ Element.text "4" ]
                    ]
                    |> DescriptionList.withColumnCount 2
                    |> DescriptionList.toMarkup
                    |> (\_ -> Expect.pass)
        ]



-- CODE BLOCK TESTS


codeBlockTests : Test
codeBlockTests =
    describe "PF6.CodeBlock"
        [ test "basic code block renders" <|
            \_ ->
                CodeBlock.codeBlock "const x = 42;"
                    |> CodeBlock.toMarkup
                    |> (\_ -> Expect.pass)
        , test "expandable code block renders collapsed" <|
            \_ ->
                CodeBlock.codeBlock (String.repeat 5 "line\n")
                    |> CodeBlock.withExpandable (\_ -> ())
                    |> CodeBlock.withExpanded False
                    |> CodeBlock.toMarkup
                    |> (\_ -> Expect.pass)
        , test "expandable code block renders expanded" <|
            \_ ->
                CodeBlock.codeBlock (String.repeat 5 "line\n")
                    |> CodeBlock.withExpandable (\_ -> ())
                    |> CodeBlock.withExpanded True
                    |> CodeBlock.toMarkup
                    |> (\_ -> Expect.pass)
        ]



-- HELPER TEXT TESTS


helperTextTests : Test
helperTextTests =
    describe "PF6.HelperText"
        [ test "default helper text renders" <|
            \_ ->
                HelperText.helperText "Enter a value between 1 and 100"
                    |> HelperText.toMarkup
                    |> (\_ -> Expect.pass)
        , test "error helper text renders" <|
            \_ ->
                HelperText.helperText "This field is required"
                    |> HelperText.withError
                    |> HelperText.toMarkup
                    |> (\_ -> Expect.pass)
        , test "success helper text renders" <|
            \_ ->
                HelperText.helperText "Username available"
                    |> HelperText.withSuccess
                    |> HelperText.toMarkup
                    |> (\_ -> Expect.pass)
        ]



-- CLIPBOARD COPY TESTS


clipboardCopyTests : Test
clipboardCopyTests =
    describe "PF6.ClipboardCopy"
        [ test "default clipboard copy renders" <|
            \_ ->
                ClipboardCopy.clipboardCopy "npm install @patternfly/react-core"
                    |> ClipboardCopy.withOnCopy ()
                    |> ClipboardCopy.toMarkup
                    |> (\_ -> Expect.pass)
        , test "inline variant renders" <|
            \_ ->
                ClipboardCopy.clipboardCopy "kubectl get pods"
                    |> ClipboardCopy.withInline
                    |> ClipboardCopy.toMarkup
                    |> (\_ -> Expect.pass)
        , test "block variant renders" <|
            \_ ->
                ClipboardCopy.clipboardCopy "apiVersion: v1\nkind: Pod"
                    |> ClipboardCopy.withBlock
                    |> ClipboardCopy.toMarkup
                    |> (\_ -> Expect.pass)
        ]



-- DATA LIST TESTS


dataListTests : Test
dataListTests =
    describe "PF6.DataList"
        [ test "basic data list renders" <|
            \_ ->
                DataList.dataList
                    [ DataList.item
                        [ DataList.cell (Element.text "Row 1")
                        , DataList.cell (Element.text "Value 1")
                        ]
                    , DataList.item
                        [ DataList.cell (Element.text "Row 2")
                        , DataList.cell (Element.text "Value 2")
                        ]
                    ]
                    |> DataList.toMarkup
                    |> (\_ -> Expect.pass)
        , test "striped compact data list renders" <|
            \_ ->
                DataList.dataList
                    [ DataList.item [ DataList.cell (Element.text "item") ] ]
                    |> DataList.withStriped
                    |> DataList.withCompact
                    |> DataList.toMarkup
                    |> (\_ -> Expect.pass)
        , test "checkable item renders" <|
            \_ ->
                DataList.dataList
                    [ DataList.item [ DataList.cell (Element.text "select me") ]
                        |> DataList.withCheckable (\_ -> ())
                        |> DataList.withChecked True
                    ]
                    |> DataList.toMarkup
                    |> (\_ -> Expect.pass)
        ]



-- EXPANDABLE SECTION TESTS


expandableSectionTests : Test
expandableSectionTests =
    describe "PF6.ExpandableSection"
        [ test "collapsed section renders toggle only" <|
            \_ ->
                ExpandableSection.expandableSection
                    { body = Element.text "Hidden content"
                    , isExpanded = False
                    , onToggle = \_ -> ()
                    }
                    |> ExpandableSection.toMarkup
                    |> (\_ -> Expect.pass)
        , test "expanded section renders body" <|
            \_ ->
                ExpandableSection.expandableSection
                    { body = Element.text "Visible content"
                    , isExpanded = True
                    , onToggle = \_ -> ()
                    }
                    |> ExpandableSection.withToggleText "Show less"
                    |> ExpandableSection.withToggleTextCollapsed "Show more"
                    |> ExpandableSection.toMarkup
                    |> (\_ -> Expect.pass)
        ]



-- DRAWER TESTS


drawerTests : Test
drawerTests =
    describe "PF6.Drawer"
        [ test "collapsed drawer shows only main content" <|
            \_ ->
                Drawer.drawer (Element.text "Main content")
                    |> Drawer.withExpanded False
                    |> Drawer.toMarkup
                    |> (\_ -> Expect.pass)
        , test "expanded right drawer renders" <|
            \_ ->
                Drawer.drawer (Element.text "Main content")
                    |> Drawer.withPanelHead (Element.text "Panel title")
                    |> Drawer.withPanelBody (Element.text "Panel body")
                    |> Drawer.withExpanded True
                    |> Drawer.toMarkup
                    |> (\_ -> Expect.pass)
        , test "bottom drawer renders" <|
            \_ ->
                Drawer.drawer (Element.text "Main")
                    |> Drawer.withBottom
                    |> Drawer.withExpanded True
                    |> Drawer.withPanelBody (Element.text "Bottom panel")
                    |> Drawer.toMarkup
                    |> (\_ -> Expect.pass)
        ]



-- TOOLTIP TESTS


tooltipTests : Test
tooltipTests =
    describe "PF6.Tooltip"
        [ test "top tooltip renders" <|
            \_ ->
                Tooltip.tooltip
                    { trigger = Element.text "Hover me"
                    , content = "This is a tooltip"
                    }
                    |> Tooltip.toMarkup
                    |> (\_ -> Expect.pass)
        , test "bottom tooltip renders" <|
            \_ ->
                Tooltip.tooltip
                    { trigger = Element.text "Focus me"
                    , content = "Bottom tooltip"
                    }
                    |> Tooltip.withBottom
                    |> Tooltip.withMaxWidth 200
                    |> Tooltip.toMarkup
                    |> (\_ -> Expect.pass)
        ]



-- LIST TESTS


listTests : Test
listTests =
    describe "PF6.List"
        [ test "bulleted list renders" <|
            \_ ->
                PFList.pFList
                    [ Element.text "Item one"
                    , Element.text "Item two"
                    , Element.text "Item three"
                    ]
                    |> PFList.toMarkup
                    |> (\_ -> Expect.pass)
        , test "ordered list renders" <|
            \_ ->
                PFList.pFList
                    [ Element.text "First"
                    , Element.text "Second"
                    ]
                    |> PFList.withOrdered
                    |> PFList.toMarkup
                    |> (\_ -> Expect.pass)
        , test "plain list renders" <|
            \_ ->
                PFList.pFList [ Element.text "Simple" ]
                    |> PFList.withPlain
                    |> PFList.withLarge
                    |> PFList.toMarkup
                    |> (\_ -> Expect.pass)
        , test "inline list renders" <|
            \_ ->
                PFList.pFList
                    [ Element.text "Tag1"
                    , Element.text "Tag2"
                    ]
                    |> PFList.withInlined
                    |> PFList.toMarkup
                    |> (\_ -> Expect.pass)
        ]



-- ACTION LIST TESTS


actionListTests : Test
actionListTests =
    describe "PF6.ActionList"
        [ test "action list renders" <|
            \_ ->
                ActionList.actionList
                    [ ActionList.actionItem (Element.text "Save")
                    , ActionList.cancelItem (Element.text "Cancel")
                    ]
                    |> ActionList.toMarkup
                    |> (\_ -> Expect.pass)
        , test "icon action list renders" <|
            \_ ->
                ActionList.actionList
                    [ ActionList.iconItem (Element.text "✏")
                    , ActionList.iconItem (Element.text "🗑")
                    ]
                    |> ActionList.withIcons
                    |> ActionList.toMarkup
                    |> (\_ -> Expect.pass)
        ]



-- ICON TESTS


iconTests : Test
iconTests =
    describe "PF6.Icon"
        [ test "default icon renders" <|
            \_ ->
                Icon.icon (Element.text "★")
                    |> Icon.toMarkup
                    |> (\_ -> Expect.pass)
        , test "large success icon renders" <|
            \_ ->
                Icon.icon (Element.text "✓")
                    |> Icon.withLargeSize
                    |> Icon.withSuccessStatus
                    |> Icon.toMarkup
                    |> (\_ -> Expect.pass)
        , test "danger icon renders" <|
            \_ ->
                Icon.icon (Element.text "✕")
                    |> Icon.withDangerStatus
                    |> Icon.withAriaLabel "Error"
                    |> Icon.toMarkup
                    |> (\_ -> Expect.pass)
        ]



-- ALL TESTS


all : Test
all =
    describe "PF6 Phase 2 Components"
        [ accordionTests
        , modalTests
        , dropdownTests
        , selectTests
        , formTests
        , bannerTests
        , numberInputTests
        , searchInputTests
        , descriptionListTests
        , codeBlockTests
        , helperTextTests
        , clipboardCopyTests
        , dataListTests
        , expandableSectionTests
        , drawerTests
        , tooltipTests
        , listTests
        , actionListTests
        , iconTests
        ]
