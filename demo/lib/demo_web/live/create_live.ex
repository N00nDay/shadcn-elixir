defmodule DemoWeb.CreateLive do
  @moduledoc """
  The Create page (`/create/:item`), modeled on shadcn-svelte.com/create — the "Rhea"
  design-system generator. A full-height layout: the shared site header, a large preview frame
  with a `01 / 02` switcher, and a right-hand Customizer card (Style / Base Color / Theme /
  Chart Color / Typography / Icon Library / Radius / Menu pickers + preset/initialize actions).

  The Customizer pickers are interactive: each opens a dropdown of options and selecting pushes
  `set_pref`. Base Color, Theme, Chart Color, Radius and Typography apply live to the preview via
  `data-base`/`data-theme`/`data-chart` + inline `--radius`/`font-family` on the preview wrapper,
  with the scoped token CSS from `DemoWeb.Create.Themes`. The Menu offers Shuffle / Light-Dark /
  Reset. Style / Icon Library / Menu Color/Accent update their value (no style system to apply).

  Uses plain `Phoenix.LiveView` + `use ShadcnElixir`. Mirrors `DemoWeb.ChartsLive`.
  """
  use Phoenix.LiveView
  use ShadcnElixir

  import DemoWeb.DocsComponents, only: [site_header: 1]

  alias DemoWeb.{Create, Docs}
  alias Phoenix.LiveView.JS

  # Customizer param → socket assign key.
  @params %{
    "style" => :style,
    "base" => :base,
    "theme" => :theme,
    "chart_color" => :chart_color,
    "font_heading" => :font_heading,
    "font_body" => :font_body,
    "icon_library" => :icon_library,
    "radius" => :radius,
    "menu_color" => :menu_color,
    "menu_accent" => :menu_accent
  }

  def mount(_params, _session, socket) do
    {:ok,
     assign(socket,
       components: Docs.components(),
       page_title: "Create — New Project",
       # Design-system state. Base/Theme/Radius/Chart/Typography apply live to the preview;
       # Style/Icon/Menu update their value (we don't ship those style systems).
       base: "neutral",
       style: "vega",
       theme: "neutral",
       chart_color: "neutral",
       font_heading: "inter",
       font_body: "inter",
       icon_library: "lucide",
       radius: "default",
       menu_color: "default",
       menu_accent: "subtle",
       dark: false
     )}
  end

  def handle_params(params, _uri, socket) do
    item = params["item"] || "preview-02"
    item = if Create.item?(item), do: item, else: "preview-02"
    {:noreply, socket |> assign(item: item) |> apply_preset(params)}
  end

  # Restore design-system state from query params (used by the Copy Preset / Open links so a
  # preset URL is shareable and reopens with the same configuration).
  defp apply_preset(socket, p) do
    socket
    |> maybe(:style, valid(p["style"], Create.styles()))
    |> maybe(:base, valid(p["base"], Create.base_colors()))
    |> maybe(:theme, valid(p["theme"], Create.themes()))
    |> maybe(:chart_color, valid(p["chart"], Create.chart_colors()))
    |> maybe(:radius, valid(p["radius"], Create.radii()))
    |> maybe(:font_body, valid(p["font"], Create.fonts()))
    |> maybe(:font_heading, valid(p["heading"], Create.font_headings()))
    |> maybe(:icon_library, valid(p["icons"], Create.icon_libraries()))
    |> maybe(:menu_color, valid(p["menucolor"], Create.menu_colors()))
    |> maybe(:menu_accent, valid(p["menuaccent"], Create.menu_accents()))
    |> maybe(
      :dark,
      case(p["dark"],
        do: (
          "1" -> true
          "0" -> false
          _ -> nil
        )
      )
    )
  end

  defp valid(value, options) do
    if value && Enum.any?(options, fn opt -> elem(opt, 0) == value end), do: value
  end

  defp maybe(socket, _key, nil), do: socket
  defp maybe(socket, key, value), do: assign(socket, key, value)

  # A shareable preset URL: the Create page with the current configuration in the query string.
  defp preset_path(a) do
    "/create/#{a.item}?" <>
      URI.encode_query(
        style: a.style,
        base: a.base,
        theme: a.theme,
        chart: a.chart_color,
        radius: a.radius,
        font: a.font_body,
        heading: a.font_heading,
        icons: a.icon_library,
        menucolor: a.menu_color,
        menuaccent: a.menu_accent,
        dark: if(a.dark, do: "1", else: "0")
      )
  end

  # A Customizer picker chose a value. Values come from our own rendered menus.
  def handle_event("set_pref", %{"param" => param, "value" => value}, socket) do
    case Map.fetch(@params, param) do
      {:ok, key} -> {:noreply, assign(socket, key, value)}
      :error -> {:noreply, socket}
    end
  end

  # Menu → Shuffle: randomize every dimension from its option list.
  def handle_event("shuffle", _params, socket) do
    {:noreply,
     assign(socket,
       style: rand(Create.styles()),
       base: rand(Create.base_colors()),
       theme: rand(Create.themes()),
       chart_color: rand(Create.chart_colors()),
       font_heading: rand(Create.fonts()),
       font_body: rand(Create.fonts()),
       icon_library: rand(Create.icon_libraries()),
       radius: rand(Create.radii()),
       menu_color: rand(Create.menu_colors()),
       menu_accent: rand(Create.menu_accents())
     )}
  end

  # Menu → Reset: back to the default preset.
  def handle_event("reset", _params, socket) do
    {:noreply,
     assign(socket,
       style: "vega",
       base: "neutral",
       theme: "neutral",
       chart_color: "neutral",
       font_heading: "inter",
       font_body: "inter",
       icon_library: "lucide",
       radius: "default",
       menu_color: "default",
       menu_accent: "subtle",
       dark: false
     )}
  end

  # Menu → Light/Dark: toggle the preview iframe's color scheme.
  def handle_event("toggle_dark", _params, socket) do
    {:noreply, assign(socket, dark: !socket.assigns.dark)}
  end

  defp rand(options), do: options |> Enum.random() |> elem(0)

  # Shared dropdown menu-item styling (mirrors the dropdown_menu component's item_class).
  defp menu_item_class do
    "focus:bg-accent focus:text-accent-foreground hover:bg-accent hover:text-accent-foreground " <>
      "relative flex cursor-pointer items-center justify-between gap-2 rounded-sm px-2 py-1.5 " <>
      "text-sm outline-hidden select-none"
  end

  # The preview is an isolated iframe served by CreateFrameController; every design-system choice
  # is encoded in its query string, so a picker change re-renders the iframe with shadcn's actual
  # cn-* markup + compiled CSS restyled. (Icon Library maps "remix" → shadcn's "remixicon".)
  defp frame_src(assigns) do
    icons = if assigns.icon_library == "remix", do: "remixicon", else: assigns.icon_library

    query =
      URI.encode_query(
        icons: icons,
        style: assigns.style,
        base: assigns.base,
        theme: assigns.theme,
        chart: assigns.chart_color,
        radius: assigns.radius,
        font: assigns.font_body,
        heading: assigns.font_heading,
        menucolor: assigns.menu_color,
        menuaccent: assigns.menu_accent,
        dark: if(assigns.dark, do: "1", else: "0")
      )

    "/create/frame?" <> query
  end

  def render(assigns) do
    ~H"""
    <div class="flex h-svh flex-col overflow-hidden bg-background text-foreground">
      <.site_header components={@components} />
      <main class="mx-auto flex w-full max-w-screen-2xl min-h-0 flex-1 flex-col gap-4 p-4 md:flex-row-reverse md:gap-6 md:p-6">
        <div class="relative flex min-h-0 flex-1 flex-col overflow-hidden rounded-2xl border bg-background">
          <button
            type="button"
            aria-label="Open full preview"
            class="hover:bg-accent hover:text-accent-foreground absolute top-2 right-2 z-10 inline-flex size-8 items-center justify-center rounded-md"
          >
            <svg
              xmlns="http://www.w3.org/2000/svg"
              viewBox="0 0 24 24"
              fill="none"
              stroke="currentColor"
              stroke-width="2"
              stroke-linecap="round"
              stroke-linejoin="round"
              class="size-4"
              aria-hidden="true"
            >
              <path d="M8 3H5a2 2 0 0 0-2 2v3" /><path d="M21 8V5a2 2 0 0 0-2-2h-3" /><path d="M3 16v3a2 2 0 0 0 2 2h3" /><path d="M16 21h3a2 2 0 0 0 2-2v-3" />
            </svg>
          </button>
          <iframe
            title="Design system preview"
            src={frame_src(assigns)}
            class="min-h-0 w-full flex-1 border-0 bg-background"
          >
          </iframe>
          <div class="dark absolute right-3 bottom-3 z-20 flex items-center gap-1 rounded-xl bg-card/90 p-1 shadow-xl backdrop-blur-xl">
            <.link
              :for={{label, value} <- Create.items()}
              navigate={"/create/#{value}"}
              data-active={to_string(@item == value)}
              class="text-muted-foreground hover:text-foreground data-[active=true]:bg-accent data-[active=true]:text-accent-foreground flex h-7 min-w-8 items-center justify-center rounded-lg px-2.5 text-xs font-medium transition-colors"
            >
              {label}
            </.link>
          </div>
        </div>

        <div class="md:w-56 shrink-0">
          <.card class="dark bg-card/90 w-full gap-0 rounded-2xl py-0 shadow-xl backdrop-blur-xl">
            <div class="hidden items-center justify-between gap-2 border-b px-3 py-2.5 md:flex">
              <.dropdown_menu id="create-menu" class="w-full">
                <.dropdown_menu_trigger menu="create-menu">
                  <button
                    type="button"
                    class="ring-foreground/10 flex w-full items-center justify-between gap-2 rounded-lg px-2 py-1.5 text-sm ring-1"
                  >
                    <span class="font-medium">Menu</span>
                    <svg
                      xmlns="http://www.w3.org/2000/svg"
                      viewBox="0 0 24 24"
                      fill="none"
                      stroke="currentColor"
                      stroke-width="2"
                      stroke-linecap="round"
                      stroke-linejoin="round"
                      class="size-5"
                      aria-hidden="true"
                    >
                      <line x1="4" x2="20" y1="6" y2="6" /><line x1="4" x2="20" y1="12" y2="12" /><line
                        x1="4"
                        x2="20"
                        y1="18"
                        y2="18"
                      />
                    </svg>
                  </button>
                </.dropdown_menu_trigger>
                <.dropdown_menu_content menu="create-menu" align="start" class="w-full min-w-0">
                  <div
                    role="menuitem"
                    tabindex="-1"
                    data-slot="dropdown-menu-item"
                    phx-click={ShadcnElixir.JS.close("create-menu") |> JS.push("shuffle")}
                    class={menu_item_class()}
                  >
                    Shuffle
                    <.dropdown_menu_shortcut>R</.dropdown_menu_shortcut>
                  </div>
                  <div
                    role="menuitem"
                    tabindex="-1"
                    data-slot="dropdown-menu-item"
                    phx-click={ShadcnElixir.JS.close("create-menu") |> JS.push("toggle_dark")}
                    class={menu_item_class()}
                  >
                    Light/Dark
                    <.dropdown_menu_shortcut>D</.dropdown_menu_shortcut>
                  </div>
                  <.dropdown_menu_separator />
                  <div
                    role="menuitem"
                    tabindex="-1"
                    data-slot="dropdown-menu-item"
                    phx-click={ShadcnElixir.JS.close("create-menu") |> JS.push("reset")}
                    class={menu_item_class()}
                  >
                    Reset
                    <.dropdown_menu_shortcut>⇧R</.dropdown_menu_shortcut>
                  </div>
                </.dropdown_menu_content>
              </.dropdown_menu>
            </div>
            <div class="flex flex-col">
              <div class="flex flex-col gap-3 p-3">
                <.picker
                  id="pk-style"
                  label="Style"
                  param="style"
                  value={@style}
                  options={Create.styles()}
                />
              </div>
              <.separator />
              <div class="flex flex-col gap-3 p-3">
                <.picker
                  id="pk-base"
                  label="Base Color"
                  param="base"
                  value={@base}
                  options={Create.base_colors()}
                />
                <.picker
                  id="pk-theme"
                  label="Theme"
                  param="theme"
                  value={@theme}
                  options={Create.themes()}
                />
                <.picker
                  id="pk-chart"
                  label="Chart Color"
                  param="chart_color"
                  value={@chart_color}
                  options={Create.chart_colors()}
                />
              </div>
              <.separator />
              <div class="flex flex-col gap-3 p-3">
                <.picker
                  id="pk-heading"
                  label="Heading"
                  param="font_heading"
                  value={@font_heading}
                  options={Create.font_headings()}
                />
                <.picker
                  id="pk-font"
                  label="Font"
                  param="font_body"
                  value={@font_body}
                  options={Create.fonts()}
                />
              </div>
              <.separator />
              <div class="flex flex-col gap-3 p-3">
                <.picker
                  id="pk-icons"
                  label="Icon Library"
                  param="icon_library"
                  value={@icon_library}
                  options={Create.icon_libraries()}
                />
                <.picker
                  id="pk-radius"
                  label="Radius"
                  param="radius"
                  value={@radius}
                  options={Create.radii()}
                />
              </div>
              <.separator />
              <div class="flex flex-col gap-3 p-3">
                <.picker
                  id="pk-menu-color"
                  label="Menu Color"
                  param="menu_color"
                  value={@menu_color}
                  options={Create.menu_colors()}
                />
                <.picker
                  id="pk-menu-accent"
                  label="Menu Accent"
                  param="menu_accent"
                  value={@menu_accent}
                  options={Create.menu_accents()}
                />
              </div>
            </div>
            <.separator />
            <div class="flex flex-col gap-2 p-3">
              <.button
                id="copy-preset"
                phx-hook="CopyCode"
                data-code={preset_path(assigns)}
                variant="outline"
                size="sm"
                class="group w-full"
              >
                <span class="group-data-[copied=true]:hidden">Copy Preset</span>
                <span class="hidden group-data-[copied=true]:inline">Copied!</span>
              </.button>
              <.button
                href={preset_path(assigns)}
                target="_blank"
                rel="noopener"
                variant="outline"
                size="sm"
                class="w-full"
              >
                Open
              </.button>
              <.button
                variant="outline"
                size="sm"
                class="w-full"
                aria-label="Shuffle"
                phx-click="shuffle"
              >
                <svg
                  xmlns="http://www.w3.org/2000/svg"
                  viewBox="0 0 24 24"
                  fill="none"
                  stroke="currentColor"
                  stroke-width="2"
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  class="size-4"
                  aria-hidden="true"
                >
                  <path d="M2 18h1.4c1.3 0 2.5-.6 3.3-1.7l6.1-8.6c.7-1.1 2-1.7 3.3-1.7H22" /><path d="m18 2 4 4-4 4" /><path d="M2 6h1.9c1.5 0 2.9.9 3.6 2.2" /><path d="M22 18h-5.9c-1.3 0-2.6-.7-3.3-1.8l-.5-.8" /><path d="m18 14 4 4-4 4" />
                </svg>
                Shuffle
              </.button>
            </div>
            <div class="px-3 pb-3">
              <.button class="w-full">
                <svg
                  xmlns="http://www.w3.org/2000/svg"
                  viewBox="0 0 24 24"
                  fill="none"
                  stroke="currentColor"
                  stroke-width="2"
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  class="size-4"
                  aria-hidden="true"
                >
                  <path d="m7 11 2-2-2-2" /><path d="M11 13h4" /><rect
                    width="18"
                    height="18"
                    x="3"
                    y="3"
                    rx="2"
                    ry="2"
                  />
                </svg>
                Initialize Project
              </.button>
            </div>
          </.card>
        </div>
      </main>
    </div>
    """
  end

  attr :id, :string, required: true
  attr :label, :string, required: true
  attr :param, :string, required: true
  attr :value, :string, required: true
  attr :options, :list, required: true

  # A two-line trigger that opens a dropdown of options; selecting pushes `set_pref`. Options
  # are {slug, title} or {slug, title, swatch_hex}; color options render a swatch dot.
  defp picker(assigns) do
    opts =
      Enum.map(assigns.options, fn opt ->
        %{slug: elem(opt, 0), title: elem(opt, 1), color: tuple_size(opt) == 3 && elem(opt, 2)}
      end)

    current = Enum.find(opts, &(&1.slug == assigns.value))

    assigns =
      assigns
      |> assign(:opts, opts)
      |> assign(:current_color, current && current.color)
      |> assign(:current_title, (current && current.title) || assigns.value)

    ~H"""
    <.dropdown_menu id={@id} class="w-full">
      <.dropdown_menu_trigger menu={@id}>
        <button
          type="button"
          class="hover:bg-accent/50 flex h-12 w-full items-center justify-between gap-2 rounded-md px-3 text-left transition-colors"
        >
          <div class="flex min-w-0 flex-col">
            <span class="text-muted-foreground text-xs">{@label}</span>
            <span class="text-foreground truncate text-sm font-medium">{@current_title}</span>
          </div>
          <span
            :if={@current_color}
            class="border-border/50 size-4 shrink-0 rounded-full border"
            style={"background-color: #{@current_color}"}
          >
          </span>
          <svg
            :if={!@current_color}
            xmlns="http://www.w3.org/2000/svg"
            viewBox="0 0 24 24"
            fill="none"
            stroke="currentColor"
            stroke-width="2"
            stroke-linecap="round"
            stroke-linejoin="round"
            class="text-muted-foreground size-4 shrink-0"
            aria-hidden="true"
          >
            <path d="m7 15 5 5 5-5" /><path d="m7 9 5-5 5 5" />
          </svg>
        </button>
      </.dropdown_menu_trigger>
      <.dropdown_menu_content menu={@id} align="start" class="max-h-72 w-full min-w-0 overflow-y-auto">
        <%!-- Items are plain menuitems so a single composed phx-click can both close the menu
              and push the selection (the dropdown_menu_item component hardcodes its own close). --%>
        <div
          :for={o <- @opts}
          role="menuitem"
          tabindex="-1"
          data-slot="dropdown-menu-item"
          phx-click={
            ShadcnElixir.JS.close(@id)
            |> JS.push("set_pref", value: %{param: @param, value: o.slug})
          }
          class={menu_item_class()}
        >
          <span class="flex min-w-0 items-center gap-2">
            <span
              :if={o.color}
              class="border-border/50 size-4 shrink-0 rounded-full border"
              style={"background-color: #{o.color}"}
            >
            </span>
            <span class="truncate">{o.title}</span>
          </span>
          <svg
            :if={o.slug == @value}
            xmlns="http://www.w3.org/2000/svg"
            viewBox="0 0 24 24"
            fill="none"
            stroke="currentColor"
            stroke-width="2"
            stroke-linecap="round"
            stroke-linejoin="round"
            class="size-4 shrink-0"
            aria-hidden="true"
          >
            <path d="M20 6 9 17l-5-5" />
          </svg>
        </div>
      </.dropdown_menu_content>
    </.dropdown_menu>
    """
  end
end
