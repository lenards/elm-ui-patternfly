# elm-ui-patternfly

An [`elm-ui`](https://package.elm-lang.org/packages/mdgriffith/elm-ui/latest/) implementation of the [PatternFly 6](https://www.patternfly.org/) design system.

**74 components** · **7 layouts** · **Dark mode** · **Elm 0.19.1** · **Builder pattern**

**[Live Demo](https://lenards.github.io/elm-ui-patternfly/)** — Browse all components interactively (with dark mode toggle).

---

## About

`elm-ui-patternfly` brings PatternFly 6's component library to Elm applications built with `elm-ui`. Every component follows the same builder pattern — construct a base value, pipe modifiers through it, and call `toMarkup` to get an `Element msg`. No HTML, no CSS, no class names.

```
elm install lenards/elm-ui-patternfly
```

---

## Quick start

Every component follows the same pattern:

```elm
import PF6.Button as Button
import PF6.Badge as Badge

-- Construct → modify → render
Button.primary { label = "Save", onPress = Just Saved }
    |> Button.withLargeSize
    |> Button.withIcon myIcon
    |> Button.toMarkup

Badge.badge 7
    |> Badge.withOverflowAt 99
    |> Badge.toMarkup
```

All components produce `Element msg` values compatible with any `elm-ui` layout.

---

## Design tokens

`PF6.Tokens` is the foundation of the component library — all colors, spacing, radii, and font sizes come from it. You can use tokens directly in your own layouts for visual consistency:

```elm
import PF6.Tokens as Tokens

Element.el
    [ Element.padding Tokens.spacerMd
    , Bg.color Tokens.colorBackgroundDefault
    , Font.color Tokens.colorText
    , Border.rounded Tokens.radiusMd
    ]
    content
```

Key token groups: `color*`, `spacer*`, `fontSize*`, `radius*`, `fontWeight*`.

### Dark mode

`PF6.Theme` provides a theme system with light and dark palettes:

```elm
import PF6.Theme as Theme exposing (Mode(..), Theme)

theme = Theme.fromMode model.themeMode  -- Light or Dark

Element.el
    [ Bg.color (Theme.backgroundDefault theme)
    , Font.color (Theme.text theme)
    ]
    content
```

The pf6-guide live demo includes a dark mode toggle in the masthead.

---

## Components

### Primitives

  - `PF6.Button` — 7 variants (primary, secondary, tertiary, danger, warning, link, plain), 3 sizes, icon support
  - `PF6.Badge` — numeric count badge with overflow cap and unread variant
  - `PF6.Label` — 8 color variants, outline, compact, closable, icon support
  - `PF6.Avatar` — user avatar image, 3 sizes, optional border
  - `PF6.Icon` — semantic icon wrapper with status colors and 4 sizes
  - `PF6.Title` — heading levels H1–H6 with PF6 sizing
  - `PF6.Divider` — horizontal rule with inset variants

### Feedback & Status

  - `PF6.Alert` — inline alerts — default, success, danger, warning, info; optional close
  - `PF6.Banner` — full-width site banners with optional link
  - `PF6.Spinner` — animated loading indicator, 4 sizes
  - `PF6.Skeleton` — loading placeholder — text lines, circle, and square variants
  - `PF6.EmptyState` — empty state with icon, title, body, and actions
  - `PF6.Progress` — progress bar with status colors and size variants
  - `PF6.HelperText` — form field helper text — default, error, warning, success, indeterminate

### Forms

  - `PF6.TextInput` — text field with label, placeholder, validation states, disabled
  - `PF6.Checkbox` — checkbox with label and optional description
  - `PF6.Radio` — radio button with label and optional description
  - `PF6.Switch` — toggle switch with on/off labels
  - `PF6.NumberInput` — numeric input with increment/decrement, min/max/step, unit suffix
  - `PF6.SearchInput` — search field with clear, submit, and typeahead hints
  - `PF6.Select` — single-select dropdown with option groups
  - `PF6.Form` — form layout with labeled groups, required markers, and helper text

### Navigation

  - `PF6.Breadcrumb` — breadcrumb trail with linked and current-page items
  - `PF6.Tabs` — tab navigation — default, box, vertical, and filled variants
  - `PF6.Pagination` — page navigation with item count and compact variant

### Layout

  - `PF6.Card` — content card with title, footer, flat, compact, and selectable variants
  - `PF6.Page` — page shell with masthead, sidebar, and main content area
  - `PF6.Drawer` — sliding panel — right, left, or bottom; inline or overlay mode

### Overlays

  - `PF6.Modal` — full-viewport modal dialog with title, body, footer, and size variants
  - `PF6.Tooltip` — hover tooltip — top, bottom, left, right positioning
  - `PF6.Popover` — click-triggered overlay with title, body, footer, and close button
  - `PF6.Dropdown` — action dropdown with dividers, headers, and position control
  - `PF6.Accordion` — expandable content sections with bordered and large-display variants
  - `PF6.ExpandableSection` — single toggle-show/hide content block

### Content

  - `PF6.CodeBlock` — read-only code display with expandable variant
  - `PF6.ClipboardCopy` — copy-to-clipboard with inline and block variants
  - `PF6.List` — bulleted, ordered, plain, and inline list variants
  - `PF6.DescriptionList` — term/value pairs — vertical and horizontal layouts
  - `PF6.ActionList` — spaced group of action buttons

### Data

  - `PF6.Table` — data table with sortable columns, striped rows, compact, and bordered variants
  - `PF6.DataList` — flexible list with checkable rows and expandable content
  - `PF6.Toolbar` — filter/sort toolbar with item groups, separator, and item count

### Additional

  - `PF6.BackToTop` — floating scroll-to-top button
  - `PF6.Backdrop` — semi-transparent overlay background
  - `PF6.Brand` — logo/brand image with responsive sizing
  - `PF6.Hint` — contextual hint with lighter styling than Alert
  - `PF6.InputGroup` — groups form controls with shared borders
  - `PF6.JumpLinks` — in-page anchor navigation with subsections
  - `PF6.Masthead` — top header bar with brand, content, and toolbar slots
  - `PF6.Menu` — generic menu with items, dividers, headers, and search
  - `PF6.Navigation` — vertical/horizontal application navigation
  - `PF6.NotificationBadge` — bell icon with unread count overlay
  - `PF6.NotificationDrawer` — slide-out notification panel with variant icons
  - `PF6.Panel` — simple bordered container with header/body/footer
  - `PF6.ProgressStepper` — multi-step progress indicator
  - `PF6.Sidebar` — layout container with sidebar panel and content area
  - `PF6.SimpleList` — clickable list with selection state
  - `PF6.SkipToContent` — accessibility skip-nav link, hidden until focused
  - `PF6.Slider` — range slider input with PF6 styling
  - `PF6.TextArea` — multi-line text input with validation and resize
  - `PF6.TextInputGroup` — input with prefix/suffix elements
  - `PF6.Tile` — selectable card-like option tiles
  - `PF6.Timestamp` — formatted date/time display with optional icon
  - `PF6.ToggleGroup` — button group with toggle selection
  - `PF6.Truncate` — text truncation with tooltip
  - `PF6.Wizard` — multi-step form wizard with sidebar navigation

### Layouts

  - `PF6.Bullseye` — centers content vertically and horizontally
  - `PF6.Flex` — configurable flex layout with direction, alignment, gap
  - `PF6.Gallery` — responsive grid of uniform items with min/max widths
  - `PF6.Grid` — 12-column grid system with percentage-based spans
  - `PF6.Level` — even horizontal distribution of items
  - `PF6.Split` — horizontal layout with fill items and wrapping
  - `PF6.Stack` — vertical layout with fill items

### Theming

  - `PF6.Theme` — light and dark mode color token system
  - `PF6.Tokens` — static design tokens (light mode defaults)

---

## Example app — pf6-guide

The `examples/pf6-guide/` directory contains a full interactive TEA application that demonstrates all 74 components with live state. A live version is deployed automatically to **[lenards.github.io/elm-ui-patternfly](https://lenards.github.io/elm-ui-patternfly/)** on every push to `main`.

```bash
cd examples/pf6-guide
npm install           # install dev tools (first time only)
npm run build         # compile Elm → main.js
npm run serve         # serve on http://localhost:8001
```

Or if you just want to compile and open directly without a server:

```bash
cd examples/pf6-guide
elm make src/Main.elm --output=main.js
open index.html
```

> **Note:** `elm reactor` will show a blank page because it doesn't pre-compile `main.js`. Use `npm run serve` or open `index.html` after running `elm make`.

The guide is organized into 9 sections matching the component groups above. Every component is shown with multiple variants and real interactive state (forms you can type in, modals you can open, accordions you can expand, etc.).

To run the Playwright tests:

```bash
cd examples/pf6-guide
npm test
```

The test suite compiles the app automatically before running.

---

## Contributing

Issues and pull requests are welcome. If you find a bug, have a component request, or want to suggest an improvement, please [open an issue](https://github.com/lenards/elm-ui-patternfly/issues).

---

## Resources

- [PatternFly 6 components](https://www.patternfly.org/components/)
- [elm-ui documentation](https://package.elm-lang.org/packages/mdgriffith/elm-ui/latest/)
- [elm-ui guide](https://korban.net/elm/elm-ui-guide/) — Paul Korban
- [Builder pattern in Elm](http://sporto.github.io/elm-patterns/advanced/pipeline-builder.html)
