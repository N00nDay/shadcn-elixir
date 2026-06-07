# shadcn-elixir

The [shadcn/ui](https://ui.shadcn.com) component model, ported to Phoenix.

Beautifully designed components you copy into your own app and own outright — built on
Phoenix function components, `Phoenix.LiveView.JS` + colocated hooks for interactivity,
and Tailwind CSS v4. All 58 shadcn/ui components, the same look, the same CSS-variable
theming.

> An independent, community port of shadcn/ui for the Elixir ecosystem — not affiliated
> with shadcn. See [Credits](#credits).

## Documentation

The demo app is the documentation site: a faithful clone of ui.shadcn.com with live
previews, copy-paste code, and an API reference for every component. Run it locally:

```bash
cd demo
mix setup
mix phx.server   # → http://localhost:4000
```

A hosted docs site and HexDocs are on the way.

## Quick start

Add the dependency:

```elixir
# mix.exs
def deps do
  [{:shadcn_elixir, "~> 0.1.0"}]
end
```

`cn/1` uses [`tw_merge`](https://hex.pm/packages/tw_merge), so add its cache to your
supervision tree (`lib/my_app/application.ex`):

```elixir
children = [
  # ...
  TwMerge.Cache
]
```

Import the theme after Tailwind in `assets/css/app.css`, and let Tailwind scan the
component markup:

```css
@import "tailwindcss";
@import "../../deps/shadcn_elixir/priv/static/theme.css";
@source "../../deps/shadcn_elixir/lib";
```

Then reach for components in HEEx:

```elixir
use ShadcnElixir   # or: import ShadcnElixir.Components.Button
```

```heex
<.button>Click me</.button>
<.button variant="destructive" size="sm">Delete</.button>
<.button variant="outline" navigate={~p"/settings"}>Settings</.button>
```

That's the fastest path. Prefer to **own the source**? Generate it instead.

## Own the components

Like shadcn, you can copy components into your project and edit them freely. You get
exactly what you ask for plus its dependencies — never the whole library:

```bash
mix shadcn.init                    # theme.css + JS hooks + the wiring steps to follow
mix shadcn.add button card dialog  # copy components (and their deps) into your app
mix shadcn.add --list              # list every available component
```

Files land in `lib/<app>_web/components/ui/` as `<App>Web.Components.UI.<Name>`, with
inter-component references rewritten to match. `init` can also bake a theme preset in:

```bash
mix shadcn.init --base stone --theme blue --radius lg
```

## JavaScript

Most components use `Phoenix.LiveView.JS` or native HTML and need no setup. A few (Select,
Command, Combobox, Input OTP, Resizable, Chart, Sonner) ship hooks:

```js
import { Hooks } from "../../deps/shadcn_elixir/assets/js/shadcn_elixir";
const liveSocket = new LiveSocket("/live", Socket, { hooks: { ...Hooks } });
```

## How it maps to shadcn/ui

| shadcn/ui | shadcn-elixir |
| --- | --- |
| React function component | `Phoenix.Component` (HEEx) |
| Radix UI primitives | `Phoenix.LiveView.JS` + colocated hooks / native HTML |
| `class-variance-authority` (CVA) | `ShadcnElixir.Variants.variant/2` |
| `cn()` (clsx + tailwind-merge) | `ShadcnElixir.cn/1` (via `tw_merge`) |
| CSS-variable theming + `.dark` | identical tokens via Tailwind v4 |
| `npx shadcn add` + registry | `mix shadcn.add` + `ShadcnElixir.Registry` |

<details>
<summary><strong>All 58 components</strong></summary>

accordion, alert, alert-dialog, aspect-ratio, avatar, badge, breadcrumb, button,
button-group, calendar, card, carousel, chart, checkbox, collapsible, combobox, command,
context-menu, data-table, date-picker, dialog, drawer, dropdown-menu, empty, field,
hover-card, input, input-group, input-otp, item, kbd, label, menubar, native-select,
navigation-menu, pagination, popover, progress, radio-group, resizable, scroll-area,
select, separator, sheet, sidebar, skeleton, slider, sonner, spinner, switch, table,
tabs, textarea, toast, toggle, toggle-group, tooltip, typography.

</details>

A few components (calendar, chart, sonner, sidebar) are lightweight reimplementations
rather than 1:1 ports, since the originals lean on heavy JS libraries
(react-day-picker, Recharts, sonner, Radix) that don't fit the no-extra-runtime model.
They match the look and the common-case behavior.

## Credits

All credit for the original design system goes to [shadcn](https://github.com/shadcn) —
[shadcn/ui](https://ui.shadcn.com) is MIT licensed. This port also follows the lead of
[shadcn-svelte](https://shadcn-svelte.com) by [Huntabyte](https://github.com/huntabyte),
the community Svelte port, whose docs and registry approach inspired this one.

## License

MIT © [N00nDay](https://github.com/N00nDay). shadcn/ui is MIT © shadcn.
