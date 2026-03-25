# CLAUDE.md — elm-ui-patternfly

## Project overview

This is an Elm 0.19.1 **package** (not an application) that implements PatternFly 6 design system components using `mdgriffith/elm-ui` 1.1.8. Published on the Elm package registry as `lenards/elm-ui-patternfly`.

- **66 PF6 components** under `src/PF6/`
- **Legacy PF4 components** under `src/PF4/` (retained for compatibility, planned for removal)
- **Example apps** under `examples/` (pf6-guide, pf6-sample-app, cve-dashboard)
- **Live demo** at https://lenards.github.io/elm-ui-patternfly/

## Architecture — the builder pattern

Every PF6 component follows the same pattern:

```elm
-- 1. Opaque type (internals hidden)
type Button msg = Button (Options msg)

-- 2. Constructor(s)
primary : { label : String, onPress : Maybe msg } -> Button msg

-- 3. Modifier functions (withX)
withLargeSize : Button msg -> Button msg
withIcon : Element msg -> Button msg -> Button msg
withDisabled : Button msg -> Button msg

-- 4. Renderer
toMarkup : Button msg -> Element msg
```

**Why this pattern?**
- Opaque types prevent consumers from depending on internals
- Pipeline-friendly: `Button.primary {...} |> Button.withIcon icon |> Button.toMarkup`
- Easy to add modifiers without breaking API
- All components produce `Element msg` (elm-ui), never `Html msg`

## Design tokens — PF6.Tokens

All colors, spacing, radii, and font sizes come from `src/PF6/Tokens.elm`. Never hardcode values — always use tokens:

```elm
import PF6.Tokens as Tokens

-- Colors
Tokens.colorPrimary          -- #0066CC (PF6 blue)
Tokens.colorDanger            -- #B1380B
Tokens.colorWarning           -- #FFCC17
Tokens.colorSuccess           -- #3D7317
Tokens.colorInfo              -- #5E40BE
Tokens.colorText              -- dark grey for body text
Tokens.colorTextSubtle        -- lighter grey for secondary text
Tokens.colorTextOnDark        -- white/light for dark backgrounds
Tokens.colorBackgroundDefault -- white
Tokens.colorBackgroundSecondary -- light grey

-- Spacing (Int values for padding/margin)
Tokens.spacerXs, spacerSm, spacerMd, spacerLg, spacerXl

-- Border radius
Tokens.radiusSm, radiusMd, radiusLg, radiusPill

-- Font sizes
Tokens.fontSizeSm, fontSizeMd, fontSizeLg, fontSizeXl, fontSize2xl, fontSize4xl
```

## elm-ui patterns and gotchas

### Scrollable regions need min-height: 0
When using `Element.scrollbarY` inside a flex column, the parent flex item defaults to `min-height: auto` and won't shrink below content height. Fix:

```elm
Element.el
    [ Element.height Element.fill
    , Element.htmlAttribute (Html.Attributes.style "min-height" "0")
    , Element.scrollbarY
    ]
    content
```

Apply `min-height: 0` to BOTH the scrollable element AND its parent row/column.

### No CSS hover for show/hide
`Element.mouseOver` only accepts `Decoration` values (colors, shadows, font effects). You CANNOT use it to toggle visibility/opacity. For hover-triggered overlays (tooltips), inject CSS via `Element.html (Html.node "style" ...)`:

```elm
Element.html (Html.node "style" [] [ Html.text ".my-wrap:hover .my-bubble { opacity: 1 !important; }" ])
```

### Overlay positioning
Use `Element.above`, `Element.below`, `Element.onLeft`, `Element.onRight` for nearby overlays (tooltips, dropdowns). These render as `position: absolute` children and don't affect layout flow.

Use `Element.inFront` for modals/backdrops. When applied to a `layout` element, `inFront` becomes `position: fixed`.

### Box shadows
elm-ui doesn't have native box-shadow. Use:
```elm
Element.htmlAttribute (Html.Attributes.style "box-shadow" "0 4px 8px rgba(0,0,0,0.1)")
```
Or `Border.shadow { offset = (0, 4), size = 0, blur = 8, color = Element.rgba 0 0 0 0.1 }`.

### CSS animations
For spinners, skeletons, and transitions, inject `@keyframes` via `Element.html (Html.node "style" ...)` and apply animation classes with `Element.htmlAttribute (Html.Attributes.class "...")`.

### Fixed positioning
elm-ui is document-flow based. For fixed-position elements (modals, back-to-top), use `Html.Attributes.style "position" "fixed"` etc.

