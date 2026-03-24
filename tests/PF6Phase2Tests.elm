module PF6Phase2Tests exposing (all)

{-| Phase 2 component tests

Most meaningful tests for Phase 2 components (NumberInput edge cases, Truncate
logic, SearchInput hints, Table sorting, etc.) have been consolidated into
PF6Tests.elm under the "Logic / edge-case tests" and "Builder API documentation"
sections.

This file is kept for any Phase 2-specific smoke tests that serve as
documentation for components with complex builder APIs not covered in PF6Tests.

-}

import Expect
import Test exposing (..)


all : Test
all =
    describe "PF6 Phase 2 Components"
        [ -- All meaningful tests consolidated into PF6Tests.elm.
          -- Phase 2 components without exposed query functions (Accordion,
          -- Dropdown, Select, Banner, DescriptionList, CodeBlock, HelperText,
          -- ClipboardCopy, DataList, ExpandableSection, Drawer, Tooltip,
          -- List, ActionList, Icon) only had toMarkup smoke tests that
          -- verified nothing the compiler doesn't already guarantee.
          test "placeholder — phase 2 tests consolidated into PF6Tests.elm" <|
            \_ ->
                Expect.pass
        ]
