# shadcn-elixir

A portable Phoenix/Elixir component library — a faithful port of
[shadcn/ui](https://ui.shadcn.com/).

Every component, matching UI, with the same extensibility model: CSS-variable theming
and **copy-paste ownership**. Built on Phoenix function components, `Phoenix.LiveView.JS`
+ colocated hooks for interactivity, and Tailwind CSS v4.

## Why

shadcn/ui isn't a dependency you lock into — the components live in *your* project and
you own them. `shadcn-elixir` brings that philosophy to Phoenix:

- **Use it as a Hex dependency** for the quickest start, or
- **Generate the source into your app** with `mix shadcn.add <component>` and own/customize it.

## Status

Full component parity with shadcn/ui — all 58 components implemented.

| Area | State |
| --- | --- |
| `cn/1` (tailwind-merge) + `Variants` (CVA engine) | ✅ |
| Theming (`theme.css`, light/dark tokens) | ✅ |
| Tier 0 — static components (24) | ✅ |
| Tier 1 — interactive, LiveView.JS / native (8) | ✅ |
| Tier 2 — overlays/floating (14) | ✅ |
| Tier 3 — complex/stateful (12) | ✅ |
| `mix shadcn.init` / `mix shadcn.add` generator | ✅ |

### Components

accordion, alert, alert-dialog, aspect-ratio, avatar, badge, breadcrumb, button,
button-group, calendar, card, carousel, chart, checkbox, collapsible, combobox, command,
context-menu, data-table, date-picker, dialog, drawer, dropdown-menu, empty, field,
hover-card, input, input-group, input-otp, item, kbd, label, menubar, native-select,
navigation-menu, pagination, popover, progress, radio-group, resizable, scroll-area,
select, separator, sheet, sidebar, skeleton, slider, sonner, spinner, switch, table,
tabs, textarea, toast, toggle, toggle-group, tooltip, typography.

## Preview (demo app)

A runnable Phoenix app lives in [`demo/`](demo/) — it shows components from every tier
with the full Tailwind v4 + theme + JS-hooks pipeline wired up:

```bash
cd demo
mix setup
mix phx.server   # http://localhost:4000
```

## Installation

Add to your `mix.exs`:

```elixir
def deps do
  [
    {:shadcn_elixir, "~> 0.1.0"}
  ]
end
```

`cn/1` uses [`tw_merge`](https://hex.pm/packages/tw_merge), which needs a cache process.
Add it to your application's supervision tree (`lib/my_app/application.ex`):

```elixir
children = [
  # ...
  TwMerge.Cache
]
```

### Theming

Import the theme after Tailwind in your app's CSS (`assets/css/app.css`):

```css
@import "tailwindcss";
@import "../../deps/shadcn_elixir/priv/static/theme.css";
```

This wires up shadcn's semantic tokens (`--background`, `--primary`/`--primary-foreground`,
`--muted`, `--destructive`, `--radius`, …) for both light and `.dark` modes. Override any
token in your own `:root`/`.dark` block to re-theme.

## Usage

Import every component (e.g. in your `MyAppWeb` `html_helpers`):

```elixir
use ShadcnElixir
```

Or import a single component module:

```elixir
import ShadcnElixir.Components.Button
```

Then use them in HEEx:

```heex
<.button>Click me</.button>
<.button variant="destructive" size="sm">Delete</.button>
<.button variant="outline" navigate={~p"/settings"}>Settings</.button>
```

## Own the components (generator)

Prefer shadcn's copy-paste model? Generate the source into your own project and customize
freely:

```bash
mix shadcn.init                      # install theme.css + JS hooks, print wiring steps
mix shadcn.add button card dialog    # copy components (+ their deps) into your app
mix shadcn.add --all                 # everything
mix shadcn.add --list                # list available components
```

Components are written to `lib/<app>_web/components/ui/<name>.ex` as
`<App>Web.Components.UI.<Name>`, with inter-component references rewritten to match.
Dependencies are resolved automatically (e.g. `date_picker` pulls in `popover`,
`calendar`, and `button`). The lightweight helpers (`cn/1`, `Variants`, `JS`) remain
references to the `:shadcn_elixir` dependency.

## JavaScript

Most components (dialog, popover, dropdown, tabs, accordion, …) are powered by
`Phoenix.LiveView.JS` or native HTML and need no JS wiring. A few (Select, Command,
Combobox, Input OTP, Resizable, Chart, Sonner) use hooks shipped in
`assets/js/shadcn_elixir.js`:

```js
// LiveView
import { Hooks } from "../../deps/shadcn_elixir/assets/js/shadcn_elixir";
const liveSocket = new LiveSocket("/live", Socket, { hooks: { ...Hooks } });

// or, for dead/static views
import { initShadcn } from "../../deps/shadcn_elixir/assets/js/shadcn_elixir";
document.addEventListener("DOMContentLoaded", () => initShadcn());
```

Tailwind v4 must scan the component markup. Add a source line to your CSS:

```css
@source "../../deps/shadcn_elixir/lib";   /* when using the library directly */
```

## Architecture

| shadcn/ui | shadcn-elixir |
| --- | --- |
| React function component | `Phoenix.Component` (HEEx) |
| Radix UI primitives | `Phoenix.LiveView.JS` + colocated hooks / native HTML |
| `class-variance-authority` (CVA) | `ShadcnElixir.Variants.variant/2` |
| `cn()` (clsx + tailwind-merge) | `ShadcnElixir.cn/1` (via `tw_merge`) |
| CSS-variable theming + `.dark` | identical tokens via Tailwind v4 `@theme inline` |
| `npx shadcn add` + registry | `mix shadcn.add` + `ShadcnElixir.Registry` |

## License

MIT © N00nDay. shadcn/ui is by [shadcn](https://github.com/shadcn);
this is an independent port for the Elixir ecosystem.
