# pf6-guide

An interactive guide demonstrating all 46 PatternFly 6 components built with `elm-ui`. Browse every component section, interact with live state, and see the builder pattern in action.

## Running locally

### Option 1 — elm reactor (simplest)

```bash
elm make src/Main.elm --output=main.js
elm reactor
```

Then open `http://localhost:8000/index.html`.

> **Note:** Go directly to `/index.html`, not the reactor root (`/`). You must run `elm make` first — reactor serves `main.js` but does not compile it. If you change Elm source files, re-run `elm make` to update `main.js`.

### Option 2 — npm serve (static server)

```bash
npm install
npm run build
npm run serve
```

Then open `http://localhost:8001`.

### Option 3 — open file directly (no server)

```bash
elm make src/Main.elm --output=main.js
open index.html
```

Works for browsing but some browser security policies may restrict local file access.

## Running tests

The Playwright test suite compiles the Elm app automatically before running:

```bash
npm install
npm test
```

To run with the interactive Playwright UI:

```bash
npm run test:ui
```

## Structure

```
pf6-guide/
├── src/
│   ├── Main.elm              # Entry point, update loop
│   ├── Types.elm             # Model, Msg, Section
│   └── Views/
│       ├── Layout.elm        # Masthead + sidebar shell
│       ├── HomeView.elm      # Landing page
│       ├── PrimitivesView.elm
│       ├── FeedbackView.elm
│       ├── FormsView.elm
│       ├── NavigationView.elm
│       ├── LayoutView.elm
│       ├── OverlaysView.elm
│       ├── ContentView.elm
│       └── DataView.elm
├── tests/
│   ├── setup.ts              # Global setup — compiles Elm before tests
│   └── guide.spec.ts         # Playwright tests
├── elm.json
├── index.html
└── playwright.config.ts
```