## Translating React PatternFly to Elm

When implementing a PF6 component from the React version:

1. **Read the React source** — understand props, variants, internal state
2. **Map React props to builder modifiers** — each prop becomes a `withX` function
3. **Map React children to constructor args** — content passed in constructor, slots via `withX`
4. **Replace CSS classes with elm-ui attributes** — use Tokens for values
5. **Replace React state with model fields** — Elm consumers manage state via TEA
6. **Replace callbacks with msg types** — `onClick` becomes `onPress : Maybe msg`

### Common mappings

| React PatternFly | Elm elm-ui |
|---|---|
| `variant="primary"` | `Button.primary {...}` (variant constructors) |
| `isCompact` | `withCompact` |
| `isDisabled` | `withDisabled` |
| `onClose={handler}` | `withCloseMsg msg` |
| `className="pf-m-danger"` | `withDanger` |
| `<CardTitle>` | `withTitle String` |
| `<CardBody>` | body in constructor |
| `<CardFooter>` | `withFooter (Element msg)` |
| CSS custom properties | `PF6.Tokens` values |
| `useState` | Model field + Msg in consumer |
| `useEffect` | Cmd/Sub in consumer |

### Things that need ports
- Clipboard API (`navigator.clipboard.writeText`) — see pf6-guide's `copyToClipboard` port
- File uploads (`File API`)
- Scroll position detection (for back-to-top, jump links)
- Focus management

## Package publishing

### Pre-publish checklist
1. Every exported value needs a `{-| doc comment -}` on the declaration
2. Every exported value needs an `@docs` entry in the module doc comment
3. Run `elm publish` to verify — it checks all of this
4. Use `elm bump` to compute the correct version (respects semver based on API changes)
5. Tag with `git tag X.Y.Z`, push tag, then `elm publish`

### elm.json structure
The package uses grouped `exposed-modules`:
```json
"exposed-modules": {
    "PF4": ["PF4.Accordion", ...],
    "PF6": ["PF6.Tokens", "PF6.Button", ...]
}
```

## Testing

- **Unit tests**: `npx elm-test-rs` from repo root (uses elm-explorations/test 2.0.0)
- **Playwright tests**: `cd examples/pf6-guide && npm test`
- **Philosophy**: Test what the compiler can't verify — business logic, edge cases, fuzz/property tests. Don't test that `toMarkup` doesn't crash (the compiler guarantees that).

## Build commands

```bash
# Compile library (verify all modules)
elm make --output=/dev/null

# Compile guide app
cd examples/pf6-guide && elm make src/Main.elm --output=main.js

# Run unit tests
npx elm-test-rs

# Run Playwright tests
cd examples/pf6-guide && npm test

# Check publish readiness
elm publish  # (answer 'n' to avoid actually publishing)

# Bump version
elm bump
```

**Important**: elm compiler needs file lock access — use `dangerouslyDisableSandbox: true` in Claude Code.

## Key references

- [PatternFly 6 components](https://www.patternfly.org/components/) — the source of truth for component behavior and design
- [PatternFly HTML/CSS development guide](https://www.patternfly.org/get-started/develop/#develop-with-htmlcss) — CSS variables, tokens, dark mode
- [elm-ui documentation](https://package.elm-lang.org/packages/mdgriffith/elm-ui/1.1.8/) — layout, styling, events
- [elm-ui guide (Korban)](https://korban.net/elm/elm-ui-guide/) — practical patterns
- [Builder pattern in Elm](http://sporto.github.io/elm-patterns/advanced/pipeline-builder.html) — the pattern all components follow
- [patternfly-yew quickstart](https://patternfly-yew.github.io/patternfly-yew-quickstart/) — Rust/Yew implementation for comparison
- [nxtcm-components CVECard](https://github.com/RedHatInsights/nxtcm-components) — example of composing PF components for domain UI

## Component coverage

66 PF6 components implemented. Notable gaps vs full PatternFly 6:
- **Toast** — auto-dismissing notifications (high value, should implement)
- **Content/Text** — styled prose blocks
- **Calendar/Date Picker** — needs date math library
- **Tree View** — recursive expandable tree
- **Dual List Selector** — two-panel transfer widget
- **File Upload** — needs File API ports
- **Dark mode** — all components use light theme tokens only; would need a theme system

## Current state (light mode only)

All components use light theme tokens from `PF6.Tokens`. Dark mode would require either:
1. A `Theme` record threaded through components
2. A duplicate `PF6.TokensDark` module
3. CSS custom properties approach (fights elm-ui's inline styles)
