# elm-ui-patternfly

An [`elm-ui`](https://package.elm-lang.org/packages/mdgriffith/elm-ui/latest/) implementation of the [PatternFly 6](https://www.patternfly.org/) design system.

**66 components** · **Elm 0.19.1** · **Builder pattern** · **No CSS required**

**[Live Demo](https://lenards.github.io/elm-ui-patternfly/)** — Browse all 66 components interactively.

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

---

## Components

### Primitives

| Component | Module | Description |
|-----------|--------|-------------|
| Button | `PF6.Button` | 7 variants (primary, secondary, tertiary, danger, warning, link, plain), 3 sizes, icon support |
| Badge | `PF6.Badge` | Numeric count badge with overflow cap and unread variant |
| Label | `PF6.Label` | 8 color variants, outline, compact, closable, icon support |
| Avatar | `PF6.Avatar` | User avatar image, 3 sizes, optional border |
| Icon | `PF6.Icon` | Semantic icon wrapper with status colors and 4 sizes |
| Title | `PF6.Title` | Heading levels H1–H6 with PF6 sizing |
| Divider | `PF6.Divider` | Horizontal rule with inset variants |

### Feedback & Status

| Component | Module | Description |
|-----------|--------|-------------|
| Alert | `PF6.Alert` | Inline alerts — default, success, danger, warning, info; optional close |
| Banner | `PF6.Banner` | Full-width site banners with optional link |
| Spinner | `PF6.Spinner` | Animated loading indicator, 4 sizes |
| Skeleton | `PF6.Skeleton` | Loading placeholder — text lines, circle, and square variants |
| EmptyState | `PF6.EmptyState` | Empty state with icon, title, body, and actions |
| Progress | `PF6.Progress` | Progress bar with status colors and size variants |
| HelperText | `PF6.HelperText` | Form field helper text — default, error, warning, success, indeterminate |

### Forms

| Component | Module | Description |
|-----------|--------|-------------|
| TextInput | `PF6.TextInput` | Text field with label, placeholder, validation states, disabled |
| Checkbox | `PF6.Checkbox` | Checkbox with label and optional description |
| Radio | `PF6.Radio` | Radio button with label and optional description |
| Switch | `PF6.Switch` | Toggle switch with on/off labels |
| NumberInput | `PF6.NumberInput` | Numeric input with increment/decrement, min/max/step, unit suffix |
| SearchInput | `PF6.SearchInput` | Search field with clear, submit, and typeahead hints |
| Select | `PF6.Select` | Single-select dropdown with option groups |
| Form | `PF6.Form` | Form layout with labeled groups, required markers, and helper text |

### Navigation

| Component | Module | Description |
|-----------|--------|-------------|
| Breadcrumb | `PF6.Breadcrumb` | Breadcrumb trail with linked and current-page items |
| Tabs | `PF6.Tabs` | Tab navigation — default, box, vertical, and filled variants |
| Pagination | `PF6.Pagination` | Page navigation with item count and compact variant |

### Layout

| Component | Module | Description |
|-----------|--------|-------------|
| Card | `PF6.Card` | Content card with title, footer, flat, compact, and selectable variants |
| Page | `PF6.Page` | Page shell with masthead, sidebar, and main content area |
| Drawer | `PF6.Drawer` | Sliding panel — right, left, or bottom; inline or overlay mode |

### Overlays

| Component | Module | Description |
|-----------|--------|-------------|
| Modal | `PF6.Modal` | Full-viewport modal dialog with title, body, footer, and size variants |
| Tooltip | `PF6.Tooltip` | Hover tooltip — top, bottom, left, right positioning |
| Popover | `PF6.Popover` | Click-triggered overlay with title, body, footer, and close button |
| Dropdown | `PF6.Dropdown` | Action dropdown with dividers, headers, and position control |
| Accordion | `PF6.Accordion` | Expandable content sections with bordered and large-display variants |
| ExpandableSection | `PF6.ExpandableSection` | Single toggle-show/hide content block |

### Content

| Component | Module | Description |
|-----------|--------|-------------|
| CodeBlock | `PF6.CodeBlock` | Read-only code display with expandable variant |
| ClipboardCopy | `PF6.ClipboardCopy` | Copy-to-clipboard with inline and block variants |
| List | `PF6.List` | Bulleted, ordered, plain, and inline list variants |
| DescriptionList | `PF6.DescriptionList` | Term/value pairs — vertical and horizontal layouts |
| ActionList | `PF6.ActionList` | Spaced group of action buttons |

### Data

| Component | Module | Description |
|-----------|--------|-------------|
| Table | `PF6.Table` | Data table with sortable columns, striped rows, compact, and bordered variants |
| DataList | `PF6.DataList` | Flexible list with checkable rows and expandable content |
| Toolbar | `PF6.Toolbar` | Filter/sort toolbar with item groups, separator, and item count |

### Additional

| Component | Module | Description |
|-----------|--------|-------------|
| NotificationDrawer | `PF6.NotificationDrawer` | Slide-out notification panel with variant icons and read/unread state |
| JumpLinks | `PF6.JumpLinks` | In-page anchor navigation with subsections and optional label |
| Navigation | `PF6.Navigation` | Vertical/horizontal application navigation |

---

## Example app — pf6-guide

The `examples/pf6-guide/` directory contains a full interactive TEA application that demonstrates all 66 components with live state. A live version is deployed automatically to **[lenards.github.io/elm-ui-patternfly](https://lenards.github.io/elm-ui-patternfly/)** on every push to `main`.

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
