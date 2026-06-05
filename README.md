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

Under active development — building toward 100% component parity with shadcn/ui.

| Area | State |
| --- | --- |
| `cn/1` (tailwind-merge) + `Variants` (CVA engine) | ✅ |
| Theming (`theme.css`, light/dark tokens) | ✅ |
| Tier 0 — static components | 🚧 |
| Tier 1 — interactive (LiveView.JS) | ⬜ |
| Tier 2 — overlays/floating | ⬜ |
| Tier 3 — complex/stateful | ⬜ |
| `mix shadcn.add` generator | ⬜ |

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

## License

MIT © Craig Howell. shadcn/ui is by [shadcn](https://github.com/shadcn);
this is an independent port for the Elixir ecosystem.
