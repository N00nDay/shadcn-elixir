defmodule DemoWeb.ChartsLive do
  @moduledoc """
  The Charts showcase (`/charts/:category`), modeled on shadcn-svelte.com/charts: the shared
  site header, a hero, a category nav row, and a responsive grid of chart cards. Each card is
  a `card` with a header, the live `chart`, and an optional footer.

  Uses plain `Phoenix.LiveView` + `use ShadcnElixir` (rather than `DemoWeb, :live_view`) to
  avoid name clashes with Phoenix core_components.
  """
  use Phoenix.LiveView
  use ShadcnElixir

  import DemoWeb.DocsComponents,
    only: [site_header: 1, docs_footer: 1, search_dialog: 1, code_block: 1]

  alias DemoWeb.{Charts, Docs, DocsComponents, Themes}
  alias Phoenix.HTML

  def mount(_params, _session, socket) do
    {:ok,
     assign(socket,
       components: Docs.components(),
       area_range: "90",
       base: "neutral",
       active_series: "desktop"
     )}
  end

  def handle_params(params, _uri, socket) do
    category = params["category"] || "area"
    category = if Charts.category?(category), do: category, else: "area"

    {:noreply,
     assign(socket,
       category: category,
       page_title: "Charts — " <> Charts.category_title(category),
       cards: build_cards(category, socket.assigns.area_range)
     )}
  end

  # The interactive chart's range dropdown filters its daily data to the last N days.
  def handle_event("set_area_range", %{"range" => range}, socket) when range in ~w(90 30 7) do
    {:noreply,
     assign(socket,
       area_range: range,
       cards: build_cards(socket.assigns.category, range)
     )}
  end

  # The base-color theme selector re-themes the cards and charts.
  def handle_event("set_theme", %{"base" => base}, socket) do
    {:noreply, if(Themes.base?(base), do: assign(socket, base: base), else: socket)}
  end

  # The bar/line interactive stat boxes toggle which series the chart shows.
  def handle_event("set_series", %{"series" => series}, socket)
      when series in ~w(desktop mobile) do
    {:noreply, assign(socket, active_series: series)}
  end

  defp build_cards(category, range) do
    days = String.to_integer(range)

    Enum.map(Charts.cards(category), fn card ->
      if card.range_select, do: %{card | data: Enum.take(card.data, -days)}, else: card
    end)
  end

  def render(assigns) do
    ~H"""
    {HTML.raw("<style>" <> DocsComponents.makeup_css() <> Themes.scoped_css() <> "</style>")}
    <.search_dialog components={@components} />
    <div class="min-h-svh bg-background text-foreground">
      <.site_header components={@components} />
      <main class="flex flex-1 flex-col">
        <section>
          <div class="mx-auto flex max-w-screen-2xl flex-col items-center gap-2 px-6 py-8 text-center md:py-16 lg:py-20 xl:gap-4">
            <h1 class="max-w-3xl text-3xl font-semibold tracking-tight text-balance text-primary lg:leading-[1.1] xl:text-5xl xl:tracking-tighter">
              Beautiful Charts &amp; Graphs
            </h1>
            <p class="max-w-4xl text-base text-balance text-foreground sm:text-lg">
              A collection of ready-to-use chart components. From basic charts to rich data
              displays, copy and paste into your apps.
            </p>
            <div class="flex w-full items-center justify-center gap-2 pt-2">
              <.button href="#charts" size="sm">Browse Charts</.button>
              <.button navigate="/docs/components/chart" variant="ghost" size="sm">
                Documentation
              </.button>
            </div>
          </div>
        </section>

        <div id="charts" class="scroll-mt-24">
          <div class="mx-auto flex max-w-screen-2xl items-center justify-between gap-4 px-6 py-4">
            <nav class="flex items-center overflow-x-auto">
              <.link
                :for={{slug, title} <- Charts.categories()}
                navigate={"/charts/#{slug}"}
                data-active={to_string(@category == slug)}
                class="flex h-7 shrink-0 items-center justify-center px-4 text-center text-base font-medium text-muted-foreground transition-colors hover:text-primary data-[active=true]:text-primary"
              >
                {title}
              </.link>
            </nav>
            <form phx-change="set_theme" class="shrink-0">
              <.select id="theme-select" name="base" value={@base} phx-update="ignore">
                <.select_trigger
                  select="theme-select"
                  size="sm"
                  class="w-[130px]"
                  aria-label="Select a theme"
                >
                  <.select_value placeholder="Neutral" />
                </.select_trigger>
                <.select_content select="theme-select">
                  <.select_item
                    :for={{slug, title} <- Themes.bases()}
                    select="theme-select"
                    value={slug}
                  >
                    {title}
                  </.select_item>
                </.select_content>
              </.select>
            </form>
          </div>
        </div>

        <div
          data-base={@base}
          class="mx-auto w-full max-w-screen-2xl bg-background px-6 pt-4 pb-8 text-foreground"
        >
          <div class="grid flex-1 gap-12 lg:gap-24">
            <h2 class="sr-only">{Charts.category_title(@category)}</h2>
            <div class="grid scroll-mt-20 items-stretch gap-10 md:grid-cols-2 md:gap-6 lg:grid-cols-3 xl:gap-10">
              <.chart_card
                :for={{card, idx} <- Enum.with_index(@cards)}
                id={"#{@category}-#{idx}"}
                card={card}
                category={@category}
                range={@area_range}
                active_series={@active_series}
                theme={@base}
              />
            </div>
          </div>
        </div>
        <.docs_footer />
      </main>
    </div>
    """
  end

  attr :id, :string, required: true
  attr :card, :map, required: true
  attr :category, :string, required: true
  attr :range, :string, default: "90"
  attr :active_series, :string, default: "desktop"
  attr :theme, :string, default: nil

  defp chart_card(assigns) do
    assigns =
      assigns
      |> assign(:polar?, assigns.card.type in ~w(pie donut radar radial))
      |> assign(:kind, chart_kind(assigns.card.type, assigns.category))
      |> assign(:sheet_id, "code-#{assigns.id}")
      |> assign(:code, chart_code(assigns.card, "chart-#{assigns.id}"))
      # The series-toggle interactive chart shows ONE (active) series, drawn monochrome.
      |> assign(:chart_keys, chart_keys(assigns.card, assigns.active_series))
      |> assign(:chart_colors, chart_colors(assigns.card))

    ~H"""
    <div class={[
      "group/chart relative flex flex-col",
      @card.full_width && "md:col-span-2 lg:col-span-3"
    ]}>
      <div class="flex items-center gap-2 px-3 py-2.5">
        <div class="flex items-center gap-1.5 pl-1 text-[13px] text-muted-foreground [&>svg]:size-[0.9rem]">
          <.chart_kind_icon kind={@kind} />{chart_kind_name(@kind)}
        </div>
        <div class="ml-auto flex items-center gap-2">
          <button
            id={"copy-#{@id}"}
            type="button"
            phx-hook="CopyCode"
            data-code={@code}
            aria-label="Copy chart code"
            class="copy-btn inline-flex size-6 items-center justify-center rounded-md text-foreground transition-colors hover:bg-muted"
          >
            <svg
              xmlns="http://www.w3.org/2000/svg"
              viewBox="0 0 24 24"
              fill="none"
              stroke="currentColor"
              stroke-width="2"
              stroke-linecap="round"
              stroke-linejoin="round"
              class="copy-icon size-3"
            >
              <rect width="14" height="14" x="8" y="8" rx="2" ry="2" /><path d="M4 16c-1.1 0-2-.9-2-2V4c0-1.1.9-2 2-2h10c1.1 0 2 .9 2 2" />
            </svg>
            <svg
              xmlns="http://www.w3.org/2000/svg"
              viewBox="0 0 24 24"
              fill="none"
              stroke="currentColor"
              stroke-width="2"
              stroke-linecap="round"
              stroke-linejoin="round"
              class="check-icon size-3"
            >
              <path d="M20 6 9 17l-5-5" />
            </svg>
          </button>
          <.separator orientation="vertical" class="mx-0 hidden h-4 md:flex" />
          <.sheet_trigger dialog={@sheet_id}>
            <.button variant="outline" size="sm" class="h-6 rounded-md px-2 text-xs">
              View Code
            </.button>
          </.sheet_trigger>
        </div>
      </div>

      <.card class={["flex flex-1 flex-col", @card.series_toggle && "pt-0"]}>
        <div :if={@card.series_toggle} class="flex flex-col items-stretch border-b sm:flex-row">
          <div class="flex flex-1 flex-col justify-center gap-1 px-6 py-5">
            <.card_title>{@card.title}</.card_title>
            <.card_description :if={@card.description}>{@card.description}</.card_description>
          </div>
          <div class="flex">
            <button
              :for={s <- series_stats(@card, @active_series)}
              type="button"
              phx-click="set_series"
              phx-value-series={s.key}
              data-active={to_string(s.active)}
              class="data-[active=true]:bg-muted/50 relative flex flex-1 cursor-pointer flex-col justify-center gap-1 border-t px-6 py-4 text-left even:border-l sm:border-t-0 sm:border-l sm:px-8 sm:py-5"
            >
              <span class="text-muted-foreground text-xs">{s.label}</span>
              <span class="text-lg leading-none font-bold tabular-nums sm:text-3xl">{s.total}</span>
            </button>
          </div>
        </div>
        <.card_header :if={not @card.series_toggle} class={@polar? && "items-center text-center"}>
          <.card_title>{@card.title}</.card_title>
          <.card_description :if={@card.description}>{@card.description}</.card_description>
          <.card_action :if={@card.range_select}>
            <form phx-change="set_area_range">
              <.select id={"range-#{@id}"} name="range" value={@range} phx-update="ignore">
                <.select_trigger
                  select={"range-#{@id}"}
                  size="sm"
                  class="w-[160px] rounded-lg"
                  aria-label="Select a time range"
                >
                  <.select_value placeholder="Last 3 months" />
                </.select_trigger>
                <.select_content select={"range-#{@id}"}>
                  <.select_item select={"range-#{@id}"} value="90">Last 3 months</.select_item>
                  <.select_item select={"range-#{@id}"} value="30">Last 30 days</.select_item>
                  <.select_item select={"range-#{@id}"} value="7">Last 7 days</.select_item>
                </.select_content>
              </.select>
            </form>
          </.card_action>
        </.card_header>
        <.card_content class="flex flex-1">
          <.chart
            id={"chart-" <> @id}
            type={@card.type}
            variant={@card.variant}
            keys={@chart_keys}
            legend={@card.legend}
            colors={@chart_colors}
            theme={@theme}
            data={@card.data}
            class={chart_class(@card.legend, @card.full_width)}
          />
        </.card_content>
        <.card_footer :if={@card.footer}>
          <.chart_footer footer={@card.footer} />
        </.card_footer>
      </.card>

      <.sheet id={@sheet_id}>
        <.sheet_content dialog={@sheet_id} side="right" class="w-full gap-0 p-0 sm:max-w-2xl">
          <.sheet_header class="border-b">
            <.sheet_title dialog={@sheet_id} class="font-mono text-sm">{@card.title}</.sheet_title>
            <.sheet_description dialog={@sheet_id} class="sr-only">
              The source for the {@card.title} chart.
            </.sheet_description>
          </.sheet_header>
          <div class="min-h-0 flex-1 overflow-auto p-4">
            <.code_block id={"codeblk-#{@id}"} source={@code} language="heex" />
          </div>
        </.sheet_content>
      </.sheet>
    </div>
    """
  end

  # Series-toggle interactive charts draw only the active series (monochrome); others use
  # the card's own keys/colors.
  defp chart_keys(%{series_toggle: true}, active), do: [active]
  defp chart_keys(card, _active), do: card.keys

  defp chart_colors(%{series_toggle: true}), do: ["--foreground"]
  defp chart_colors(card), do: card.colors

  # Per-series totals for the stat-toggle header (e.g. Desktop 24,828 / Mobile 25,010).
  defp series_stats(card, active) do
    Enum.map(card.keys, fn key ->
      total = card.data |> Enum.map(&Map.get(&1, String.to_existing_atom(key))) |> Enum.sum()
      %{key: key, label: String.capitalize(key), total: commafy(total), active: active == key}
    end)
  end

  defp commafy(n) do
    n
    |> Integer.to_string()
    |> String.reverse()
    |> String.replace(~r/(\d{3})(?=\d)/, "\\1,")
    |> String.reverse()
  end

  # Toolbar chart-kind label (matches shadcn): tooltip cards are bars, so use the category.
  defp chart_kind("pie", _), do: "pie"
  defp chart_kind("donut", _), do: "pie"
  defp chart_kind(_type, "tooltip"), do: "tooltip"
  defp chart_kind(type, _category), do: type

  defp chart_kind_name("area"), do: "Area Chart"
  defp chart_kind_name("bar"), do: "Bar Chart"
  defp chart_kind_name("line"), do: "Line Chart"
  defp chart_kind_name("pie"), do: "Pie Chart"
  defp chart_kind_name("radar"), do: "Radar Chart"
  defp chart_kind_name("radial"), do: "Radial Chart"
  defp chart_kind_name("tooltip"), do: "Tooltip"

  attr :kind, :string, required: true

  defp chart_kind_icon(assigns) do
    ~H"""
    <svg
      xmlns="http://www.w3.org/2000/svg"
      viewBox="0 0 24 24"
      fill="none"
      stroke="currentColor"
      stroke-width="2"
      stroke-linecap="round"
      stroke-linejoin="round"
      aria-hidden="true"
    >
      <%= case @kind do %>
        <% "bar" -> %>
          <path d="M3 3v16a2 2 0 0 0 2 2h16" /><rect x="7" y="13" width="3" height="5" rx="1" /><rect
            x="12"
            y="9"
            width="3"
            height="9"
            rx="1"
          /><rect x="17" y="5" width="3" height="13" rx="1" />
        <% "line" -> %>
          <path d="M3 3v16a2 2 0 0 0 2 2h16" /><path d="m19 9-5 5-4-4-3 3" />
        <% "pie" -> %>
          <path d="M21.21 15.89A10 10 0 1 1 8 2.83" /><path d="M22 12A10 10 0 0 0 12 2v10z" />
        <% kind when kind in ["radar", "radial"] -> %>
          <path d="M21 16V8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16z" />
        <% "tooltip" -> %>
          <path d="M4.037 4.688a.495.495 0 0 1 .651-.651l16 6.5a.5.5 0 0 1-.063.947l-6.124 1.58a2 2 0 0 0-1.438 1.435l-1.579 6.126a.5.5 0 0 1-.947.063z" />
        <% _ -> %>
          <path d="M3 3v16a2 2 0 0 0 2 2h16" /><path d="M7 11.207a.5.5 0 0 1 .146-.353l2-2a.5.5 0 0 1 .708 0l3.292 3.292a.5.5 0 0 0 .708 0l4.292-4.292a.5.5 0 0 1 .854.353V16a1 1 0 0 1-1 1H8a1 1 0 0 1-1-1z" />
      <% end %>
    </svg>
    """
  end

  # Renders the HEEx a user would write to reproduce this chart.
  defp chart_code(card, chart_id) do
    lines =
      [
        ~s(  id="#{chart_id}"),
        ~s(  type="#{card.type}"),
        card.variant && ~s(  variant="#{card.variant}"),
        card.keys != ["value"] && "  keys={#{inspect(card.keys)}}",
        card.legend && "  legend",
        card.colors && "  colors={#{inspect(card.colors)}}",
        "  data={#{data_literal(card.data, card.keys)}}"
      ]
      |> Enum.reject(&(&1 in [nil, false]))

    "<.chart\n" <> Enum.join(lines, "\n") <> "\n/>"
  end

  defp data_literal(rows, keys) do
    inner =
      Enum.map_join(rows, ",\n", fn row ->
        pairs =
          [{:label, Map.get(row, :label)}] ++
            Enum.map(keys, fn k -> {String.to_atom(k), Map.get(row, String.to_atom(k))} end)

        "    %{" <> Enum.map_join(pairs, ", ", fn {k, v} -> "#{k}: #{inspect(v)}" end) <> "}"
      end)

    "[\n#{inner}\n  ]"
  end

  # Full-width cards sit alone in their row, so a fixed height keeps them the same size as
  # the other examples. Other cards fill their row (so a non-legend card beside a taller
  # legend card has no dead space) with a minimum that reserves space before they load.
  defp chart_class(legend?, true),
    do: if(legend?, do: "h-[300px] w-full", else: "h-[250px] w-full")

  defp chart_class(true, false), do: "h-full min-h-[300px] w-full"
  defp chart_class(false, false), do: "h-full min-h-[250px] w-full"

  attr :footer, :any, required: true

  defp chart_footer(%{footer: {:trend, text}} = assigns) do
    assigns = assign(assigns, :text, text)

    ~H"""
    <div class="flex items-center gap-2 text-sm leading-none font-medium">
      {@text} <.trending_up_icon />
    </div>
    """
  end

  defp chart_footer(%{footer: {:trend, text, range}} = assigns) do
    assigns = assigns |> assign(:text, text) |> assign(:range, range)

    ~H"""
    <div class="flex w-full flex-col items-start gap-2 text-sm">
      <div class="flex items-center gap-2 leading-none font-medium">
        {@text} <.trending_up_icon />
      </div>
      <div class="text-muted-foreground leading-none">{@range}</div>
    </div>
    """
  end

  defp chart_footer(%{footer: {:note, text}} = assigns) do
    assigns = assign(assigns, :text, text)

    ~H"""
    <div class="text-muted-foreground flex items-center gap-2 text-sm leading-none">
      {@text}
    </div>
    """
  end

  defp chart_footer(%{footer: {:stats, stats}} = assigns) do
    assigns = assign(assigns, :stats, stats)

    ~H"""
    <div class="flex w-full items-center gap-6">
      <div :for={{label, value} <- @stats} class="flex flex-col gap-1">
        <span class="text-muted-foreground text-xs">{label}</span>
        <span class="text-lg font-bold tabular-nums leading-none">{value}</span>
      </div>
    </div>
    """
  end

  defp trending_up_icon(assigns) do
    ~H"""
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
      <polyline points="22 7 13.5 15.5 8.5 10.5 2 17" />
      <polyline points="16 7 22 7 22 13" />
    </svg>
    """
  end
end
